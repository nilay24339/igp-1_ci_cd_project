FROM tomcat:latest

# Clean default ROOT
RUN rm -rf /usr/local/tomcat/webapps/ROOT

# Copy your WAR as ROOT.war to make it the default webapp
COPY target/ABCtechnologies-1.0.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080



