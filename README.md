# TacticalRMM-ChgHost
Change host/domain name of Tactical RMM server

## Prerequisites
- Register Domain name
- Add {api, mesh, rmm} A Records
- Obtain and Install SSL Cert for new Domain
- Update all Clients to point to new Server Domain
- Update Mesh Site URL: (Settings > Global Settings > MESHCENTRAL > Mesh Site)


## Setup & Run
curl -L -O https://raw.githubusercontent.com/smileymattj/TacticalRMM-ChgHost/refs/heads/main/chghost.sh<br>
chmod +x chghost.sh<br>
./chghost.sh<br>
