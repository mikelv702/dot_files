#!/usr/bin/env bash

# Find and remove broken symlinks in $HOME
# Run with --dry-run to preview without deleting

set -e

DRY_RUN=false
if [ "$1" = "--dry-run" ]; then
    DRY_RUN=true
fi

echo "Scanning $HOME for broken symlinks..."

broken=()
while IFS= read -r -d '' link; do
    broken+=("$link")
done < <(find "$HOME" -maxdepth 3 -xtype l -print0 2>/dev/null)

if [ ${#broken[@]} -eq 0 ]; then
    echo "No broken symlinks found."
    exit 0
fi

echo "Found ${#broken[@]} broken symlink(s):"
for link in "${broken[@]}"; do
    target=$(readlink "$link")
    echo "  $link -> $target"
done

if [ "$DRY_RUN" = true ]; then
    echo ""
    echo "Dry run — no files removed. Run without --dry-run to delete."
    exit 0
fi

echo ""
read -p "Remove all broken symlinks? [y/N] " confirm
if [[ "$confirm" =~ ^[Yy]$ ]]; then
    for link in "${broken[@]}"; do
        rm -v "$link"
    done
    echo "Done!"
else
    echo "Aborted."
fi
