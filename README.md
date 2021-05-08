# Install Kubernetes Infraestructure using Vagrant

This project is made to create a Kubernetes cluster using Microk8s (or EKS snap package which uses Microk8s as base) with 3 nodes. 1 master and 1 node.
Also deploy a machine for a private registry. 

## Goal

This project is used as base for simulate how can implement Kubernetes in a IOT environment

## Network Archictecture

* Registry VM: 192.168.50.2
* Master VM: 192.168.50.10
* Nodes VM: 192.168.50.10 + i
    * 192.168.50.11
    * 192.168.50.12


```
:warning: **This configuration is for demo purposes, the SSL security is not enabled DON'T USE IN PRODUCTION WITHOUT MODIFICATIONS** :warning:
```