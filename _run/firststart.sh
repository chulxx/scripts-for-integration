#!/bin/bash

run_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
script_dir="$run_dir/scripts"
root_path=$(cd "$run_dir/.." && pwd)

bash "$script_dir/git.sh" --add_commit
bash "$script_dir/git.sh" --add_push

cd "$root_path"

mkdir -p target
mkdir -p tmp

bash "$script_dir/json_creator_const.sh"