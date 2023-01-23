#!/usr/bin/env bash

echo "Setting up git hooks..."

root=$(git rev-parse --show-toplevel)
hooks_src_path="$root/git-hooks"
hooks=$(ls "${hooks_src_path}")

if [ -z "$hooks" ]; then
    echo "No git hooks found"
    exit 0
fi

cd "$root"/.git/hooks || exit

for hook_path in "${hooks_src_path}"/*; do
    hook=$(basename "$hook_path")
    echo "Setting up $hook hook"
    ln -sf "$hook_path" "$hook"
done

echo "Done."
