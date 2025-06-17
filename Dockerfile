FROM mongo:7.0.21

# Instala Python 3, pip e alias 'python'
RUN apt-get update && \
    apt-get -y install python3 python3-pip python-is-python3 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    pip install awscli

# Adiciona o script de backup
ADD backup.sh /app/backup.sh
RUN chmod +x /app/backup.sh

# Variáveis de ambiente
ENV DATE_FORMAT=%Y%m%d-%H%M%S
ENV FILE_PREFIX=backup-

# Entrypoint e comando padrão
ENTRYPOINT ["sh"]
CMD ["-c", "/app/backup.sh"]
