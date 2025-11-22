#!/usr/bin/env pwsh

[CmdletBinding()]
param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$IMAGE = 'hermes-dec:latest'
$TOOL = 'hbc-decompiler'

$files = [System.Collections.Generic.List[string]]::new()
$args = [System.Collections.Generic.List[string]]::new()

foreach ($arg in $Arguments) {
    if (Test-Path -LiteralPath $arg -PathType Leaf) {
        $files.Add($arg)
    }
    else {
        $args.Add($arg)
    }
}

if ($files.Count -eq 0) {
    docker run --rm -i $IMAGE $TOOL @args
    exit $LASTEXITCODE
}

$firstFile = $files[0]
$inputDir = Split-Path -Path (Resolve-Path -LiteralPath $firstFile) -Parent

$mappedFiles = $files | ForEach-Object {
    "/tmp/$((Get-Item -LiteralPath $_).Name)"
}

docker run --rm --volume "${inputDir}:/tmp:ro" -i $IMAGE $TOOL @args @mappedFiles
exit $LASTEXITCODE
