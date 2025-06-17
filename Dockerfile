FROM mongo:4.4.19-rc1-focal

# Instala dependências e importa a chave GPG do MongoDB
RUN apt-get update && \
    apt-get -y install gnupg wget python3-pip && \
    wget -qO - https://www.mongodb.org/static/pgp/server-4.4.asc | apt-key add - && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    pip3 install awscli

# Adiciona script de backup
ADD backup.sh /app/backup.sh
RUN chmod +x /app/backup.sh

# Variáveis de ambiente padrão
ENV DATE_FORMAT=%Y%m%d-%H%M%S
ENV FILE_PREFIX=backup-

ENTRYPOINT ["sh"]
CMD ["-c", "/app/backup.sh"]
