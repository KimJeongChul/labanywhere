#!/bin/bash

# Change apt repository
sudo sed -i 's/kr.archive.ubuntu.com/ftp.daumkakao.com/g' /etc/apt/sources.list

sudo apt-get -y update
sudo apt-get -y upgrade

# Install VIM
sudo apt-get -y install vim

# Install gcc
sudo apt-get -y install build-essential

# Install Java oracle-8
sudo add-apt-repository -y ppa:webupd8team/java
sudo apt-get -y update
sudo debconf-set-selections <<< 'oracle-java8-installer shared/accepted-oracle-licnese-v1-1 select true'
sudo apt-get -y install oracle-java8-installer

# Install Eclipse
sudo apt-get -y install eclipse

# Install R
sudo apt-get -y install r-base

# Install Git
sudo apt-get -y install git

# Install RBTools
sudo apt-get -y install python-rbtools

# Install MySQL
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password kmucs'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password passwordi_again kmucs'
sudo apt-get -y install mysql-server

# Install MySQL Workbench
sudo apt-get -y install mysql-workbench

# Install MySQL JDBC
sudo apt-get -y install libmysql-java 
# Install django
sudo apt-get -y install python3-pip
sudo pip3 install --upgrade pip
sudo pip3 install django

# Install numpy
sudo pip3 install numpy

# Install scipy
sudo pip3 install scipy

# Install matplotlib
sudo pip3 install matplotlib

# Install pyyaml
sudo pip3 install pyyaml

# Install nltk
sudo pip3 install nltk

# Install scikit-learn
sudo pip3 install scikit-learn

# Install hadoop
sudo wget http://apache.mirror.cdnetworks.com/hadoop/common/hadoop-2.8.1/hadoop-2.8.1.tar.gz
sudo tar xvzf hadoop-2.8.1.tar.gz
sudo mv hadoop-2.8.1 /usr/local/
sudo rm hadoop-2.8.1.tar.gz
sudo ln -s /usr/local/hadoop-2.8.1 /usr/local/hadoop
# Have to set eclipse to compile hadoop in eclipse

# Install spark
sudo wget https://d3kbcqa49mib13.cloudfront.net/spark-2.2.0-bin-hadoop2.7.tgz
sudo tar xvzf spark-2.2.0-bin-hadoop2.7.tgz
sudo mv spark-2.2.0-bin-hadoop2.7 /usr/local
sudo rm spark-2.2.0-bin-hadoop2.7.tgz
sudo ln -s /usr/local/spark-2.2.0-bin-hadoop2.7 /usr/local/spark

# Install sbt
echo "deb https://dl.bintray.com/sbt/debian /" | sudo tee -a /etc/apt/sources.list.d/sbt.list
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2EE0EA64E40A89B84B2DF73499E82A75642AC823
sudo apt-get update
sudo apt-get -y install sbt
