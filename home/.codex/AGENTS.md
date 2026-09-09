# Global Instructions

## Tools

- Code structure searches: `ast-grep`.
- File searches: `fd`.
- Text searches: `rg`.
- Document-to-Markdown conversion: use `anydoc` first; try `pandoc` if it fails or produces poor output.
- GitHub: use `gh`; remote writes require explicit user authorization.

## Python

Use `uv` for Python workflows; use `pip`, `pip3`, or `python -m pip` only when explicitly requested.

## Git commits

- Commit each logically independent change after completion and relevant checks pass, unless the user asks otherwise.
- Include only changes made for the current task. Leave pre-existing changes (including untracked files) uncommitted unless explicitly requested.

## Deliverables

Do not reproduce operating rules or agent instructions in deliverables unless they are part of the requested content.
