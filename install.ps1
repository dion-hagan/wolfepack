# Installs the wolfepack setup into ~\.claude (Windows PowerShell 5.1 or PowerShell 7):
#   CLAUDE.md          -> ~\.claude\CLAUDE.md            (an existing, different one is backed up first)
#   skills\*           -> ~\.claude\skills\*             (an existing, different one is backed up first)
#   config.example.yaml  -> ~\.claude\wolfepack.config.yaml  (only if you have none; never overwritten)
#
# Safe to run again: unchanged files are left alone, nothing is deleted, and it never writes
# settings.json or any secret.
#
# Usage:  powershell -ExecutionPolicy Bypass -File .\install.ps1 [-DryRun]
# Set $env:CLAUDE_HOME to install somewhere other than ~\.claude (used for testing).

param([switch]$DryRun)

$ErrorActionPreference = 'Stop'

$Src = $PSScriptRoot
if ($env:CLAUDE_HOME) { $Dest = $env:CLAUDE_HOME } else { $Dest = Join-Path $HOME '.claude' }
$Stamp = Get-Date -Format 'yyyyMMdd-HHmmss'

function Say($m) { Write-Host $m }

function Act([scriptblock]$block, [string]$what) {
    if ($DryRun) { Write-Host "  [dry-run] $what" } else { & $block }
}

# One hash for a whole folder: relative path + file hash, sorted.
function Get-TreeHash([string]$root) {
    $rootFull = (Resolve-Path $root).Path.TrimEnd('\')
    $lines = Get-ChildItem -Path $rootFull -Recurse -File | Sort-Object FullName | ForEach-Object {
        $rel = $_.FullName.Substring($rootFull.Length)
        $rel + ':' + (Get-FileHash -Path $_.FullName -Algorithm SHA256).Hash
    }
    return ($lines -join "`n")
}

if (-not (Test-Path (Join-Path $Src 'CLAUDE.md')) -or -not (Test-Path (Join-Path $Src 'skills'))) {
    Write-Error "Run this script from a wolfepack checkout (CLAUDE.md and skills\ not found in $Src)."
    exit 1
}

Say 'wolfepack install'
Say "  from: $Src"
Say "  to:   $Dest"
if ($DryRun) { Say '  (dry run: nothing will be written)' }

Act { New-Item -ItemType Directory -Force -Path (Join-Path $Dest 'skills') | Out-Null } "mkdir $Dest\skills"

# 1. CLAUDE.md
$srcClaude = Join-Path $Src 'CLAUDE.md'
$dstClaude = Join-Path $Dest 'CLAUDE.md'
if (Test-Path $dstClaude) {
    $a = (Get-FileHash -Path $srcClaude -Algorithm SHA256).Hash
    $b = (Get-FileHash -Path $dstClaude -Algorithm SHA256).Hash
    if ($a -eq $b) {
        Say 'CLAUDE.md: already up to date'
    } else {
        Say "CLAUDE.md: differs; backing up to CLAUDE.md.bak-$Stamp and replacing"
        Act { Copy-Item -Path $dstClaude -Destination "$dstClaude.bak-$Stamp" } "backup CLAUDE.md"
        Act { Copy-Item -Path $srcClaude -Destination $dstClaude -Force } "copy CLAUDE.md"
    }
} else {
    Say 'CLAUDE.md: installing'
    Act { Copy-Item -Path $srcClaude -Destination $dstClaude } "copy CLAUDE.md"
}

# 2. skills
foreach ($dir in Get-ChildItem -Path (Join-Path $Src 'skills') -Directory) {
    $name = $dir.Name
    $target = Join-Path (Join-Path $Dest 'skills') $name
    if (Test-Path $target) {
        if ((Get-TreeHash $dir.FullName) -eq (Get-TreeHash $target)) {
            Say "skill ${name}: already up to date"
        } else {
            $backup = Join-Path $Dest "skills-backup-$Stamp"
            Say "skill ${name}: differs; moving the old one to skills-backup-$Stamp\$name and replacing"
            Act { New-Item -ItemType Directory -Force -Path $backup | Out-Null } "mkdir $backup"
            Act { Move-Item -Path $target -Destination (Join-Path $backup $name) } "move old $name"
            Act { Copy-Item -Path $dir.FullName -Destination $target -Recurse } "copy $name"
        }
    } else {
        Say "skill ${name}: installing"
        Act { Copy-Item -Path $dir.FullName -Destination $target -Recurse } "copy $name"
    }
}

# 3. config (never overwritten)
$dstConfig = Join-Path $Dest 'wolfepack.config.yaml'
if (Test-Path $dstConfig) {
    Say 'wolfepack.config.yaml: exists; left alone'
} else {
    Say 'wolfepack.config.yaml: installing the example; fill it in'
    Act { Copy-Item -Path (Join-Path $Src 'config.example.yaml') -Destination $dstConfig } "copy config"
}

Say ''
Say 'Done. Next steps:'
Say "  1. Edit $dstConfig and replace every <PLACEHOLDER>."
Say '  2. Set the desktop app settings in docs\desktop-app-settings.md.'
Say '  3. Start a session and paste agents\wolfe.md.'
