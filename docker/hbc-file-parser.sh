#!/usr/bin/env bash

readonly IMAGE="hermes-dec:latest"
readonly TOOL="hbc-file-parser"

FILES=()
ARGS=()

for arg in "$@"; do
    if [[ -e "$arg" ]]; then
        FILES+=("$arg")
    else
        ARGS+=("$arg")
    fi
done

if [[ ${#FILES[@]} -eq 0 ]]; then
    docker run --rm -i "$IMAGE" $TOOL "${ARGS[@]}"
    exit 0
fi

FIRST_FILE="${FILES[0]}"
INPUT_DIR=$(cd "$(dirname "$FIRST_FILE")" && pwd -P)

MAPPED_FILES=()
for file in "${FILES[@]}"; do
    MAPPED_FILES+=("/tmp/$(basename "$file")")
done

docker run --rm --volume "$INPUT_DIR":/tmp:ro -i "$IMAGE" $TOOL "${ARGS[@]}" "${MAPPED_FILES[@]}"
