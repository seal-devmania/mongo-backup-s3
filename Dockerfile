FROM shini4i/docker-mongodb-tools-awscli:latest

WORKDIR /app

# Copia script de backup
COPY backup.sh ./backup.sh
RUN chmod +x backup.sh

# Variáveis padrão
ENV DATE_FORMAT="%Y%m%d-%H%M%S" \
    FILE_PREFIX="backup-"

ENTRYPOINT ["sh", "backup.sh"]
