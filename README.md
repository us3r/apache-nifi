# docker-nifi
Docker image of Apache Nifi

![Apache NiFi logo](http://nifi.apache.org/images/niFi-logo-horizontal.png "Apache NiFi")
# dockerfile-apache-nifi

### Apache NiFi Dockerfile

Provides a Dockerfile and associated scripts for configuring an instance of [Apache NiFi](http://nifi.apache.org)
With using ENV variable you are able to manage each property in nifi.properties file.

1. Build the image:
    ```
    docker build . -t nifi:latest
    ```
    
2. Run the image:
   ```
   docker run -it -d --name nifi \
     -p 8080:8080
     -e nifi_ui_banner_text="my banner"
   ```
`-e nifi_ui_banner_text="my banner"` will setup `nifi.ui.banner.text` key in nifi.properties file. You only need to keep in mind that "." should be replaced by "_".
