
# Use Ubuntu as the base image
FROM ubuntu
# Install required dependencies
RUN apt-get update && apt-get install -y nginx
# Copy the HTML file to the nginx web server directory
COPY index.html .
# PORT
EXPOSE 8081
# Start nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]
