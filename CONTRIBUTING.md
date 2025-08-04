# Contributing to **Scripts-for-Integration**

First off, thank you for taking the time to contribute!  
This project is only as good as the community behind it, and we appreciate your help.

---

## Table of Contents
1. [Code of Conduct](#code-of-conduct)  
2. [Ways to Contribute](#ways-to-contribute)  
3. [Getting Started Locally](#getting-started-locally)  
4. [Branching & Commit Guidelines](#branching--commit-guidelines)  
5. [Style Guide](#style-guide)  
6. [Testing & Self-Checks](#testing--self-checks)  
7. [Pull-Request Checklist](#pull-request-checklist)  
8. [Releases & Versioning](#releases--versioning)  
9. [License & Copyright](#license--copyright)

---

## Code of Conduct
This project adheres to the **Contributor Covenant**.  
By participating, you are expected to uphold the standards described in  
[`CODE_OF_CONDUCT.md`](./CODE_OF_CONDUCT.md). Please read it before starting.

---

## Ways to Contribute
| How                           | Where to Start | Notes |
|-------------------------------|----------------|-------|
| **Bug report**                | `Issues → Bug Report` template | Add repro steps / logs. |
| **Feature request / idea**    | `Issues → Feature Request` template | Explain *why* and potential alternatives. |
| **Code / docs improvements**  | Pull Request   | See guidelines below. |
| **Templates or workflows**    | Pull Request   | Keep each addition in its own `template.<name>` folder. |

---

## Getting Started Locally
```bash
git clone https://github.com/<YOUR_FORK>/scripts-for-integration.git
cd scripts-for-integration

# Install Git hooks & scaffold helper folders
bash _run/firststart.sh

# Optional: download the latest template into a project
./lazylosad.sh
````

**Prerequisites**

* Bash 4.4+ (Unix/macOS or WSL)
* `git` 2.20+
* `curl`, `jq` & `zip` (for `lazylosad.sh`)
* [shellcheck](https://www.shellcheck.net/) for local linting (recommended)

---

## Branching & Commit Guidelines

* **Base branch:** `main`
* **Feature branches:** `feat/<topic>`
* **Fix branches:** `fix/<issue-number>`
* **Documentation:** `docs/<area>`

A local *commit hook* automatically prefixes each commit message with
`<current-branch> [<semver>]`.
Please keep the rest of the message concise and imperative, e.g.

```
feat/git-hooks     Add pre-commit shellcheck runner
```

---

## Style Guide

| Area      | Tool / Convention                                        | Rule-of-thumb |
| --------- | -------------------------------------------------------- | ------------- |
| Bash      | POSIX where possible, `shellcheck` warnings = **0**      |               |
| YAML (CI) | 2-space indent, wrap at 120 chars                        |               |
| Markdown  | Hard-wrap at 100 chars, use fenced code blocks           |               |
| Filenames | Lower-case, kebab-case (`my-script.sh`)                  |               |
| Templates | Place each tech-specific layer inside `template.<stack>` |               |

---

## Testing & Self-Checks

Before pushing:

1. **Static analysis**

   ```bash
   shellcheck $(git ls-files '*.sh')
   ```

2. **Run hooks** (they execute automatically on commit/push, but you can trigger manually)

   ```bash
   bash _run/commit-hook.sh .git/COMMIT_EDITMSG  # commit message prefix
   bash _run/push-hook.sh                         # version bump
   ```

3. **Dry-run release workflow** if you changed `.github/workflows/*.yml`.

---

## Pull-Request Checklist

* [ ] One logical change per PR (avoid mixed concerns)
* [ ] Rebased on latest `main` (`git pull --rebase upstream main`)
* [ ] Passes `shellcheck` and any added tests
* [ ] CI runs green (GitHub Actions will run automatically)
* [ ] Updated `README.MD` or in-code docs if behavior changed
* [ ] Linked to **Issue** (closes # \<ID>) when applicable
* [ ] No generated or binary files committed (except under `/target` in release PRs)

---

## Releases & Versioning

This project follows **Semantic Versioning**.
Pushing an annotated tag like `v1.2.3` triggers the release workflow, which:

1. Builds artifacts (if any)
2. Publishes a GitHub Release with sources attached

The patch part of the version (`x.y.*`) is auto-incremented by the **push hook**.
For minor/major bumps, update `_run/values/ver.txt` **before** tagging.

---

## License & Copyright

Code contributions are accepted **under the terms of the project license**
(see [`LICENSE`](./LICENSE), GNU LGPL v2.1). By submitting a pull request you agree that your code may be distributed under the same license.

---

*Happy hacking, and thank you for helping make Scripts-for-Integration better!*
