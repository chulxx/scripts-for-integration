# Bash Utility Scripts for Go Projects

A small collection of opinionated Bash helpers that automate routine tasks in a Go-based monorepo:

| Script                | What it does                                                                                                                                                          |
|-----------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `env_template.sh`     | Recursively scans for `.env` files and produces sanitized `.env-template` stubs with secrets stripped out.                                                            |
| `go_tidy_all.sh`      | Runs `go mod tidy` in every Go module under the repository root (skips `.git`, `tmp`, `_run`, etc.).                                                                  |
| `go_creator_const.sh` | Generates a Go source file (`target/value_project.go` by default) that exposes build-time constants such as project name, version, Git hash and the last update date. |
| `git.sh`              | Convenience wrapper around Git for branch / hash / tag queries and for installing or removing simple Git hooks.                                                       |
| `sys.sh`              | Minimal project-metadata service: reads / increments semantic version, returns project name, and writes changes back to `values/ver.txt`.                             |

> **Directory structure**
>
> ```
> _run
> ├─ scripts/                 # or any folder you keep the five .sh files in
> │  ├─ env_template.sh
> │  ├─ go_tidy_all.sh
> │  ├─ go_creator_const.sh
> │  ├─ git.sh
> │  └─ sys.sh
> └─ values/
>    ├─ name.txt              # single-line project name
>    └─ ver.txt               # semantic version, e.g. 1.4.2
> ```

## Prerequisites

* **Bash 5+**
* **Go 1.20+** (for `go_tidy_all.sh` and the code produced by `go_creator_const.sh`)
* **Git** — hooks and metadata
* Linux/macOS; Windows users can run under WSL or Git Bash

## Quick start

```bash
# 1. Make the scripts executable once after cloning
chmod +x *.sh

# 2. Generate sample .env-template files
env_template.sh

# 3. Tidy all Go modules
go_tidy_all.sh

# 4. Bump patch version and regenerate the constants file
sys.sh --increment --patch
go_creator_const.sh
````

## Usage examples

### `git.sh`

```bash
# Install a commit-msg hook
_run/scripts/git.sh --add_commit          # same as -ac

# Install a pre-push hook
_run/scripts/git.sh --add_push            # same as -ap

# Remove hooks
_run/scripts/git.sh --del_commit          # same as -dc
_run/scripts/git.sh --del_push            # same as -dp

# Show metadata
_run/scripts/git.sh --branch              # current branch name
_run/scripts/git.sh --hash                # full commit hash of HEAD
_run/scripts/git.sh --tag                 # most recent tag
```

### `sys.sh`

```bash
_run/scripts/sys.sh --name                # prints project name from values/name.txt
_run/scripts/sys.sh --ver                 # prints full version (e.g. 1.4.2)
_run/scripts/sys.sh --major               # prints major part (1)
_run/scripts/sys.sh --minor               # prints minor part (4)
_run/scripts/sys.sh --patch               # prints patch part (2)

# Increment version in-place
_run/scripts/sys.sh --increment --minor   # 1.5.0
_run/scripts/sys.sh --increment --patch   # 1.5.1
```

### `go_creator_const.sh`

By default it writes `target/value_project.go`.
Edit the variables at the top of the script (`dir_path`, `file_name`, `package_name`) if you need a different location.

```bash
go_creator_const.sh
```

### `go_tidy_all.sh`

```bash
go_tidy_all.sh
```

### `env_template.sh`

```bash
env_template.sh
```

## Integrating with CI / CD

Add the following to your pipeline before building your binaries:

```bash
_run/scripts/env_template.sh       # keep env stubs fresh
_run/scripts/go_tidy_all.sh        # ensure tidy modules
_run/scripts/go_creator_const.sh   # embed build metadata
```

