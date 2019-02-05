# Pet Portal Blueprint

This is my Pet Portal includes extra governance in Service Now.  This blueprint also leverages the xlr-xlrelease-plugin to dynamically tag the releases with the Service Now tickets.

## Example Setup

```
xl --blueprint-repository-url http://localhost:9999/ blueprint
? Choose a blueprint: PetPortalServiceNowExtended
? What is the Folder name? PetPortalServiceNowExtended
? What is the Application name? petclinic-artifactory
? What is the Service Now URL? https://yourcompany.service-now.com/
? What is the Service Now User Name? ************
? What is the Service Now Password? ************
? What is the JIRA URL? https://yourcompany.atlassian.net/
? What is the JIRA User Name? ************
? What is the JIRA Password? ************
? Confirm to generate blueprint files? Yes
```

## Docker Compose

```
gogs:
  image: xebialabsunsupported/docker-gogs
  ports:
    - "10022:22"
    - "10080:3000"

artifactory:
  image: xebialabsunsupported/docker-artifactory
  ports:
    - "7080:8081"

jenkins:
  image: xebialabsunsupported/docker-jenkins:2.129-alpine
  volumes:
   - /var/run/docker.sock:/var/run/docker.sock
  links:
   - xld
   - artifactory
   - gogs
   - socat
   - devregistry
   - qaregistry
  ports:
   - "8080:8080"

xld:
  image: xebialabsunsupported/docker-xld:8.5.2-alpha26
  volumes:
   - ~/xl-licenses:/license
   - ~/keys:/keys
   - ./initialize/Datical-2.0.0.dar:/opt/xebialabs/xl-deploy-server/importablePackages/Datical-2.0.0.dar
   - ./initialize/hammer:/opt/xebialabs/hammer
  links:
   - mysql1
   - artifactory
   - socat
   - devregistry
   - qaregistry
   - jboss1
   - apache1
   - ansible1
   - glassfish
  ports:
   - "4516:4516"

xlr:
  image: xebialabsunsupported/docker-xlr:8.5.1
  volumes:
   - ~/xl-licenses:/license
   - ./initialize/downloads/xlr-delphix-plugin-2.0.0-rc.6.jar:/opt/xebialabs/xl-release-server/default-plugins/__local__/xlr-delphix-plugin-2.0.0-rc.6.jar
   - ./initialize/downloads/xlr-xlrelease-plugin-2.3.4.jar:/opt/xebialabs/xl-release-server/default-plugins/__local__/xlr-xlrelease-plugin-2.3.4.jar
  links:
   - jenkins
   - xld
   - artifactory
   - gogs
   - socat
   - devregistry
   - qaregistry
   - ansible1
   - delphix
  ports:
   - "5516:5516"

socat:
  image: bobrik/socat
  ports:
    - "2376:2375"
  links:
    - devregistry
  privileged: true
  volumes:
    - /var/run/docker.sock:/var/run/docker.sock
  command: TCP4-LISTEN:2375,fork,reuseaddr UNIX-CLIENT:/var/run/docker.sock

devregistry:
  restart: always
  image: registry:latest
  ports:
    - "5000:5000"
  environment:
    REGISTRY_AUTH: htpasswd
    REGISTRY_AUTH_HTPASSWD_PATH: /certs/htpasswd
    REGISTRY_AUTH_HTPASSWD_REALM: Registry Realm
    REGISTRY_HTTP_TLS_CERTIFICATE: /certs/devregistry.crt
    REGISTRY_HTTP_TLS_KEY: /certs/devregistry.key
  volumes:
    - ../resources/xl-deploy/certs/:/certs

qaregistry:
  restart: always
  image: registry:latest
  ports:
    - "5001:5000"
  environment:
    REGISTRY_AUTH: htpasswd
    REGISTRY_AUTH_HTPASSWD_PATH: /certs/htpasswd
    REGISTRY_AUTH_HTPASSWD_REALM: Registry Realm
    REGISTRY_HTTP_TLS_CERTIFICATE: /certs/qaregistry.crt
    REGISTRY_HTTP_TLS_KEY: /certs/qaregistry.key
  volumes:
    - ../resources/xl-deploy/certs/:/certs

jboss1:
  image: xebialabsunsupported/xl-docker-demo-jboss:9.0.2.Final
  ports:
   - "9990:9990"
   - "8880:8080"

mysql1:
  image: xebialabsunsupported/xl-docker-demo-mysql:5.7.17

apache1:
  image: xebialabsunsupported/xl-docker-demo-apache:2.4.33-alpine
  links:
   - jboss1
  ports:
   - "80:80"

ansible1:
  image: xebialabsunsupported/docker-ansible-oc:latest

delphix:
  image: xebialabsunsupported/xl-docker-demo-delphix

credentials:
  image: xebialabsunsupported/xl-docker-demo-xlr-credentials-updater:latest
  volumes:
    - ~/keys:/keys
  links:
    - xlr

xld_cli:
  image: xebialabsunsupported/xl-docker-demo-xld-cli:8.2.0
  volumes:
    - ~/keys:/keys
    - ./initialize:/data
  links:
    - xld

glassfish:
  image: xebialabsunsupported/glassfish:latest
  ports:
    - "9980:8080"
    - "9981:8181"
    - "9848:4848"
```
