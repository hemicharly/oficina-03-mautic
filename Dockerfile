FROM ubuntu:20.04

ENV PHP_VERSION 7.4

# Instalando dependencias essenciais
RUN apt-get update && apt-get upgrade -y && \
    apt-get install --no-install-recommends -y  \
    software-properties-common &&\
    add-apt-repository ppa:ondrej/php && \
    apt-get update && apt-get install --no-install-recommends -y \
    cron vim git curl wget unzip zip ntp \
    apache2 \
    libapache2-mod-php${PHP_VERSION} php${PHP_VERSION} php${PHP_VERSION}-xml php${PHP_VERSION}-mysql php${PHP_VERSION}-imap php${PHP_VERSION}-zip php${PHP_VERSION}-intl php${PHP_VERSION}-curl &&\
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false &&\
    rm -rf /var/lib/apt/lists/* && rm /etc/cron.daily/*

# Configurações do apache
RUN a2enmod rewrite &&\
    wget https://mauteam.org/wp-content/uploads/2019/10/000-default.txt &&\
    mv 000-default.txt /etc/apache2/sites-available/000-default.conf


# Instalando o software o 'mautic'
ENV MAUTIC_VERSION 4.3.1
ENV DIR /var/www/html
RUN wget https://github.com/mautic/mautic/releases/download/${MAUTIC_VERSION}/${MAUTIC_VERSION}.zip &&\
    unzip ${MAUTIC_VERSION}.zip -d ${DIR} &&\
    rm -rf ${MAUTIC_VERSION}.zip

# Configurando permissões do usuário
ENV USERNAME www-data
RUN chown -R ${USERNAME}:${USERNAME} ${DIR} &&\
    chown -R ${USERNAME}:${USERNAME} /var/log && chmod -R 755 /var/log

#USER ${USERNAME}

# Denifindo o diretorio principal
WORKDIR ${DIR}

# Expondo portas
EXPOSE 80
EXPOSE 443

# Comando de inicialização
CMD ["apachectl", "-D", "FOREGROUND"]
