# Title: 	Create new server in Vultr
# Author: 	Doodk
# Version: 	1.0.0
# Date:		2019/02/15

$key = ""
$SNAPSHOTID = ""

$DCID = "0"
do {
    Write-Host "Please selection from the following list for server region:"
    Write-Host "  1: Atlanta (US-GA)"
    Write-Host "  2: Dallas  (US-TX) (w/ ddos)"
    Write-Host "  3: Toronto (CA)"

    $sel = (Read-Host -Prompt "Make a selection").Trim()

    if ($sel -eq "1") {
        $DCID = "6" 
    } elseif ($sel -eq "2") {
        $DCID = "3"
    } elseif ($sel -eq "3") {
        $DCID = "22"
    } else {
        cls
    }
} until($DCID -ne "0")

$newserver = curl -Uri https://api.vultr.com/v1/server/create `
                  -Headers @{"API-Key"=$key} `
                  -Method POST `
                  -Body @{ `
                            "VPSPLANID"="201"; `
                            "DCID"=$DCID; `
                            "OSID"="164"; `
                            "SNAPSHOTID"=$SNAPSHOTID `
                         }

Write-Host "Status:  "$newserver.StatusCode" - "$newserver.StatusDescription
Write-Host "Content: "$newserver.Content
$SUBID = $newserver.Content
$SUBID = $SUBID.SubString($SUBID.IndexOf("SUBID") + 8, $SUBID.LastIndexOf('"') - ($SUBID.IndexOf("SUBID") + 8))

Write-Host `n
Write-Host "Wait server startup...  0/40 seconds"
Start-Sleep -s 10
Write-Host "Wait server startup... 10/40 seconds"
Start-Sleep -s 10
Write-Host "Wait server startup... 20/40 seconds"
Start-Sleep -s 10
Write-Host "Wait server startup... 30/40 seconds"
Start-Sleep -s 10
Write-Host "Wait server startup... 40/40 seconds"
Write-Host `n

$serverList = (curl -Uri https://api.vultr.com/v1/server/list -Headers @{"API-Key"=$key}).Content
$serverIPStart = $serverList.IndexOf("main_ip", $serverList.IndexOf($SUBID)) + 10
$serverIP = $serverList.SubString($serverIPStart, $serverList.IndexOf('"', $serverIPStart) - $serverIPStart)

Write-Host "Server IP: "$serverIP

Write-Host `n

Write-Host -NoNewline "Press 'y' to copy IP to Clipboard. "

$copy = $Host.UI.RawUI.ReadKey()
if ($copy.Character -eq 'y') {
	Set-Clipboard -Value $serverIP
}
