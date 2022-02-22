# first stage - get and deploy all the dependencies
# MicroStrategy m2020 and below => jdk8 else 11
ARG devtools=true
ARG JDK_VERSION=11

# in this step we will deploy WAR files and clone our repos and clean up some sensitive data
FROM tomcat:9.0.58-jdk${JDK_VERSION}-openjdk-buster as deploy-apps


ARG MSTR_VERSION=m2021
ARG MSTR_UPDATE_VERSION=U41
# transfer the war file with MicroStrategy Web and Library
COPY ./dist/$MSTR_VERSION/WAR$MSTR_UPDATE_VERSION /usr/local/tomcat/webapps
# start Tomcat and deploy War files, configure git, clone repos
COPY ./deploy_apps.sh /usr/local/tomcat/bin/deploy_apps.sh
RUN chmod +rx /usr/local/tomcat/bin/deploy_apps.sh
RUN /usr/local/tomcat/bin/deploy_apps.sh

FROM tomcat:9.0.58-jdk${JDK_VERSION}-openjdk-buster as tomcat-base
ARG MSTR_VERSION=m2021
ARG MSTR_UPDATE_VERSION=U41
# tomcat users and groups - original image has no users
COPY ./dist/$MSTR_VERSION/conf/tomcat-users.xml /usr/local/tomcat/conf/tomcat-users.xml
# configure tomcat, ssl paths etc.
COPY ./dist/$MSTR_VERSION/conf/server.xml /usr/local/tomcat/conf


# SSL certificates -> if you don't have them, make sure your server.xml has the correct configuration

COPY ./certbot-ssl/. /usr/local/tomcat/external-conf

# ***OPTIONAL CONFIGURATION***
# .env file => devtools=true
FROM tomcat-base as tomcat-base-devtools-true
ARG MSTR_VERSION=m2021
# disable sameSite cookies
COPY ./dist/$MSTR_VERSION/conf/context.xml /usr/local/tomcat/conf
# enable directory listing -optional
COPY ./dist/$MSTR_VERSION/conf/web.xml /usr/local/tomcat/conf
# nodeJS / npm / Typescript
COPY ./dist/optional/install_toolkit.sh /usr/local/
# install nodeJS and npm and typescript
RUN chmod +rx /usr/local/install_toolkit.sh
RUN /usr/local/install_toolkit.sh

FROM tomcat-base as tomcat-base-devtools-false
RUN echo "devtools=false , skipping cool dev tools, like && subscribe"

FROM tomcat-base-devtools-${devtools} as tomcat-final
COPY --from=deploy-apps /usr/local/tomcat/webapps /usr/local/tomcat/webapps

# extra build step for local plugins.
# # ARG MSTR_VERSION=m2021
# # deploy local plugins
# # COPY ./dist/$MSTR_VERSION/plugins /usr/local/tomcat/webapps/MicroStrategy/plugins
CMD [ "catalina.sh","run" ]