# Tim's Idea Board for this Windows Server 2025 Learning Lab Project

- MVP deployment, as turnkey as possible
- bicep templates with best practices, secrets, modules
- minimum possible spend (provide trial acct isntructions)
- one vnet, simplified but safe defaults leveraging CAF landing zone
- two DCs, one mem server, one client? I want to be able to model as many scenarios as possible
- we'll use CSE etc to install AD DS, AD CS, SSHD, fake accounts to cover 80 percent exploration scenarios
- use cheapest Azure Edition images only
- keep deployment as tidy as possible with tax tags
- i'm open to your (cursor AI's) expert guidance - be bold
- goal is to delight the world with easy access to win serv 2025 
- let's ensure we've got pwsh 7, git, github cli, vscode, wac v2, node, python, azd cli, az cli preinstalled ok
- i want to be opinionated to ensure the soution deploys correctly, ok? maybe allow them to choos the domain name, that's about it. 
- unsure about deploying a vpn gateway to support azure network adapter?
- definiitely no firewall but subnet scoped nsg, no pub ips on vm. we will need key vault to store admin name and password