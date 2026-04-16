# Global Instructions for Claude Code

## Shell tools

- CODE STRUCTURE → `ast-grep` (`sg`)
- FILES → `fd`
- TEXT/strings → `rg`
- DOCS → use `markitdown` for document-to-Markdown first; common inputs: PDF, DOCX, PPTX, XLSX, HTML, CSV, JSON, XML, EPUB, images
- `markitdown input.pdf -o output.md`
- If `markitdown` fails or output is poor, try `pandoc`: `pandoc input.docx -t gfm -o output.md`

## Python

Use `uv` for Python workflows.
Avoid `pip`, `pip3`, or `python -m pip` unless explicitly asked.
