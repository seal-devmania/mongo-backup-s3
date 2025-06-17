FROM mongo:4.4.19-rc1-focal

# # Install Python
RUN apt-get update && \
    apt-get -y install python python3-pip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    pip install awscli

# # # Add scripts
ADD backup.sh /app/backup.sh
RUN chmod +x /app/backup.sh

# # # Default environment variables
ENV DATE_FORMAT %Y%m%d-%H%M%S
ENV FILE_PREFIX backup-

ENTRYPOINT [ "sh" ]
# # # Run the schedule command on startup
CMD ["-c", "/app/backup.sh"]
