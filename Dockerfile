# definindo a imagem base
FROM mcr.microsoft.com/mssql/server:2019-CU3-ubuntu-18.04

# variáveis de ambiente, que serão utilizadas dentro do initialdatabase.sh
ENV DATABASE_NAME ''
ENV USERNAME_APPLICATION ''
ENV PASSWORD_APPLICATION ''

# definição do usuário root para que possamos instalar as ferramantas
USER root

# instalação do SQL Server CMD para execução dos scripts em modo CLI
RUN apt-get update && ACCEPT_EULA=Y apt-get install -y mssql-tools && echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc && /bin/bash -c "source ~/.bashrc" && ln -sfn /opt/mssql-tools/bin/sqlcmd /usr/bin/sqlcmd

# instação da linguagem pt-br
RUN apt-get -y install locales && locale-gen pt_BR.UTF-8 && update-locale LANG=pt_BR.UTF-8

# definição do diretorio de trabalho
WORKDIR /app

# copia de todos os arquivos .sql quando houver
COPY /scripts /app/scripts

# copia dos arquivos sh para execução como entrypoint ou cmd
COPY /build /app

# permissão de execução dos arquivos no diretorio de trabalho
RUN chmod +x -R /app/

# definição do script 'startup.sh'
CMD /bin/bash ./startup.sh

# definição do usuário mssql com menos previlegios
USER mssql
