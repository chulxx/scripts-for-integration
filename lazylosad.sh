#!/usr/bin/bash
set -Eeuo pipefail

REPO="voluminor/scripts-for-integration"
API="https://api.github.com/repos/$REPO/releases/latest"

#############################################################################

echo "📡  Getting information about the latest release of $REPO..."
json=$(curl -sSL "$API") || { echo "⚠️  Error querying GitHub API."; exit 1; }

mapfile -t names < <(jq -r '.assets[]|select(.name|test("^template\\..*\\.zip$")).name'                <<<"$json")
mapfile -t urls  < <(jq -r '.assets[]|select(.name|test("^template\\..*\\.zip$")).browser_download_url' <<<"$json")

[[ ${#names[@]} -eq 0 ]] && { echo "❌  No template.*.zip in the release"; exit 1; }

#############################################################################

labels=()
for n in "${names[@]}"; do
  mid=${n#"template."}
  labels+=( "${mid%.zip}" )
done

while true; do
  echo -e "\nAvailable templates:"
  for l in "${labels[@]}"; do echo "  • $l"; done
  read -rp $'\nEnter template name (or q / quit to exit): ' input

  lc=$(tr '[:upper:]' '[:lower:]' <<<"${input//[$'\t\r\n']}")

  [[ "$lc" == "q" || "$lc" == "quit" ]] && echo "⏹️  Exit." && exit 0

  sel=-1
  for i in "${!labels[@]}"; do
    if [[ "$lc" == "$(tr '[:upper:]' '[:lower:]' <<<"${labels[$i]}")" ]]; then
      sel=$i; break
    fi
  done

  if [[ $sel -ge 0 ]]; then
    idx=$sel
    break
  else
    echo "❌  Invalid name. Try again."
  fi
done

#############################################################################

choice="${names[$idx]}"
url="${urls[$idx]}"
echo -e "\n✅  Selected: $choice"

tmpdir=$(mktemp -d); trap 'rm -rf "$tmpdir"' EXIT
archive="$tmpdir/$choice"

echo "⬇️  Downloading $choice..."
curl -#L -o "$archive" "$url"

echo "📦  Unpacking to $(pwd)..."
unzip -oq "$archive" -d .

echo "🎉  Done!"