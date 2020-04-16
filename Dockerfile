FROM mcr.microsoft.com/mssql/server:2019-CU3-ubuntu-18.04 as build 

# enviroments variables
ENV DATABASE_NAME ''
ENV USERNAME_APPLICATION ''
ENV PASSWORD_APPLICATION ''

USER root

# install SQL Server tools
RUN apt-get update && ACCEPT_EULA=Y apt-get install -y mssql-tools && echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc && /bin/bash -c "source ~/.bashrc" && ln -sfn /opt/mssql-tools/bin/sqlcmd /usr/bin/sqlcmd

# install localization
RUN apt-get -y install locales && locale-gen pt_BR.UTF-8 && update-locale LANG=pt_BR.UTF-8

WORKDIR /app
COPY /scripts /app/scripts
COPY /build /app
RUN ls -R

# grant execute all sh
RUN chmod +x -R /app/

CMD /bin/bash ./startup.sh

USER mssql
