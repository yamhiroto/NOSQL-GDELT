#!/bin/bash

cd /home

echo "Téléchargement Cassandra"
sudo wget http://archive.apache.org/dist/cassandra/3.11.3/apache-cassandra-3.11.3-bin.tar.gz

echo "Dezipper fichier Cassandra"
sudo tar -xzvf apache-cassandra-3.11.3-bin.tar.gz

sudo rm apache-cassandra-3.11.3-bin.tar.gz

cd apache-cassandra-3.11.3/conf/

echo "Traitement du fichier cassandra.yaml"

echo "Modification listen address"
sudo sed -i -e "s/listen_address: localhost/listen_address: $1/g" cassandra.yaml

echo "Modification rpc address"
sudo sed -i -e "s/rpc_address: localhost/rpc_address: $1/g" cassandra.yaml

echo "Modification endpoint_snitch"
sudo sed -i -e "s/endpoint_snitch: SimpleSnitch/endpoint_snitch: Ec2Snitch/g" cassandra.yaml

echo "Modification seeds"
#variable = "127.0.0.1"
sudo sed -i -e "s/\- seeds: \"127.0.0.1\"/- seeds: $1,$2,$3,$4,$5/g" cassandra.yaml

echo "Traitement du fichier cassandra-rackdc.properties"

echo "Modification cassandra-rackdc.properties"
sudo sed -i -e "s/dc=dc1/#dc=dc1/g" cassandra-rackdc.properties
sudo sed -i -e "s/rack=rack1/#rack=rack1/g" cassandra-rackdc.properties

cd ../bin

echo "Création du fichier data"
sudo mkdir ./../data
sudo chmod 777 ./../data

echo "Création du fichier hints et modification des droits"
sudo mkdir ./../data/hints
sudo chmod 777 ./../data/hints

echo "Création du fichier data et modification des droits"
sudo mkdir ./../data/data
sudo chmod 777 ./../data/data

echo "Création du fichier commitlog et modification des droits"
sudo mkdir ./../data/commitlog
sudo chmod 777 ./../data/commitlog

echo "Création du fichier cdc_raw et modification des droits"
sudo mkdir ./../data/cdc_raw
sudo chmod 777 ./../data/cdc_raw

echo "Création du fichier saved_caches et modification des droits"
sudo mkdir ./../data/saved_caches
sudo chmod 777 ./../data/saved_caches

echo "Redirection vers cassandra"
cd /home/apache-cassandra-3.11.3/bin/
./cassandra

