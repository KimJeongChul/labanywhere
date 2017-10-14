#!/bin/bash

# path
local_path="/usr/local"
main_download_mirror="ftp.daumkakao.com"
apache_download_mirror="ftp.daumkakao.com"
pip_download_mirror="ftp.daumkakao.com"

# sourcelist info
check_java_ppa="http://ppa.launchpad.net/webupd8team/java/ubuntu"
check_sbt_ppa="https://dl.bintray.com/sbt/debian"

# hadoop info
hadoop_name="hadoop"
hadoop_version="2.8.1"
hadoop_url="http://$apache_download_mirror/apache/hadoop/common/hadoop-2.8.1/hadoop-2.8.1.tar.gz"
hadoop_zip="hadoop-2.8.1.tar.gz"

# spark info
spark_name="spark"
spark_version="2.2.0-bin-hadoop2.7"
spark_url="http://$apache_download_mirror/apache/spark/spark-2.2.0/spark-2.2.0-bin-hadoop2.7.tgz"
spark_zip="spark-2.2.0-bin-hadoop2.7.tgz"

# If the program exists, wget re-downloading is stopped
function wget_install(){
    local value=$1
    local value=$2
    local value=$3
    local value=$4
    if [ ! -d "$local_path/$1" ]; then
        sudo wget $3
        sudo tar xvzf $4
        sudo mv $1-$2 $local_path
        sudo ln -s $local_path/$1-$2 $local_path/$1
    else 
        echo "installed $1"
    fi
}

function pip_install(){ 
    local value=$1   
    sudo pip3 install $1 -i http://$pip_download_mirror/pypi/simple --trusted-host $pip_download_mirror 2>&1
}

# remove temporary files
function tmp_remove(){
    sudo rm hadoop-2.8.1.tar.gz > /dev/null 2>&1
    sudo rm spark-2.2.0-bin-hadoop2.7.tgz > /dev/null 2>&1
    exit 1
}

# Change apt repository
sudo sed -i "s/kr.archive.ubuntu.com/$main_download_mirror/g" /etc/apt/sources.list

# update/upgrade system
sudo apt -y update && sudo apt -y upgrade

# Install VIM
sudo apt -y install vim

# Install gcc
sudo apt -y install build-essential

# Install Java oracle-8
if ! grep -q "^deb .*$check_java_ppa" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
    sudo add-apt-repository -y ppa:webupd8team/java
fi
sudo apt -y update
sudo apt install -y software-properties-common debconf-utils
sudo echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | sudo debconf-set-selections
sudo apt -y install oracle-java8-installer

# Install Eclipse
sudo apt -y install eclipse

# Install R
sudo apt -y install r-base

# Install Git
sudo apt -y install git

# Install RBTools
sudo apt -y install python-rbtools

# Install MySQL
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password kmucs'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password kmucs'
sudo apt -y install mysql-server

# Install MySQL Workbench
sudo apt -y install mysql-workbench

# Install MySQL JDBC
sudo apt -y install libmysql-java
# Install django
sudo apt -y install python3-pip
sudo pip3 install --upgrade pip
pip_install django

# Install numpy
pip_install numpy

# Install scipy
pip_install scipy

# Install matplotlib
pip_install matplotlib

# Install pyyaml
pip_install pyyaml

# Install nltk
pip_install nltk

# Install scikit-learn
pip_install scikit-learn

# Install hadoop
wget_install $hadoop_name $hadoop_version $hadoop_url $hadoop_zip
# Have to set eclipse to compile hadoop in eclipse

# Install spark
wget_install $spark_name $spark_version $spark_url $spark_zip

# Enable apt over https
sudo apt -y install apt-transport-https

# Install sbt
if ! grep -q "^deb .*$check_sbt_ppa" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
    echo "deb https://dl.bintray.com/sbt/debian /" | sudo tee -a /etc/apt/sources.list.d/sbt.list
fi
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2EE0EA64E40A89B84B2DF73499E82A75642AC823
sudo apt update
sudo apt -y install sbt

# remove temporary files
tmp_remove