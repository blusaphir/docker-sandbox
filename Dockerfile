from ubuntu:16.04

RUN apt-get update && apt-get upgrade -y && apt-get install wget vim -y
RUN wget http://wordpress.org/latest.tar.gz
RUN tar -xzvf latest.tar.gz
RUN rm latest.tar.gz
RUN mkdir /var/www && mkdir /var/www/html
RUN mv wordpress/* /var/www/html

# Install PHP
RUN apt-get install php7.0 php7.0-cli php7.0-common php7.0-mysql php-fpm -y

# Now install MariaDB
RUN apt-get install software-properties-common -y
RUN apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xF1656F24C74CD1D8
RUN add-apt-repository 'deb [arch=amd64,i386,ppc64el] http://mirror.sax.uk.as61049.net/mariadb/repo/10.2/ubuntu xenial main'

RUN apt update -y
ENV DEBIAN_FRONTEND noninteractive
#  https://dba.stackexchange.com/questions/59317/install-mariadb-10-on-ubuntu-without-prompt-and-no-root-password
RUN ["/bin/bash", "-c", "debconf-set-selections <<< 'mariadb-server-10.0 mysql-server/root_password password PASS'"]
RUN ["/bin/bash", "-c", "debconf-set-selections <<< 'mariadb-server-10.0 mysql-server/root_password_again password PASS'"]
RUN apt-get install -y mariadb-server

# Setup DB
RUN service mysql start \
&& mysql -uroot -pPASS -e "SET PASSWORD = PASSWORD('');" \
&& mysql -u root -e "create database wordpress" \
&& mysql -u root -e "create user 'wordpress'@'localhost' identified by password ''" \
&& mysql -u root -e "GRANT ALL PRIVILEGES ON wordpress.* TO wordpress@localhost" \
&& mysql -u root -e "FLUSH PRIVILEGES" 

RUN apt-get install nginx -y

EXPOSE 80

CMD /bin/bash