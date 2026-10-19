# Operation Helmsman - pre-flight check (Windows PowerShell 5.1+ / PowerShell 7+)
$script:Failed = $false
function Ok([string]$Msg) { Write-Host "  [ OK ] $Msg" }
function Ko([string]$Msg) { Write-Host "  [FAIL] $Msg"; $script:Failed = $true }
function Has([string]$Cmd) { [bool](Get-Command $Cmd -ErrorAction SilentlyContinue) }

Write-Host "Pre-flight check"

# kubectl
if (Has 'kubectl') {
    $kv = ''
    try { $kv = (kubectl version --client -o json 2>$null | Out-String | ConvertFrom-Json).clientVersion.gitVersion } catch {}
    Ok "kubectl $kv"
} else { Ko "kubectl not found" }

# helm
$helmVer = ''
if (Has 'helm') {
    $helmVer = ((helm version --short 2>$null) | Select-Object -First 1)
    Ok "helm $helmVer"
} else { Ko "helm not found  ->  https://helm.sh/docs/intro/install/" }

if     ($helmVer -like 'v4*') { Ok "Helm 4 detected" }
elseif ($helmVer -like 'v3*') { Write-Host "  [WARN] Helm 3 detected - labs work, but flag names differ (--atomic vs --rollback-on-failure)" }

# kubectl kustomize (built-in)
if (Has 'kubectl') {
    kubectl kustomize --help *> $null
    if ($LASTEXITCODE -eq 0) { Ok "kubectl kustomize (built-in)" } else { Ko "kubectl kustomize missing" }
} else { Ko "kubectl kustomize missing" }

# standalone kustomize (optional)
if (Has 'kustomize') {
    $kz = ((kustomize version 2>$null) | Select-Object -First 1)
    Ok "standalone kustomize $kz (optional)"
} else { Write-Host "  [INFO] standalone kustomize not installed (optional)" }

# cluster reachability
$reachable = $false
if (Has 'kubectl') {
    kubectl cluster-info *> $null
    $reachable = ($LASTEXITCODE -eq 0)
}
if ($reachable) { Ok "cluster reachable: $(kubectl config current-context 2>$null)" }
else { Ko "no cluster - run: minikube start" }

if (-not $script:Failed) { Write-Host "All systems go. Welcome aboard, helmsman." }
else { Write-Host "Fix the FAILs above before Mission 1." }
