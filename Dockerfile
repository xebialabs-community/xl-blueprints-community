FROM httpd
RUN apt-get update && \
    apt-get install -y git && \
    apt-get clean

RUN rm -rf /usr/local/apache2/htdocs/
COPY . /usr/local/apache2/htdocs/