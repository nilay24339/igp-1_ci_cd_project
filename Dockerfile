FROM tomcat:latest

# Copy the WAR file to Tomcat webapps directory
COPY target/ABCtechnologies-1.0.war /usr/local/tomcat/webapps/

# Optional: Expose default Tomcat port
EXPOSE 8080

