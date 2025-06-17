FROM mongo:4.4.19-rc1-focal

# Instalar ferramentas e importar chave GPG do MongoDB 4.4
RUN apt-get update && \
    apt-get install -y gnupg wget python3-pip && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 \
      --recv-keys 656408E390CFB1F5 && \
    pip3 install awscli && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Copia e define permissões do script de backup
ADD backup.sh /app/backup.sh
RUN chmod +x /app/backup.sh

ENV DATE_FORMAT=%Y%m%d-%H%M%S
ENV FILE_PREFIX=backup-

ENTRYPOINT ["sh"]
CMD ["-c", "/app/backup.sh"]
