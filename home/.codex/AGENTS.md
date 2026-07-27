# Global Instructions

## Shell tools

- CODE STRUCTURE → `ast-grep` (`sg`)
- FILES → `fd`
- TEXT/strings → `rg`
- DOCS → use `markitdown` for document-to-Markdown first; common inputs: PDF, DOCX, etc. `markitdown input.pdf -o output.md`. If `markitdown` fails or output is poor, try `pandoc`
- GITHUB → `gh` for read-only; writes need explicit permission.

## Python

Use `uv` for Python workflows.
Avoid `pip`, `pip3`, or `python -m pip` unless explicitly asked.

## Git commits

- In a Git repository, treat committing as part of completing the requested work. Work in small, incremental steps and create atomic commits without waiting for an explicit request, unless the user asks you not to commit.
- As soon as a logically independent change is complete and its relevant build or test checks pass, commit it before starting another logical change. Do not let completed, unrelated changes accumulate into one large commit.
- If no automated check applies, review the diff for the completed change before committing it.
- Before each commit, inspect the working tree and staged diff. Stage only the files or hunks that belong to that logical change, and preserve unrelated user changes.
- Leave pre-existing untracked files that you did not create untracked. They are often internal documentation or local working files; do not include them in a commit unless the user explicitly asks you to.
