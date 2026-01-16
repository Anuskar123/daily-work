# Generates a daily project log entry, commits, and pushes.
# Run manually or via Task Scheduler.

$repoRoot = Split-Path -Parent $PSScriptRoot
Set-Location $repoRoot

$utcNow = (Get-Date).ToUniversalTime()
$day = $utcNow.ToString('yyyy-MM-dd')
$timestamp = $utcNow.ToString('HHmmss')
$filePath = Join-Path $repoRoot "daily/${day}-${timestamp}.md"

New-Item -ItemType Directory -Path (Split-Path $filePath -Parent) -Force | Out-Null

$seed = [int64]$utcNow.ToString('yyyyMMddHHmmss')

$focusChoices = @(
    'Literature review synthesis'
    'Methodology refinement'
    'Data pipeline prototyping'
    'Model evaluation'
    'Writing and structure'
    'Results visualization'
    'Experiments and ablations'
)
$progressItems = @(
    'Documented insights from today''s reading.'
    'Refined experiment configuration and tracked parameters.'
    'Ran a small batch test to validate assumptions.'
    'Updated notes with blockers and next steps.'
    'Improved section outline for the dissertation chapter.'
    'Captured metrics from the latest run and compared against baseline.'
    'Cleaned data artifacts and ensured reproducibility scripts run cleanly.'
)
$nextItems = @(
    'Expand experiment grid and capture comparative metrics.'
    'Draft a concise summary paragraph for today''s findings.'
    'Re-run preprocessing with adjusted parameters.'
    'Tighten methodology write-up and add citations.'
    'Produce updated plots for the results section.'
    'Review related work to position findings better.'
)

function PickItem([object[]]$array) {
    return $array[$seed % $array.Count]
}

$focus = PickItem $focusChoices
$progress1 = PickItem $progressItems
$progress2 = PickItem $nextItems

$content = @"
# Progress Log — $day $timestamp UTC

## Focus
- $focus

## Progress
- $progress1
- $progress2

## Next
- Continue refining tomorrow based on today's findings.
- Add any new references that emerge.
"@

Set-Content -Path $filePath -Value $content -NoNewline:$false

$gitAdd = git add daily/ 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Error "git add failed: $gitAdd"
    exit $LASTEXITCODE
}

git diff --cached --quiet
if ($LASTEXITCODE -eq 0) {
    Write-Host "No staged changes; exiting." -ForegroundColor Yellow
    exit 0
}

$commitMsg = "docs: log $day-$timestamp progress"
$gitCommit = git commit -m $commitMsg 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Error "git commit failed: $gitCommit"
    exit $LASTEXITCODE
}

$gitPush = git push origin HEAD:main 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Error "git push failed: $gitPush"
    exit $LASTEXITCODE
}

Write-Host "Daily log created, committed, and pushed for $day." -ForegroundColor Green
