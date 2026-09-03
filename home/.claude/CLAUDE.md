# Global Instructions for Claude Code

## Shell tools

- CODE STRUCTURE → `ast-grep`
- FILES → `fd`
- TEXT/strings → `rg`
- GITHUB → `gh` for read-only; writes need explicit permission
- DOCS → use `anydoc` for document-to-Markdown first; common inputs: PDF, DOCX, XLSX, etc. `anydoc input.pdf -o output.md`. If `anydoc` fails or output is poor, try `pandoc`

## Python

Use `uv` for Python workflows.
Avoid `pip`, `pip3`, or `python -m pip` unless explicitly asked.

## Git commits

- Proactively commit each logically independent change once complete and relevant checks pass, unless the user asks you not to. Keep commits small and atomic.
- Leave pre-existing untracked files uncommitted unless explicitly requested.
