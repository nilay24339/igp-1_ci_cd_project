# Use latest Tomcat base image
FROM tomcat:latest

# Remove the default ROOT webapp (optional, keeps it clean)
RUN rm -rf /usr/local/tomcat/webapps/ROOT

# Copy your WAR file as ROOT.war so it deploys on /
COPY target/ABCtechnologies-1.0.war /usr/local/tomcat/webapps/ROOT.war

# Expose default Tomcat port
EXPOSE 8080


