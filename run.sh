docker run --name="oraclelinux7.1-java7u75-wildfly8.1.0" -d -p 8080:8080 -p 9990:9990 -v ~/Development/docker/wildfly/log:/opt/jboss/wildfly/standalone/log -v ~/Development/docker/wildfly/deployments:/opt/jboss/wildfly/standalone/deployments -m 1g amsokol/oraclelinux-java-wildfly:7.1-7u75-8.1.0 -b 0.0.0.0 -bmanagement 0.0.0.0