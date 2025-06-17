FROM bitofsky/mongodb-awscli-image:latest

WORKDIR /app
COPY backup.sh .
RUN chmod +x backup.sh

ENV DATE_FORMAT="%Y%m%d-%H%M%S" \
    FILE_PREFIX="backup-"

ENTRYPOINT ["sh", "/app/backup.sh"]
