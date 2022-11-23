#!/bin/bash

# Based on https://github.com/danchitnis/container-xrdp/blob/master/build/ubuntu-run.sh

start_xrdp_services() {
    # Preventing xrdp startup failure
    rm -rf /var/run/xrdp-sesman.pid
    rm -rf /var/run/xrdp.pid
    rm -rf /var/run/xrdp/xrdp-sesman.pid
    rm -rf /var/run/xrdp/xrdp.pid

    # Use exec ... to forward SIGNAL to child processes
    xrdp-sesman && exec xrdp -n
}

stop_xrdp_services() {
    xrdp --kill
    xrdp-sesman --kill
    exit 0
}

echo "Entrypoint is running..."
echo

if [[ $# -ne 3 ]]; then
    echo "Expected 3 input parameters: user password homepage"
    exit
fi

addgroup $1
useradd -m -s /bin/bash -g $1 $1
wait
echo $1:$2 | chpasswd 
wait
usermod -aG sudo $1
wait
echo "Added user '$1'"
replace="s|__HOMEPAGE__|$3|"
echo $replace
sed -i $replace /home/$1/.Xsession
echo "Set homepage '$3'"

trap "stop_xrdp_services" SIGKILL SIGTERM SIGHUP SIGINT EXIT
start_xrdp_services