# ELkProject
Create Playbooks with ansible
## Automated ELK Stack Deployment

The files in this repository were used to configure the network depicted below.

 (Diagrams/FinishedElkDiagram.png)

These files have been tested and used to generate a live ELK deployment on Azure. They can be used to either recreate the entire deployment pictured above. Alternatively, select portions of the playbook file may be used to install only certain pieces of it, such as Filebeat.

 
---
- name: installing and launching filebeat
  hosts: webservers
  become: true
  tasks:

  - name: download filebeat deb
    command: curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-7.4.0-amd64.deb

  - name: install filebeat deb
    command: dpkg -i filebeat-7.4.0-amd64.deb

  - name: drop in filebeat.yml
    copy:
      src: /etc/ansible/filebeat-config.yml
      dest: /etc/filebeat/filebeat.yml

  - name: enable and configure system module
    command: filebeat modules enable system

  - name: setup filebeat
    command: filebeat setup

  - name: start filebeat service
    command: service filebeat start









This document contains the following details:
- Description of the Topology
- Access Policies
- ELK Configuration
  - Beats in Use
  - Machines Being Monitored
- How to Use the Ansible Build


### Description of the Topology

The main purpose of this network is to expose a load-balanced and monitored instance of DVWA, the D*mn Vulnerable Web Application.

Load balancing ensures that the application will be highly available, in addition to restricting inbound access to the network.

What aspect of security do load balancers protect? What is the advantage of a jump box? 
* Load Balancers defend against most denial-of-service (DDoS) attacks. 
* The advantage of having a jump box is having to update only one system instead of hundreds.

Integrating an ELK server allows users to easily monitor the vulnerable VMs for changes to the file systems of the VMs on the network and system metrics, such as CPU usage; attempted SSH logins; sudo escalation failures; etc.

Filebeat watches the log files or locations that you specify, collects log events, and forwards them either to Elasticsearch.
As Metricbeat records metrics and statistics and sends them to Elasticsearch.

The configuration details of each machine may be found below.


| Name     | Function | IP Address | Operating System |
|-----------|-----------------|------------|------------------|
| Jump Box | Gateway | 10.0.0.4   | Linux            |
| Web-1-DVWA     | Web Server         | 10.0.0.5     | Linux                |
| Web-2-DVWA     | Web server         | 10.0.0.6     | Linux                |
| ELK            | Monitoring         | 10.0.0.7     | Linux                |




### Access Policies

The machines on the internal network are not exposed to the public Internet. 

Only the JumpBox machine can accept connections from the Internet. Access to this machine is only allowed from the following IP addresses: 47.146.98.174

Machines within the network can only be accessed by each other.
The DVWA 1 and DVWA 2 VMs send traffic to the ELK server.

A summary of the access policies in place can be found in the table below.

| Name     | Publicly Accessible | Allowed IP Addresses |
|----------|---------------------|----------------------|
| Jump Box | Yes              | 47.146.98.174      |
| ELK      | No               | 10.0.0.1-254       |
| DVWA 1   | No               | 10.0.0.1-254       |
| DVWA 2   | No               | 10.0.0.1-254       |

### Elk Configuration

Ansible was used to automate configuration of the ELK machine. No configuration was performed manually, which is advantageous because...
Ansible allows the user to automate updates to computers and servers with just one command freeing up more time for other tasks 

The playbook implements the following tasks:
* Download and install a docker.io on to your VM
* After Docker is installed then install the elk container
* SSH into container and check if its running
The following screenshot displays the result of running `docker ps` after successfully configuring the ELK instance.

 (Diagrams\ElkCapture.jpg)

### Target Machines & Beats
This ELK server is configured to monitor the following machines DVWA 1 and DVWA 2 VMs, at 10.0.0.5 and 10.0.0.6, respectively. 

I have installed the following Beats on these machines:

* Filebeat
* Metricbeat


These Beats allow us to collect the following information from each machine:
* Filebeat: Filebeat detects changes to the filesystem. Specifically, we use it to collect Apache logs.

* Metricbeat: Metricbeat detects changes in system metrics, such as CPU usage. We use it to detect SSH login attempts, failed sudo escalations, and CPU/RAM statistics.

The playbook below installs Metricbeat on the target hosts. The playbook for installing Filebeat is not included, but looks essentially identical — simply replace `metricbeat` with `filebeat`, along with the appropriate curl command link for filebeat and it will work as expected.

```yaml
---
- name: Install metric beat
  hosts: webservers
  become: true
  tasks:
    # Use command module
  - name: Download metricbeat
    command: curl -L -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-7.4.0-amd64.deb

    # Use command module
  - name: install metricbeat
    command: dpkg -i metricbeat-7.4.0-amd64.deb

    # Use copy module
  - name: drop in metricbeat config
    copy:
      src: /etc/ansible/files/metricbeat-config.yml
      dest: /etc/metricbeat/metricbeat.yml

    # Use command module
  - name: enable and configure docker module for metric beat
    command: metricbeat modules enable docker

    # Use command module
  - name: setup metric beat
    command: metricbeat setup

    # Use command module
  - name: start metric beat
    command: service metricbeat start
```


### Using the Playbook

In order to use the playbook, you will need to have an Ansible control node already configured. We use the jump box for this purpose.

To use the playbooks, we must perform the following steps:

SSH into the Ansible control node in this case jumpbox and follow the steps below:
- Copy the playbooks file to the Ansible Control Node.
- Update the .config files to have the IP address of the VMS
- Run the playbook, and navigate to appropriate targets to check that the installation worked as expected.

The easiest way to copy the playbooks is to use Git:
$ cd /etc/ansible
$ mkdir files
# Clone Repository + IaC Files
$ git clone https://github.com/yourusername/project-1.git
# Move Playbooks and hosts file Into `/etc/ansible`
$ cp project-1/playbooks/* .
$ cp project-1/files/* ./files

Next, you must create a hosts file to specify which VMs to run each playbook on. Run the commands below:
$ cd /etc/ansible
$ cat > hosts <<EOF
[webservers]
10.0.0.5
10.0.0.6

[elk]
10.0.0.8
EOF

After this, the commands below run the playbook:
$ cd /etc/ansible
$ ansible-playbook install_elk.yml elk
$ ansible-playbook install_filebeat.yml webservers
$ ansible-playbook install_metricbeat.yml webservers
To verify success, wait five minutes to give ELK time to start up.
Then, run: curl http://10.0.0.8:5601. This is the address of Kibana. If the installation succeeded, this command should print HTML to the console.


