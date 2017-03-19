#!/bin/bash
az group create -n dcosrg -l westus

# D3_v2 Standard_D3_v2
az acs create -n dockerdcos -g dcosrg --admin-username mbindra --agent-count 1 -d dockerdcosmani4 --generate-ssh-keys -l westus --master-count 1 --orchestrator-type DCOS --agent-vm-size Standard_D3_v2 --ssh-key-value ~/.ssh/id_rsa.pub

# ssh tunnel
ssh -fNL 9004:localhost:80 -p 2200 mbindra@dockerdcosmani4mgmt.westus.cloudapp.azure.com -i ~/.ssh/id_rsa

#dcos-cli set config
dcos config set core.dcos_url http://localhost:9004

# demo dcos mesos and marathon dashboards

# scale to 4 nodes
az acs scale -g dcosrg -n dockerdcos --new-agent-count 4

## new app first dc/os task 
/bin/bash -c 'for i in {1..5} ; do echo newapp $i; sleep 1; done;'

dcos node
#dcos task

#check task log
dcos task log --follow myworker

myworker can then be destroyed

# install marathonlb : 
dcos package install marathon-lb
#http://dockerdcosmani4agents.westus.cloudapp.azure.com/

# demo yeasy simple using web and then dcos cli
dcos marathon app remove yesy

dcos marathon app add yeasy-simple-web.json
dcos marathon app remove web

# install cassandra
dcos package install cassandra

# install kafka
dcos package install kafka


# tweeter app
# dcos marathon app add tweeter.json
dcos marathon app add tweeter-mod.json

# generate tweets
./bin/tweet shakespeare-tweets.json http://dockerdcosmani4agents.westus.cloudapp.azure.com/





# dcos cassandra connection
dcos cassandra  connection


#clean up
# remote tweeter    
dcos marathon app remove "tweeter"

# remove kafka
dcos marathon app remove kafka


# remove cassandra
dcos marathon app remove cassandra


# remove marathon lb
dcos marathon app remove marathon-lb

#scale down
az acs scale -g dcosrg -n dockerdcos --new-agent-count 1
