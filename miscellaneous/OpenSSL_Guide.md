# [OpenSSL Guide](https://www.digicert.com/kb/ssl-support/openssl-quick-reference-guide.htm) 


## Primary Commands
1) Generating Key - NOTE: This contains both Public + Private

        openssl genrsa -out yourdomain.key 2048

2) Decoding Private Key

        openssl rsa -text -in yourdomain.key -noout

3) Extracting Public Key from Private

        openssl rsa -in yourdomain.key -pubout -out yourdomain_public.key

4) Create CSR

        openssl req -new -key yourdomain.key -out yourdomain.csr -subj "/C=US/ST=Utah/L=Lehi/O=Your Company, Inc./OU=IT/CN=yourdomain.com"

5) Create CSR+KEY ***IN ONE COMMAND***

        openssl req -new \
        -newkey rsa:2048 -nodes -keyout yourdomain.key \
        -out yourdomain.csr \
        -subj "/C=US/ST=Utah/L=Lehi/O=Your Company, Inc./OU=IT/CN=yourdomain.com"

6) 


#### RECALL: k8s commands

1) openssl genrsa -out ca.key 2048
2) openssl req -new -in ca.key -subj="/CN=KUBERNETES_CA" -out ca.csr
3) openssl x509 -in ca.csr -req -signkey ca.key -out ca.crt


