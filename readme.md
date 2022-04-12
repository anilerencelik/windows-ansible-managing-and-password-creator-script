# Prerequisites

First of all you will execute script in your Windows host for opening winrm port (5986). You can set with User Data in Launch Template . This code help that.

```
<powershell>
New-Item -Path 'C:\winrm' -ItemType Directory
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls, [Net.SecurityProtocolType]::Tls11, [Net.SecurityProtocolType]::Tls12, [Net.SecurityProtocolType]::Ssl3
[Net.ServicePointManager]::SecurityProtocol = "Tls, Tls11, Tls12, Ssl3"
curl "http://raw.githubusercontent.com/ansible/ansible/devel/examples/scripts/ConfigureRemotingForAnsible.ps1" -o "c:\winrm\winrm.ps1"~
c:\winrm\winrm.ps1
</powershell>
```
Aws-cli 

<br>

# Before Running 

After aws configure edit passwordCreator.sh variables and execute it bash passwordCreator.sh

# Runnig Ansible

```
ansible-playbook -i inventory.yml winShell.yml -vvv
```
