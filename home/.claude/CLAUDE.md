# Global Instructions for Claude Code

## Shell tools

- CODE STRUCTURE → `ast-grep` (`sg`)
- FILES → `fd`
- TEXT/strings → `rg`
- GITHUB → `gh` for read-only; writes need explicit permission
- DOCS → use `markitdown` for document-to-Markdown first; common inputs: PDF, DOCX, PPTX, XLSX, HTML, CSV, JSON, XML, EPUB, images
- `markitdown input.pdf -o output.md`
- If `markitdown` fails or output is poor, try `pandoc`: `pandoc input.docx -t gfm -o output.md`

## Python

Use `uv` for Python workflows.
Avoid `pip`, `pip3`, or `python -m pip` unless explicitly asked.

## Git commits

- Proactively commit each logically independent change once complete and relevant checks pass, unless the user asks you not to. Keep commits small and atomic.
- Leave pre-existing untracked files uncommitted unless explicitly requested.
