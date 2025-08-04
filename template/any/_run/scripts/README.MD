# Bash Utility Scripts for Poly-Repo Automation

A concise collection of Bash helpers that automate routine DevOps tasks in a polyglot monorepo:

| Script                  | What it does                                                                                                                                                                  |
|-------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `env_template.sh`       | Recursively scans for `.env` files and produces sanitized `.env-template` stubs with secrets stripped out.                                                                    |
| `git.sh`                | Convenience wrapper around Git for branch / hash / tag queries and for installing or removing simple Git hooks.                                                               |
| `sys.sh`                | Minimal project-metadata service: reads / increments semantic version, returns project name, and writes changes back to `values/ver.txt`.                                     |
| `json_creator_const.sh` | Generates a **JSON** file (`target/value_project.json` by default) that embeds build-time metadata such as project name, semantic version, Git hash and the last update date. |

> **Directory structure**
>
> ```
> _run
> ├─ scripts/
> │  ├─ env_template.sh
> │  ├─ git.sh
> │  └─ sys.sh
> ├─ json_creator_const.sh      # lives at repo root
> ├─ values/
> │  ├─ name.txt                # single-line project name
> │  └─ ver.txt                 # semantic version, e.g. 0.9.7
> └─ target/                    # JSON constants land here
> ```

## Prerequisites

* **Bash 5+**
* **Git** — hooks and metadata
* Linux/macOS; Windows users can run under WSL or Git Bash  
  (no external dependencies such as Go are required in this flavour).

## Quick start

```bash
# 1. Make the scripts executable once after cloning
chmod +x *.sh json_creator_const.sh

# 2. Generate sample .env-template files
env_template.sh

# 3. Bump patch version and regenerate JSON constants
sys.sh --increment --patch
json_creator_const.sh
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
_run/scripts/sys.sh --name                # prints project name
_run/scripts/sys.sh --ver                 # prints full version (e.g. 0.9.7)
_run/scripts/sys.sh --major               # prints major part (0)
_run/scripts/sys.sh --minor               # prints minor part (9)
_run/scripts/sys.sh --patch               # prints patch part (7)

# Increment version in-place
_run/scripts/sys.sh --increment --minor   # 0.10.0
_run/scripts/sys.sh --increment --patch   # 0.10.1
```

### `json_creator_const.sh`

By default it writes `target/value_project.json`.
Edit the variables at the top of the script (`dir_path`, `file_name`) if you need a different location.

```bash
json_creator_const.sh
```

### `env_template.sh`

```bash
env_template.sh
```

## Integrating with CI / CD

Add the following to your pipeline before building or packaging:

```bash
_run/scripts/env_template.sh        # keep env stubs fresh
_run/scripts/sys.sh --increment --patch
_run/scripts/json_creator_const.sh        # embed build metadata in JSON
```
