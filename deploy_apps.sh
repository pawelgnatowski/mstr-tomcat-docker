#!/bin/bash
# run concurrecntly to deploy MicroStrategy webapps
({ catalina.sh run & })
# let it run for a while -> see if there are no errors in deployment. if you monster workstation is slow - increase the sleep time or build the hooks yourself.
sleep 60

# configure git
# git config --global user.name "pablo" && git config --global user.email "pablo.escobar@automation.xd"

# clone your github plugins you need
# cd /usr/local/tomcat/webapps/MicroStrategy/plugins/
# git clone https://pawelgnatowski:repoTempKey@github.com/pawelgnatowski/PacMan.git
# echo "Repo cloning complete"

# finish deployment by running Tomcat native command:

shutdown.sh
echo "Apps deployed, kaffezeit;)"

# clean up 
rm -r /usr/local/tomcat/webapps/*.war
rm /usr/local/tomcat/bin/deploy_apps.sh