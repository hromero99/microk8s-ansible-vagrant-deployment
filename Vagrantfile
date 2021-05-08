N = 2
Vagrant.configure(2) do |config|
    config.ssh.insert_key = false
    config.vm.boot_timeout = 50000
    config.vm.provider "virtualbox" do |v|
        v.memory = 2048
        v.cpus = 1
    end

    (1..N).each do |i|
        config.vm.define "node-#{i}" do |node|
            node.vm.box = "bento/ubuntu-20.04"
            node.vm.hostname = "node-#{i}"
            node.vm.network "private_network", ip: "192.168.50.#{i + 10}"
            node.vm.provision "ansible" do |ansible| 
                ansible.playbook="./playbooks/playbook-worker.yaml"
            end    
        end
    end
    
    config.vm.define "kubernetes-master" do |master|
        master.vm.box =  "bento/ubuntu-20.04"
        master.vm.hostname = "eks-master"
        master.vm.network "private_network", ip: "192.168.50.10"
        master.vm.provision "ansible" do |ansible| 
            ansible.playbook="./playbooks/playbook-master.yaml"
        end
    end


end