#!/bin/bash

echo "Generate env-template"

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
values_dir="$(dirname "$script_dir")"
root_path="$(dirname "$values_dir")"

#############################################################################

cd "$root_path"

find -type f -name ".env" | while read env_file; do
    template_file="$(dirname "$env_file")/.env-template"

    > "$template_file"

    while IFS= read -r line; do
        if [[ "$line" =~ ^[[:space:]]*# || "$line" =~ ^[[:space:]]*$ ]]; then
            echo "$line" >> "$template_file"
            continue
        fi

        if [[ "$line" == *"="* ]]; then
            var_name="${line%%=*}"
            echo "${var_name}=####" >> "$template_file"
        else
            echo "$line" >> "$template_file"
        fi
    done < "$env_file"

    echo "created $template_file based on $env_file"
done

exit 0