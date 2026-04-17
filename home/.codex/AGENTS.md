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

- Follow the 50/72 rule: keep the subject within 50 characters and wrap body lines near 72 characters
- Use a specific imperative subject
- Unless the subject fully explains the change, include a body after exactly one blank line
- The body should explain why the change is needed; note trade-offs when relevant
- In the body, blank lines separate paragraphs; they are not for wrapping a long paragraph
- In shell commits, each `-m` adds one paragraph; use one `-m` for the subject and one `-m` per body paragraph
- Never use `\n` inside `-m`; the shell passes it literally
- If one paragraph needs manual line wrapping, use an editor or `git commit -F` instead of extra `-m` flags
