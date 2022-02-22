<!-- created by -->
<!-- Pawel Gnatowski -->
<!-- contact me: https://www.linkedin.com/in/pawelgnatowskibi/ -->
Important notice!

This receipe is for local development environments only - do not try to use it in production as it is not security hardened :)

- Edit deploy_apps.sh if you want to git clone stuff into webapps
- Edit tomcat-users.xml to be able to log into administravie panels
- context.xml and web.xml (from tomcat base image) have been modified to allow SameSite cookies = None as well as allow CORS to all origin to allow embedding and frictionless MicroStrategy Workstation connection.
    if you wish to use default values deploy default tomcat image and copy originals to the respective folders in dist/mXXX/conf folder.

0. read the article 
https://www.pablo-labs.com/post/diy-containerize-microstrategy-web-library-and-accelerate-your-development-kudos-to-docker
below only select information.
Remember to setup tomcat user in /conf/tomcat-users.xml

FYI: customized files:
web.xml => enable directory listings => line118
web.xml => cors filter => allow all origins => start line 124 
context.xml =>  sameSite cookies set to none => line 26
tomcat-users => username="pablo" password="AutoEscobar$" - please change
server.xml => ssl configuration.

__________________________________________________________________

If you have SSL certificates:
1. Provide SSL pem certificates:
certbot-ssl/cert.pem
certbot-ssl/fullchain.pem
certbot-ssl/privkey.pem

You could  also use pfx - though it is not recommended ever. if so - you need to change server.xml to reflect it. Best to export pem from pfx.

If you do not have SSL certificates:
1. Edit server.xml and configure non-https traffic - not recommended - you will have trouble to get all functionality working correctly.


2. Edit .env file to your liking, mandatory fields (example):
- ISERVER_IP => 192.168.20.30
- ISERVER_NAME => MY_MONSTER_WORKSTATION
- Ports: 
    Example:
    EXTERNAL_PORT=443
    TOMCAT_SERVER_PORT=8443
    > external port : this will be the port you use to connect via browser.
    https://pablo-labs:443/MicroStrategyLibrary/app which is the same as 
    https://pablo-labs/MicroStrategyLibrary/app (443 is default for https)
    > interal port : this is where TCP trafic will get redirected to and is configured in server.xml, if different from defualt 8443 you need to adjust server.xml.

3. Run command to build and run compose afterwards:
All default:

docker build . --no-cache -t mstr-tomcat-docker:m2021-base 
docker-compose up

which is equivalent of following build arguments:

MSTR_VERSION=m2021
MSTR_UPDATE_VERSION=U41 (update 1 would be U1 etc. depends how you want to keep your WAR folders organized)
JDK_VERSION=11
devtools=true

explicit command would be:

docker build . --no-cache --build-arg MSTR_VERSION=m2021 --build-arg MSTR_UPDATE_VERSION=U41 --build-arg JDK_VERSION=11 --build-arg devtools=true -t mstr-tomcat-docker:m2021-base

m2020 and below:
docker build . --build-arg MSTR_VERSION=m2019 --build-arg devtools=false --build-arg MSTR_UPDATE_VERSION=U5 --build-arg JDK_VERSION=8 --no-cache -t mstr-tomcat-docker:m2019-barebone 
docker-compose up

4. Profit!




P.S.
Dockerfile.dev, and override.yml are just for example and no need to use them. Though as best practice says, use them instead of modyfing core files.

P.S.2 get your containers secured
Docker buildkit or - try this article for more details:

https://blog.gitguardian.com/how-to-improve-your-docker-containers-security-cheat-sheet/

