$OldURL = "example.xyz"
$NewURL = "example.xyz"
$RMMServices = ("Mesh Agent", "tacticalrmm")
$MeshPath = "C:\Program Files\Mesh Agent\MeshAgent.msh"

reg add HKEY_LOCAL_MACHINE\SOFTWARE\TacticalRMM /f /v ApiURL /d api.$NewURL
reg add HKEY_LOCAL_MACHINE\SOFTWARE\TacticalRMM /f /v BaseURL /d https://api.$NewURL

((Get-Content -Raw -Path $MeshPath) -replace $OldURL,$NewURL) | Set-Content -Path $MeshPath

Restart-Service -Name "$RMMServices"
