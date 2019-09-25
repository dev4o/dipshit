#!/bin/bash

workdir="/home/buildbot/buildbot-new"
user="buildbot"
log="$workdir/bbot-update.log"

su - buildbot

check_user() {
    if [ `whoami` != ${user} ]; then
        echo -e "\n\e[1;37;31m [WARNING] Not ${user} user. \e[m\t\n" 1>&2
        exit 1
    fi
}

check_status() {
    if [ "$(systemctl is-active buildbot-worker)" == "active" ]; then
        sudo systemctl stop buildbot-worker
    fi
}

venv_source() {
    source $workdir/sandbox/bin/activate
        echo Current buildbot-worker version:
        buildbot --version
        pip install 'buildbot[bundle]' --upgrade >> $log
        wait
        echo buildbot-worker successfully updated to:
        buildbot --version
        deactivate
}

post_install() {
    if [ "$(systemctl is-active buildbot-worker)" != "active" ]; then
        sudo systemctl start buildbot-worker
    fi
}

check_user
check_status
venv_source
post_install
