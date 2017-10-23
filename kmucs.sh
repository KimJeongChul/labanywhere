#!/bin/bash
# start
notify-send  "Labanywhere" "Installation will begin. Please exit the other running programs." -u critical
# logging msg
notify-send  "Labanywhere" "All installation progress is recorded in the log file." -u critical

# logging part
DATELOG=`date "+%y%d%m"`
log="Labanywhere_script_$DATELOG.log"
kernel_version=`uname -r`

function log_init(){
    echo "===============================================================">$log
    echo "Labanywhere script $DATELOG report ">>$log
    echo `date`>>$log
    echo " ">>$log
    lsb_release -a>>$log
    echo "kernerl:	$kernel_version">>$log
    echo "===============================================================">>$log
}
function install_logging(){
    local value=$1
    echo "program installed : \"$1\"">>$log
    echo "---------------------------------------------------------------">>$log
}
function delete_logging(){
    local value=$1
    echo "temporary file removed : \"$1\"">>$log
    echo "---------------------------------------------------------------">>$log
}
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
        install_logging $1
    else 
        install_logging $1
    fi
}

function apt_install(){ 
    local value=$1   
    sudo apt-get -y install $1 | tee -a $log 2>&1
    install_logging $1 2>&1
}

function pip_install(){ 
    local value=$1   
    sudo pip3 install $1 -i http://$pip_download_mirror/pypi/simple --trusted-host $pip_download_mirror | tee -a $log 2>&1
    install_logging $1 2>&1
}

# remove temporary files
function tmp_remove(){
    local value=$1 
    sudo rm $1 > /dev/null 2>&1
    delete_logging $1
}

# Change apt repository
sudo sed -i "s/kr.archive.ubuntu.com/$main_download_mirror/g" /etc/apt/sources.list
# logging system start
log_init
# update/upgrade system
sudo apt -y update && sudo apt -y upgrade

# Install VIM
apt_install vim

# Install gcc
apt_install build-essential

# Install Java oracle-8
if ! grep -q "^deb .*$check_java_ppa" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
    sudo add-apt-repository -y ppa:webupd8team/java
fi

if ! type javac; then
    sudo apt -y update
    sudo apt install -y software-properties-common debconf-utils
    sudo echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | sudo     debconf-set-selections
    sudo apt-get -y install oracle-java8-installer | tee -a $log 2>&1
fi

if type javac >/dev/null 2>/dev/null; then
    install_logging java | tee -a $log 2>&1
fi

# Install Eclipse
apt_install eclipse

# Install R
apt_install r-base

# Install Git
apt_install git

# Install RBTools
apt_install python-rbtools

# Install MySQL
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password kmucs'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password kmucs'
apt_install mysql-server

# Install MySQL Workbench
apt_install mysql-workbench

# Install MySQL JDBC
apt_install libmysql-java

# Install django
apt_install python3-pip
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
wget_install $hadoop_name $hadoop_version $hadoop_url $hadoop_zip | tee -a $log
# Have to set eclipse to compile hadoop in eclipse

# Install spark
wget_install $spark_name $spark_version $spark_url $spark_zip | tee -a $log

# Enable apt over https
apt_install apt-transport-https

# Install sbt
if ! grep -q "^deb .*$check_sbt_ppa" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
    echo "deb https://dl.bintray.com/sbt/debian /" | sudo tee -a /etc/apt/sources.list.d/sbt.list
fi
if ! type sbt; then
    sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv      2EE0EA64E40A89B84B2DF73499E82A75642AC823
    sudo apt update
    sudo apt-get -y install sbt | tee -a $log
fi

if type sbt >/dev/null 2>/dev/null; then
    install_logging sbt | tee -a $log
fi

# remove temporary files
if [ -f "$hadoop_zip" ]; then
tmp_remove $hadoop_zip
fi
if [ -f "$spark_zip" ]; then
tmp_remove $spark_zip
fi

# end
notify-send  "Labanywhere" "This script completed successfully. Please reboot your computer." -u critical