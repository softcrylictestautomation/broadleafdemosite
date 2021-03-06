#Build this dockerfile :  docker build -t fnubhupen/broadleaf git://github.com/Bhupendra2020/broadleafdemosite.git

FROM fnubhupen/oraclejava:7
MAINTAINER Bhupendra Kumar <Bhupendra.kumar@softcrylic.com>

#Install the Tomcat7
RUN apt-get update && \
    apt-get install -yq --no-install-recommends wget pwgen ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENV TOMCAT_MAJOR_VERSION 7
ENV TOMCAT_MINOR_VERSION 7.0.57
ENV CATALINA_HOME /tomcat
#ENV DEPLOY_DIR /maven

# INSTALL TOMCAT
RUN wget -q https://archive.apache.org/dist/tomcat/tomcat-${TOMCAT_MAJOR_VERSION}/v${TOMCAT_MINOR_VERSION}/bin/apache-tomcat-${TOMCAT_MINOR_VERSION}.tar.gz && \
    wget -qO- https://archive.apache.org/dist/tomcat/tomcat-${TOMCAT_MAJOR_VERSION}/v${TOMCAT_MINOR_VERSION}/bin/apache-tomcat-${TOMCAT_MINOR_VERSION}.tar.gz.md5 | md5sum -c - && \
    tar zxf apache-tomcat-*.tar.gz && \
    rm apache-tomcat-*.tar.gz && \
    mv apache-tomcat* tomcat

ADD create_tomcat_admin_user.sh /create_tomcat_admin_user.sh
ADD setenv.sh /${CATALINA_HOME}/bin/setenv.sh
ADD run.sh /run.sh
RUN chmod +x /*.sh

# Remove unneeded apps
RUN rm -rf /tomcat/webapps/examples /tomcat/webapps/docs 

#VOLUME /maven
ADD mycompany.war /tomcat/webapps/mycompany.war

EXPOSE 8080
CMD ["/run.sh"]



