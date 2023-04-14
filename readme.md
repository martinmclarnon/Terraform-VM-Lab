## A node sending SNMP Traps. This environment is set up in Azure.
### Infrastructure-as-Code
These instructions are for Mac users - follow the the ReadMe from the GitHub repository below to install a bundle of applications.

```
https://github.com/martinmclarnon/brewfile-for-on-boarding.git
```
[Terraform](https://www.terraform.io) is used to create the development environment, this will require you first to authenticate 
with Azure using the Azure CLI to run the Terraform commands. 

```
az login
```

The `variable.tf` file needs to be completed before continuing.

## Infrastructure Deployment 

To deploy the infrastrucure-as-code, do the following steps:

**1. Initialize working directory containing Terraform configuration files.**

```
$ terraform init --upgrade
```

**2. Create an execution plan, to preview the changes that Terraform plans to make to your infrastructure.**

```
$ terraform plan -out main.tfplan
```

**3. Execute the actions proposed in a Terraform plan. -** `main.tfplan`

```
$ terraform apply main.tfplan
```

## Location - Berlin

### Berlin Minion Virtual Machine

To use SSH to connect to the Minion Berlin virtual machine, do the following steps:

**1. Run terraform output to get the SSH private key and save it to a file.**

```
$ terraform output -raw berlin_vm_tls_private_key_minion > /Users/[YOUR_NAME]/Library/CloudStorage/OneDrive-NantHealth/minion-berlin-vm_key.pem
```

**2. Add the private key to the your local host key directory**

```
$ sudo mv /Users/[YOUR_NAME]/Library/CloudStorage/OneDrive-NantHealth/minion-berlin-vm_key.pem /Users/[YOUR_NAME]/.ssh/
```

**3. Ensure you have read-only access to the private key, run the command at root.**

```
$ sudo chmod 400 ./.ssh/minion-berlin-vm_key.pem
```

**4. Ensure the minion-berlin host entry is not already added.**

```
$ ssh-keygen -f ~/.ssh/known_hosts -R [minion-berlin-vm-DNS_NAME]
```

**5. Connect via SSH**

```
$ ssh -i ./.ssh/minion-berlin-vm_key.pem azureuser@[minion-berlin-vm-DNS_NAME]
```

**6. Install Docker compose**

```
$ sudo su - 
```
```
$ sudo apt update && apt upgrade
```

```
$ curl -L https://github.com/docker/compose/releases/download/1.1.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
```

```
$ chmod +x /usr/local/bin/docker-compose
```
Confirm docker is installed
```
$ docker-compose --version
```

```
$ apt install docker.io
```

```
$ touch docker-compose.yml
```

Use a text editor to paste the code below
```
berlin:
  image: opennms/horizon-stream-minion:latest
  environment:
    TZ: 'Europe/Berlin'
    MINION_ID: 'minion-location-berlin'
    MINION_LOCATION: 'Europe/Berlin'
    USE_KUBERNETES: false
    IGNITE_SERVER_ADDRESSES: localhost
    MINION_GATEWAY_HOST: [TENANT_ID].minion.onms-fb-dev.dev.nonprod.dataservice.opennms.com       
    MINION_GATEWAY_PORT: 443
    MINION_GATEWAY_TLS: true
  ports:
    - '1162:1162/udp'
```
```
$ docker-compose up
```

Check your OpenNMS Cloud Instance for the Minion

### Berlin Node Virtual Machine

To use SSH to connect to the Node virtual machine, do the following steps:

**1. Run terraform output to get the SSH private key and save it to a file.**

```
$ terraform output -raw berlin_vm_tls_private_key_node > /Users/[YOUR_NAME]/Library/CloudStorage/OneDrive-NantHealth/node-berlin-vm_key.pem
```

**2. Add the private key to the your local host key directory**

```
$ sudo mv /Users/[YOUR_NAME]/Library/CloudStorage/OneDrive-NantHealth/node-berlin-vm_key.pem /Users/[YOUR_NAME]/.ssh/
```

**3. Ensure you have read-only access to the private key, run the command at root.**

```
$ sudo chmod 400 ./.ssh/node-berlin-vm_key.pem
```

**4. Ensure the node-berlin host entry is not already added.**

```
$ ssh-keygen -f ~/.ssh/known_hosts -R [node-berlin-vm-DNS_NAME]
```

**5. Connect via SSH**

```
$ ssh -i ./.ssh/node-berlin-vm_key.pem azureuser@[node-berlin-vm-DNS_NAME]
```

**6. Install and Configure SNMP on Ubuntu 20.04: https://kifarunix.com/quick-way-to-install-and-configure-snmp-on-ubuntu-20-04/**

```
$ sudo su - 
```

```
$ sudo apt update && apt upgrade && apt install snmpd snmp libsnmp-dev
```

```
$ sudo nano /etc/snmp/snmpd.conf
```

**Update Agent Operating Mode to include the private ip of the VM:**

```
agentaddress udp:127.0.0.1:161,[THIS_VMs_PRIVATE_IP_ADDRESS]:161
```

**Under Access Control Setup, update Mib2 parent setting:**

```
view   systemonly  included   .1.3.6.1.2.1.1
view   systemonly  included   .1
```

**Return to root**

```
$ systemctl restart snmpd
```

**Check, SNMP is now listening on two interfaces:**

```
$ apt install net-tools
```

```
$ netstat -nlpu|grep snmp
```

**Run Command below to return SNMP data (further reading https://somoit.net/linux/linux-snmpwalk-command-mini-howto):**

```
$ snmpwalk -v2c -c public [THIS_VMs_PRIVATE_IP_ADDRESS] | head
```

**Send SNMP Trap**

```
$ snmptrap -v2c -c public [INTERNAL_IP_ADDRESS_MINION_BERLIN]:1162 '' '.1.3.6.1.6.3.1.1.5.4' .1.3.6.1.6.3.1.1.5.4 s "eth0"
```
**Or**
```
$ snmptrap -v2c -c public [INTERNAL_IP_ADDRESS_MINION_BERLIN]:1162 '' 1.3.6.1.4.1.8072.2.3.0.1 1.3.6.1.4.1.8072.2.3.2.1 i 123456
```

## Location - New York

### New York Minion Virtual Machine

To use SSH to connect to the Minion newyork virtual machine, do the following steps:

**1. Run terraform output to get the SSH private key and save it to a file.**

```
$ terraform output -raw newyork_vm_tls_private_key_minion > /Users/[YOUR_NAME]/Library/CloudStorage/OneDrive-NantHealth/minion-newyork-vm_key.pem
```

**2. Add the private key to the your local host key directory**

```
$ sudo mv /Users/[YOUR_NAME]/Library/CloudStorage/OneDrive-NantHealth/minion-newyork-vm_key.pem /Users/[YOUR_NAME]/.ssh/
```

**3. Ensure you have read-only access to the private key, run the command at root.**

```
$ sudo chmod 400 ./.ssh/minion-newyork-vm_key.pem
```

**4. Ensure the minion-newyork host entry is not already added.**

```
$ ssh-keygen -f ~/.ssh/known_hosts -R [minion-newyork-vm-DNS_NAME]
```

**5. Connect via SSH**

```
$ ssh -i ./.ssh/minion-newyork-vm_key.pem azureuser@[minion-newyork-vm-DNS_NAME]
```

**6. Install Docker compose**

```
$ sudo su - 
```
```
$ sudo apt update && apt upgrade
```

```
$ sudo curl -L https://github.com/docker/compose/releases/download/1.1.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
```

```
$ chmod +x /usr/local/bin/docker-compose
```
Confirm docker is installed
```
$ docker-compose --version
```

```
$ apt install docker.io
```

```
$ touch docker-compose.yml
```

Use a text editor to paste the code below
```
newyork:
  image: opennms/horizon-stream-minion:latest
  environment:
    TZ: 'America/New_York'
    MINION_ID: 'minion-location-newyork'
    MINION_LOCATION: 'America/New York'
    USE_KUBERNETES: false
    IGNITE_SERVER_ADDRESSES: localhost
    MINION_GATEWAY_HOST: [TENANT_ID].minion.onms-fb-dev.dev.nonprod.dataservice.opennms.com     
    MINION_GATEWAY_PORT: 443
    MINION_GATEWAY_TLS: true
  ports:
    - '1162:1162/udp'
```
```
$ docker-compose up
```

Check your OpenNMS Cloud Instance for the Minion

### New York Node Virtual Machine

To use SSH to connect to the Node virtual machine, do the following steps:

**1. Run terraform output to get the SSH private key and save it to a file.**

```
$ terraform output -raw newyork_vm_tls_private_key_node > /Users/[YOUR_NAME]/Library/CloudStorage/OneDrive-NantHealth/node-newyork-vm_key.pem
```

**2. Add the private key to the your local host key directory**

```
$ sudo mv /Users/[YOUR_NAME]/Library/CloudStorage/OneDrive-NantHealth/node-newyork-vm_key.pem /Users/[YOUR_NAME]/.ssh/
```

**3. Ensure you have read-only access to the private key, run the command at root.**

```
$ sudo chmod 400 ./.ssh/node-newyork-vm_key.pem
```

**4. Ensure the node-newyork host entry is not already added.**

```
$ ssh-keygen -f ~/.ssh/known_hosts -R [node-newyork-vm-DNS_NAME]
```

**5. Connect via SSH**

```
$ ssh -i ./.ssh/node-newyork-vm_key.pem azureuser@[node-newyork-vm-DNS_NAME]
```

**6. Install and Configure SNMP on Ubuntu 20.04: https://kifarunix.com/quick-way-to-install-and-configure-snmp-on-ubuntu-20-04/**

```
$ sudo su - 
```

```
$ sudo apt update && apt upgrade && apt install snmpd snmp libsnmp-dev
```

```
$ sudo nano /etc/snmp/snmpd.conf
```

**Update Agent Operating Mode to include the private ip of the VM:**

```
agentaddress udp:127.0.0.1:161,[THIS_VMs_PRIVATE_IP_ADDRESS]:161
```

**Under Access Control Setup, update Mib2 parent setting:**

```
view   systemonly  included   .1.3.6.1.2.1.1
view   systemonly  included   .1
```

**Return to root**

```
$ systemctl restart snmpd
```

**Check, SNMP is now listening on two interfaces:**

```
$ apt install net-tools
```

```
$ netstat -nlpu|grep snmp
```

**Run Command below to return SNMP data (further reading https://somoit.net/linux/linux-snmpwalk-command-mini-howto):**

```
$ snmpwalk -v2c -c public 172.16.1.4 | head
```

**Send SNMP Trap**

```
$ snmptrap -v2c -c public [INTERNAL_IP_ADDRESS_MINION_newyork]:1162 '' '.1.3.6.1.6.3.1.1.5.4' .1.3.6.1.6.3.1.1.5.4 s "eth0"
```
**Or**
```
$ snmptrap -v2c -c public [INTERNAL_IP_ADDRESS_MINION_newyork]:1162 '' 1.3.6.1.4.1.8072.2.3.0.1 1.3.6.1.4.1.8072.2.3.2.1 i 123456
$ snmptrap -v2c -c public [INTERNAL_IP_ADDRESS_MINION_newyork]:1162 '' 1.3.6.1.6.3.1.1.5.1 1.3.6.1.6.3.1.1.5.1 i 123456
```