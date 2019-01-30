FROM httpd

RUN rm -rf /usr/local/apache2/htdocs/
COPY . /usr/local/apache2/htdocs/