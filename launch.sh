#!/bin/bash

vagrant="/usr/bin/vagrant"
options='delete - Delete the vagrant cluster   create - Create Vagrant cluster \n create-registry - Create Registry VM'
launch (){
    vagrant up
}

create_nodes (){
    n_nodes=$(cat Vagrantfile | grep 'N.=' | awk -F ' ' '{print $NF}')
    for ((node=1; node<=3;node++)); do
	$vagrant up node-$node
    done
}

create_master (){
    $vagrant up kubernetes-master
}

create_cluster(){
    create_master
    create_nodes
}

create_registry(){
    $vagrant up kubernetes-registry
}

destroy_cluster(){
    $vagrant destroy
}

register_node(){
    # Need to catch up the kubernetes master token to add into nodes
    node_join=$(/usr/bin/vagrant ssh --command "sudo microk8s.add-node  | grep 192.168.50" kubernetes-master)
    echo "Adding node $1 to kubernetes cluster"
    echo "Using $node_join"
    /usr/bin/vagrant ssh --command="sudo $node_join" $1
}

get_nodes(){
  command=$(/usr/bin/vagrant ssh --command="sudo microk8s.kubectl get nodes --show-labels" kubernetes-master)
  echo "[!] List of kubernetes nodes"
  echo "$command"
}

cluster_status(){

  for node in node-1 node-2 node-3 kubernetes-master; do
    status=$(/usr/bin/vagrant ssh --command="sudo microk8s.status" $node | grep 'microk8s is*') >/dev/null
    echo "[?] $node -- $status"
  done
}

add_label_to_node(){
  # $1 must be the node and $2 the label to add
  # TODO: Check if node is in cluster and label is in valid format
  echo "Going to add $2 to $1"
  result=$(/usr/bin/vagrant ssh --command="sudo microk8s.kubectl label nodes $1 $2" kubernetes-master )
  echo "Result fom add $2 to $1"
  echo "$result"

}

delete_vm_node(){
  echo "[!]Going to delete $1"
  result=$(/usr/bin/vagrant destroy --force $1)
  echo "$result"
}

create_vm_node(){
  echo "[!] Going to create $1"
  result=$(/usr/bin/vagrant up $1)
  echo "$result"
}


case $1 in
  delete)
    destroy_cluster
    ;;
  create)
    create_cluster
    ;;
  create-registry)
    create_nodes
    ;;
  nodes-register)
    register_node $2
    ;;
  nodes)
    get_nodes
    ;;
  status)
    cluster_status
    ;;
  nodes-add-label)
    add_label_to_node $2 $3
    ;;
  nodes-vm-delete)
    delete_vm_node $2
    ;;
  nodes-vm-create)
    create_vm_node $2
    ;;
  *)
    echo "$options"
esac
