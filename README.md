# MAUTIC - DOCKER

#### 1. Requisitos necessários 

Os recursos a seguir devem ser instalados em uma `EC2 da AWS` com o sistema operacional `ubuntu versão >= 20.04 (LTS)` ou caso preferir pode testar em máquina local desde que seja `LINUX`.
- docker [guia](https://docs.docker.com/engine/install/ubuntu)
- docker-compose [guia](https://github.com/Yelp/docker-compose/blob/master/docs/install.md)

#### 2.  Composição das imagens do docker

###### 2.1. Arquivo Dockerfile
  - ubuntu-20.04
  - php-7.4
  - apache2
  - mautic-4.3.1 (*Última versão - Junho/2022 e compatível com o php-7.4*)

###### 2.2. Arquivo docker-compose
  - MySQL-5.7 (*Opcional, usar apenas para testes locais*)
  - Mautic-4.3.1 (*Construído a partir da imagem do arquivo `Dockerfile`*)

###### 2.3. Arquivo docker-compose.cli

Este arquivo tem como finalidade auxilar, caso precise executar comandos `php` dentro do container. Isto ajudaria bastante, pois a documentação do mautic relata diversos comandos que podem ser executado, para fazer algum configuração especifica.
- Recomendamos criar uma alias `dcli` para executar o comando:  `docker-compose -f docker-compose.cli.yml run --rm`

- Exemplo de execução de comando de fila
   ```bash
   dcli php ./bin/console mautic:queue:process --env=prod -i page_hit
   ```
- Exemplo de execução de comando de cron jobs.
   ```bash
   dcli php ./bin/console mautic:email:send
   ```

#### 3.  Para executar o projeto

* Crie duas pastas no diretorio deste projeto com os seguintes nomes: `mautic` e `logs`
    ```bash
    mkdir mautic && mkdir logs
    ```
  
* Crie `volumes external` docker
  ```bash
  docker volume create --name=mautic_data
    ```

  ```bash
  docker volume create --name=mautic_logs
    ```

* Crie `network external` docker
   ```bash
   docker network create mautic_net
   ```

* Para construção das imagens `mautic_db` e `mautic_app`
    ```bash
      docker-compose build
    ```

* Para iniciar os containers `mautic_db` e `mautic_app`
    ```bash
      docker-compose up
    ```
    ou em background
    ```bash
      docker-compose up -d
    ```

* Para verificar se os containers `mautic_db` e `mautic_app` foram inicializados
    ```bash
      docker-compose ps
    ```
* Para derrubar os containers `mautic_db` e `mautic_app`
    ```bash
      docker-compose down
    ```

#### 4.  Montagem do volume da imagem

- O volume da `aplicação` é montado conforme especificado no arquivo `docker-compose.yml` em:

    ```
    mautic_data:
      driver: local
      driver_opts:
        o: bind
        type: none
        device: $PWD/mautic
    ```
- O volume dos `logs` é montado conforme especificado no arquivo `docker-compose.yml` em:

    ```
    mautic_logs:
      driver: local
      driver_opts:
        o: bind
        type: none
        device: $PWD/logs
    ```
  **OBSERVAÇÕES**: 
  - Se for usar o `EFS da AWS` para `aplicação` com docker instalado em `EC2` e faça a configuração do ponto de montagem do disco e configure a linha: `device: $PWD/mautic`
  - Se for usar o `EBS da AWS` para os `logs` com docker instalado em `EC2` e faça a configuração do ponto de montagem do disco e configure a linha: `device: $PWD/logs`
  - Para realizar alguma configuração extra na aplicação `mautic` use o diretório `mautic/app/config`

