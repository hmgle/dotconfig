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
- The body should explain the problem, motivation, and rationale; note trade-offs or alternatives when relevant
- In shell commits, use separate `-m` flags or an editor so the message has real newlines; never include literal `\n`
