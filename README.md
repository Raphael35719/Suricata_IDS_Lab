# Suricata Practical Lab Workflow

A GitHub-ready workspace for documenting a Suricata practical covering configuration, custom rules, ICMP/HTTP/UDP/SSH/DNS alerts, and review of `fast.log` and `eve.json`.

## Folders
- `docs/`: objectives, environment, procedure notes, and lab workflow.
- `evidence/`: genuine screenshots and sanitized outputs collected during the lab.
- `git workflow/`: Git Bash instructions for committing and pushing to GitHub.
- `results/`: observed outcomes and conclusions.
- `scripts/`: a helper for checking Suricata version and common log paths.
- `suricata/`: configuration notes and a starter custom-rules file.
- `tests/`: test matrix for the five protocols and both log formats.

## Suggested order
1. Read `docs/LAB_WORKFLOW.md` and fill out `docs/LAB_NOTES_TEMPLATE.md`.
2. Record your actual configuration and rules paths in `suricata/`.
3. Create and validate custom rules as required by your lab guide.
4. Perform the assigned protocol tests only in your own lab or an explicitly authorized environment.
5. Review `fast.log` and `eve.json`, and document observed results.
6. Save genuine evidence, review for sensitive information, then follow `git workflow/GIT_BASH_GUIDE.md`.

This is a workflow template, not proof that the lab is complete. Mark tests as passed only after checking real output. Back up configuration before editing it. Paths vary by installation. Never publish credentials, private keys, sensitive PCAPs, or unredacted logs. Only monitor authorized systems and networks.
