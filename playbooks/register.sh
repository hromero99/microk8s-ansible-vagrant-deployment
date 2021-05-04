#!/bin/bash


for line in $(cat /vagrant/join.txt); do 
    echo $line
    bash -c "$line"
done