# tsbastionazure
Tailscale-connected container for Azure. Initially intended to act as bastion, both as subnet router and ssh tunnel jump host.

NOTES:
headscale; usable as subnet router; built for use as bastion that is not dependent on routing (new routes; overlapping addressing): ssh tunnel; replace cert, can change sshuser password from azure interface, which will allow sudo?; parameters: in general, headscale, for az create, todo powershell; restart other clients to get routes
more todo: dns rename; sudo; examples of what goes wrong (auth key); dev in wsl; switch; example of local ssh tunnel in cmd prompt; script to check what it's costing

autoapprovers or manually approve
need fqdn to ssh between headscale namespaces
CREDIT: https://jaliyaudagedara.blogspot.com/2020/11/setting-up-ssh-on-custom-linux-docker.html and similar ; https://docs.microsoft.com/en-us/azure/app-service/configure-custom-container?pivots=container-linux


ooooh. monitor for tags and add routes. create bastion vnet and have some kind of automatic peering?

advantage of ssh -- can have same subnet in two vnets, tenants, etc..

use lowest b instanace instead. lower cost even if on all the time. easier to stop and start. single-ip vnet?

now looking at azure app service web app option
