#!/bin/bash

launch (){
    vagrant up
}

create_nodes (){
    for Nnode in {1..2} ; do 
        vagrant up node-$Nnode
    done
}

create_master (){
    vagrant up eks-master
}

create_cluster(){
    create_nodes
    create_master
}

destroy_cluster(){
    vagrant destroy
}

register_node(){
    node_join=$(/opt/vagrant ssh --command "sudo microk8s.add-node | grep 192.168.50" $1)
    echo $node_join
    $(/opt/vagrant ssh --command "sudo $node_join" kubernetes-master)
}

update_join(){
    node_join=$(/opt/vagrant ssh --command "sudo microk8s.add-node | grep 192.168.50" $1)
    echo $node_join >>join.txt
}


update_join node-1
update_join node-2
