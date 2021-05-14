import toml
import json
from socket import gethostname
# Change toml file of node to allow registry of kuberenetes-master 

data = toml.load("/var/snap/microk8s/current/args/containerd-template.toml")

data["plugins"]["io.containerd.grpc.v1.cri"]["registry"]["mirrors"]["192.168.50.10:32000"] = {"endpoint": ["http://192.168.50.10:32000"]}

with open("/var/snap/microk8s/current/args/containerd-template.toml", "w") as ffile:
    toml.dump(data,ffile)
    ffile.close()

# Change microk8s docker configuration to allow push into insecure registry
docker_config = {}

docker_config["insecure-registries"] = ["192.168.50.10:32000"]

with open("/var/snap/microk8s/current/args/docker-daemon.json", 'w') as dockerConf:
    json.dump(docker_config, dockerConf)
    dockerConf.close()

# Update docker config from kubernetes-master to allow create images and push

if "master" in gethostname():
    # /var/snap/docker/current/config/daemon.json
    with open("/var/snap/docker/current/config/daemon.json", 'r') as old_conf:
        config = json.load(old_conf)
        old_conf.close()

    with open("/var/snap/docker/current/config/daemon.json", 'w') as new_conf:
        config["insecure-registries"] = ["192.168.50.10:32000"]
        json.dump(config, new_conf)
        new_conf.close()