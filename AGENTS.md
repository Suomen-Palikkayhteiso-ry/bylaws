This project is for drafting and reviewing bylaw changes for a Finnish NGO.

## Agent Workflow

1.  **Activate Development Environment:**
    *   This project uses `devenv` for managing its development environment.
    *   To activate the environment, run `devenv shell` in the project root. This will make all necessary tools (like `pandoc`, `latexdiff`, `pdflatex`, `make`, `curl`, `entr`, `python3`, `diff-match-patch`) available in your shell.
2.  **Read the Instructions:** All proposals to be implemented are detailed in `INSTRUCTIONS.md`. Read this file first.
3.  **Consult References:** The `references/` directory contains official guidelines and examples from the Finnish Patent and Registration Office (PRH). Use these to ensure the legality and correctness of all changes. The `current.md` file contains the current, unchanged bylaws, against which all proposals are now diffed.
4.  **Implement Proposals:**
    *   Each proposal is a markdown file in the root directory (e.g., `01.md`).
    *   To implement a proposal, modify the corresponding markdown file.
5.  **Create a New Proposal:**
    *   To create a new proposal, copy `00.md` to a new `NN.md` file (e.g., `04.md`).
    *   Modify the new file.
6.  **Generate Proposal PDFs:**
    *   To generate PDFs for all proposals, run `make`.
    *   This command generates a diff PDF for each proposal (e.g., `01-diff.pdf`).
    *   It also runs a Python script (`merge_proposals.py`) that automatically merges all proposals into a single `final.md` file, and generates `final-diff.pdf`.
    *   To automatically rebuild the PDFs when you save a file, run `make watch`.

This workflow is managed by a `Makefile` that relies on the `devenv` environment to provide the necessary tools.