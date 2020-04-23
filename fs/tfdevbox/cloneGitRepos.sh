#!/bin/bash

CWD=`pwd`

cd /home/tfdevbox
mkdir -p /home/tfdevbox/log

if [ ! -d "/tmp/tfdevbox-repo" ]; then
	echo "[cloneGitRepos] Retrieving repository list from ${TFDEVBOX_REPO}#${TFDEVBOX_GH_BRANCH}"
	git clone -b $TFDEVBOX_GH_BRANCH $TFDEVBOX_REPO /tmp/tfdevbox-repo >> /home/tfdevbox/log/cloneGitRepos.log 2>&1
fi

# the updateRepos script takes in a json file as an argument, and will automatically look for a user-defined /tmp/user_repos.json 
python /tfdevbox/updateRepos.py /tmp/tfdevbox-repo/fs/etc/tfdevboxrepo.d/base.json
python /tfdevbox/cloneGitRepos.py