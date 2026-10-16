#!/usr/bin/env python3
"""Run with: uv run --no-project tests/zsh-osc7.py"""

import errno
import os
from pathlib import Path
import select
import signal
import subprocess
import tempfile
import termios
import time
import tty
import unittest


class Osc7Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.temp = tempfile.TemporaryDirectory(prefix="dotconfig-osc7-")
        cls.hook = Path(cls.temp.name) / "hook.zsh"
        rc = (Path(__file__).resolve().parents[1] / "home/.zshrc").read_text()
        cls.hook.write_text(rc.split(
            "# tmux-nexus: report the current directory through OSC 7.\n", 1
        )[1])

    @classmethod
    def tearDownClass(cls):
        cls.temp.cleanup()

    def command(self, script):
        return ["zsh", "-df", "-c", 'source "$1"\n' + script,
                "osc7-test", str(self.hook)]

    def test_encoding_options_and_reload(self):
        result = subprocess.run(self.command(r'''
            __tmux_nexus_osc7() { return 99; }
            source "$1"
            source "$1"
            [[ ${#precmd_functions} == 1 ]] || exit 1
            [[ $precmd_functions[1] == __tmux_nexus_osc7 ]] || exit 2
            setopt ksharrays shwordsplit
            __tmux_nexus_urlencode '/中文 /a#b?c%'
            [[ $REPLY == '/%E4%B8%AD%E6%96%87%20/a%23b%3Fc%25' ]] || exit 3
            [[ -o ksharrays && -o shwordsplit ]] || exit 4
            print -r -- OK
        '''), capture_output=True, timeout=5)
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(result.stdout, b"OK\n")
        self.assertEqual(result.stderr, b"")

    def test_redirected_output_and_status(self):
        result = subprocess.run(self.command('''
            previous() { return 23; }
            previous
            __tmux_nexus_osc7
            exit $?
        '''), capture_output=True, timeout=5)
        self.assertEqual(result.returncode, 23)
        self.assertEqual(result.stdout, b"")
        self.assertEqual(result.stderr, b"")

    def test_missing_module_removes_stale_hook(self):
        result = subprocess.run(self.command(r'''
            zmodload() { return 1; }
            source "$1"
            [[ ${precmd_functions[(Ie)__tmux_nexus_osc7]:-0} == 0 ]]
        '''), capture_output=True, timeout=5)
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(result.stdout, b"")
        self.assertEqual(result.stderr, b"")

    def test_terminal_write_survives_sigchld(self):
        master, slave = os.openpty()
        process = None
        try:
            tty.setraw(slave)
            # Block the hook's terminal write, then interrupt it with SIGCHLD.
            termios.tcflow(slave, termios.TCOOFF)
            process = subprocess.Popen(self.command(r'''
                HOST=osc7-test
                PWD='/中文 /a#b?c%'
                print -ru2 -- READY
                previous() { return 23; }
                previous
                __tmux_nexus_osc7
                result=$?
                print -ru2 -- "STATUS=$result"
                exit "$result"
            '''), stdin=subprocess.DEVNULL, stdout=slave, stderr=subprocess.PIPE)
            self.assertTrue(select.select([process.stderr], [], [], 5)[0])
            self.assertEqual(process.stderr.readline(), b"READY\n")
            time.sleep(0.1)
            self.assertIsNone(process.poll())
            os.kill(process.pid, signal.SIGCHLD)
            time.sleep(0.1)
            self.assertIsNone(process.poll(), "interrupted hook exited early")
            termios.tcflow(slave, termios.TCOON)
            os.close(slave)
            slave = None

            output = bytearray()
            deadline = time.monotonic() + 5
            while select.select([master], [], [], max(0, deadline - time.monotonic()))[0]:
                try:
                    chunk = os.read(master, 65536)
                except OSError as error:
                    if error.errno == errno.EIO:
                        break
                    raise
                if not chunk:
                    break
                output.extend(chunk)
                if time.monotonic() >= deadline:
                    self.fail("terminal output did not finish")

            _, errors = process.communicate(timeout=5)
            self.assertEqual(process.returncode, 23)
            self.assertEqual(errors, b"STATUS=23\n")
            expected = (b"\x1b]7;file://osc7-test/"
                        b"%E4%B8%AD%E6%96%87%20/a%23b%3Fc%25\x1b\\")
            self.assertEqual(output, expected)
        finally:
            if process is not None:
                if process.poll() is None:
                    process.kill()
                process.communicate(timeout=5)
            os.close(master)
            if slave is not None:
                os.close(slave)


if __name__ == "__main__":
    unittest.main()
