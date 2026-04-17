# Global Instructions

## Shell tools

- CODE STRUCTURE → `ast-grep` (`sg`)
- FILES → `fd`
- TEXT/strings → `rg`
- DOCS → use `markitdown` for document-to-Markdown first; common inputs: PDF, DOCX, etc. `markitdown input.pdf -o output.md`. If `markitdown` fails or output is poor, try `pandoc`

## Python

Use `uv` for Python workflows.
Avoid `pip`, `pip3`, or `python -m pip` unless explicitly asked.

## Git commits

- Follow the 50/72 rule
- Use a specific imperative subject
- Unless the subject fully explains the change, include a body after one blank line
- The body should explain why the change is needed; note trade-offs when relevant
- In shell commits, never use `\n` inside `-m`; use separate `-m` flags or an editor
