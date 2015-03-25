FROM amsokol/oraclelinux-java:7.1-7u75
MAINTAINER Alexander Sokolovsky <amsokol@gmail.com>

# User root user to install software
USER root

# Execute system update
RUN yum -y update && yum clean all

# Create a user and group used to launch processes
# The user ID 1000 is the default for the first "regular" user on Fedora/RHEL,
# so there is a high chance that this ID will be equal to the current user
# making it easier to use volumes (no permission issues)
RUN groupadd -r jboss -g 1000 && useradd -u 1000 -r -g jboss -m -d /opt/jboss -s /sbin/nologin -c "JBoss user" jboss

# Set the WILDFLY_VERSION env variable
ENV WILDFLY_VERSION 8.1.0.Final

ADD assets/wildfly-$WILDFLY_VERSION.tar.gz /opt/jboss/
RUN mv /opt/jboss/wildfly-$WILDFLY_VERSION /opt/jboss/wildfly
RUN chown -R jboss:jboss /opt/jboss

# Specify the user which should be used to execute all commands below
USER jboss

# Set the working directory to jboss' user home directory
WORKDIR /opt/jboss

# Set the JAVA_HOME variable to make it clear where Java is located
ENV JAVA_HOME /usr/java/latest

# Set the JBOSS_HOME env variable
ENV JBOSS_HOME /opt/jboss/wildfly

# Expose the folders we're interested in
VOLUME ["/opt/jboss/wildfly/standalone/log"]
VOLUME ["/opt/jboss/wildfly/standalone/deployments"]

# Expose the ports we're interested in
EXPOSE 8080 9990

# Set the default command to run on boot
# This will boot WildFly in the standalone mode
ENTRYPOINT ["java", "-D[Standalone]", "-server", "-Xms64m", "-Xmx512m", "-XX:MaxPermSize=256m", "-Dfile.encoding=UTF-8", "-Djava.net.preferIPv4Stack=true", "-Djboss.modules.system.pkgs=org.jboss.byteman", "-Djava.awt.headless=true", "-Dorg.jboss.boot.log.file=/opt/jboss/wildfly/standalone/log/server.log", "-Dlogging.configuration=file:/opt/jboss/wildfly/standalone/configuration/logging.properties", "-jar", "/opt/jboss/wildfly/jboss-modules.jar", "-mp", "/opt/jboss/wildfly/modules", "org.jboss.as.standalone", "-Djboss.home.dir=/opt/jboss/wildfly", "-Djboss.server.base.dir=/opt/jboss/wildfly/standalone"]
