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
- When creating commits from the shell, pass the subject and body as separate `-m` arguments or use an editor/heredoc with real newlines
- Never include literal escape sequences like `\n` in commit messages; if you see them in the preview, stop and fix the command before committing
