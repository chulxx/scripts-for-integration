# Scripts-for-Integration

A portable toolkit that lets you drop battle-tested CI / CD pipelines, Git hooks and helper scripts straight into any
repository—or fetch them on-demand from your IDE via `lazylosad.sh`.

It doesn't use any tags, links in comments, or other watermarks. Doesn't require internet, non-standard packages, or
root access. Can be safely used in any projects.

* **Language-agnostic core (`template.any`)** – minimal yet complete release pipeline, issue templates and local Git
  hooks that work for every stack.
* **Go-opinionated layer (`template.goland`)** – everything above plus Go-specific helpers (`go_tidy_all.sh`,
  `go_creator_const.sh`, etc.) and optional cross-compiling release workflow.

---

## Quick Start

```bash
# 1) Download the latest template archive (you choose which) into the current directory
curl -sSL https://raw.githubusercontent.com/voluminor/scripts-for-integration/main/lazylosad.sh \
  | bash

# 2) Run one-time project bootstrap
./_run/firststart.sh
````

> `lazylosad.sh` queries the GitHub API for the newest release, lists all assets that match
> `template.*.zip`, lets you pick the one you need, unpacks it and cleans up after itself.

---

## Template Catalog

### `template.any`

| Component                                             | Purpose                                                                                                                                                 |
|-------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------|
| **`.github/workflows/release.yml`**                   | Generates a clean build environment, bumps the semantic version in `_run/values/ver.txt`, pushes the tag and publishes a release with sources attached. |
| **Git hooks (`_run/commit-hook.sh`, `push-hook.sh`)** | Automate code formatting, secret scanning and version checks before every commit / push.                                                                |
| **`_run/scripts/**`**                                 | Small, composable Bash utilities for manipulating `.env` files, JSON, Git internals and OS-level tasks.                                                 |
| **Issue templates**                                   | Pre-filled bug and feature request forms to keep the backlog tidy.                                                                                      |

### `template.goland`

Everything from **`template.any`**, plus:

| Extra                                       | Details                                                                                                                                                            |
|---------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **`.github/workflows/tests.yml`**           | Matrix testing against multiple Go versions with built-in caching of Go modules.                                                                                   |
| **`.github/workflows/release.yml`**         | Same logic as the generic release, but tuned for Go projects (injects Go toolchain, runs `go generate`, tidies modules).                                           |
| **`.github/workflows/release+compile.yml`** | Extends the above with a dedicated **`build`** job that cross-compiles the binary for the runner’s OS, uploads it as an artifact and then proceeds to publication. |
| **Go helper scripts**                       | `go_tidy_all.sh` (recursive `go mod tidy`), `go_creator_const.sh` (inject build-time constants), plus Go-aware snippets inside `git.sh`.                           |

---

## Release Workflows for GoLand

| File                  | Main Jobs                   | What Happens                                                                                                                                                                                                                                                                                       |
|-----------------------|-----------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `release.yml`         | `prepare ➔ release`         | Creates a throw-away build env, updates `_run/values/ver.txt`, packages **source code** only, pushes tag and GitHub Release.                                                                                                                                                                       |
| `release+compile.yml` | `prepare ➔ build ➔ release` | All of the above **plus**: <br>• `build` compiles the project with `go build -ldflags="-s -w"`, names the artifact according to OS (`*.windows.exe`, `*.linux.bin`, etc.) and uploads it. <br>• Working tree is stripped of heavy assets before the final tag commit to keep release history lean. |

Choose **`release+compile.yml`** when you want ready-to-run binaries attached to every GitHub release; stick to *
*`release.yml`** if distributing source code is enough or if you build elsewhere (e.g. Docker images).

---

## Integrating `lazylosad.sh` with an IDE

1. **GoLand ≥2023.1**

    * *Settings → Tools → External Tools → +*
    * **Name:** *Fetch integration template*
    * **Program:** `/usr/bin/bash`
    * **Arguments:** `-c "/path/to/lazylosad.sh"`
    * **Working directory:** `$ProjectFileDir$`
      Invoke it from *Tools → External Tools* and the selected template is unpacked directly into the open project.

2. **VS Code**
   Add a task in `.vscode/tasks.json`:

   ```jsonc
   {
     "label": "Fetch integration template",
     "type": "shell",
     "command": "${workspaceFolder}/lazylosad.sh",
     "problemMatcher": []
   }
   ```

3. **Other editors / CI boxes** – run the script anywhere `bash`, `curl`, `jq` and `unzip` are available.

The script is self-contained, leaves no global state, and automatically removes its temporary directory. Point it at a
blank folder to start a fresh project, or at an existing repo to upgrade the integration layer without touching your
domain code.

---

## Directory Layout (after extraction)

```
.github/                 → GitHub Actions, composite actions and issue templates
_run/                    → Local automation entry-point
_run/scripts/            → Reusable Bash helpers
_run/values/             → Project metadata (name & current version)
lazylosad.sh             → On-demand template fetcher
```

Ready to automate? Run `./_run/firststart.sh`, commit, push and enjoy zero-click releases.
