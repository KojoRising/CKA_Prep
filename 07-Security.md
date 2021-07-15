# Security

## Overview
1) Kubernetes Security Primitives
2) Secure Persistent Key Value Store
3) Authentication
4) Authorization
5) Security Contexts
6) TLS Certificates for Cluster Components
7) Images Securely
8) Network Policies


## 1) Security Primitives

### Secure Hosts | Please Secure Your Hosts!!
1) Root Access - Disabled
2) Password-based AuthN - Disabled
3) ONLY SSH Key AuthN - Enabled

### Recall | kube-apiserver
- Center of all Cluster-related Operations
- ***Must control access to API-Server!!***


### A) Authentication
1) Files - Username & Passwords
2) Files - Username & Tokens
3) Certificates
4) External Authentication Providers - LDAP

### B) Authorization
1) RBAC Mode
2) ABAC Mode
3) Node Mode 
4) Webhook Mode

### C) TLS Certificates

### D) Pod2Pod Communication
- Restrict Access between Pods - ***Network Policies***

---

## Accounts
#### We have 3 types of Users (excluding End Users):
1) Admins
2) Developers
3) Bots

#### Account Types
1) User - {Admin,Developer}
2) ServiceAccount - Bots

NOTE - K8s does not manage User accounts natively. BUT... it can manage ServiceAccounts

## AuthN Mechanisms
- Recall, kube-apiserver FIRST authenticates all requests that it receives 
  (whether via kubectl rr via ) 

#### AuthN Mechanism Types
1) Static Password File - List of User & Passwords
2) Static Token File
3) Certificates
4) 3rd-Party Services - LDAP, Kerberos, etc.


### A) AuthN Mechanism | User/Password File
1) CSV File w/ 4 Columns - {PW,UN,UID, GID}
2) Pass into kube-apiserver > ***--basic-auth-file=user-details.csv***

BELOW - Left-side is ***Hard-Way***, Right-Side is ***Kube-Adm way*** 
    - Note, ***Hard-Way*** requires restarting API-Server
    
![img_5.png](assets/7_authN_basic_config.png)

![img_6.png](assets/7_authN_basic_curl.png)


### B) AuthN Mechanism | Token File
1) CSV File w/ 4 Columns - {Token,UN,UID, GID}
2) Pass into kube-apiserver > ***--token-auth-file=user-token-details.csv***

BELOW - Left-side is ***Hard-Way***, Right-Side is ***Kube-Adm way***
- Note, ***Hard-Way*** requires restarting API-Server

![img_7.png](assets/7_authN_basic_token.png)

## 2) TLS Certificates for Cluster Components

### TLS | 10,000 View

1) Symmetric Encryption - Client/Server both have a copy of the same key, which is used to both decrypt/encrypt the {Username, Password}
    --> Disadvantages - You have to send Key over network, meaning Hacker can intercept and gain access
   
2) Asymmetric Encryption - Private Key == Key, Public Key == Lock. Everybody with the Public Key can lock info & send it to you. 
    --> You use your private key 
   
   
#### Public Key 
- You want to add your Public Key (or Lock) to the server's ***~/.ssh/authorized_keys*** file (or ***~/.ssh/known_hosts***)
   
![img_5.png](assets/7_tls_asymmetric_basics.png)

### Securely transferring Symmetric Key from Client to Server - Use ***openssl***


Server - Has a Public/Private Key Pair

Client - Encrypts the Symmetric_Key w/ the Server's Public_Key, and then sends it to the Server

Hackers - Are unable to access the Symmetric_Key since it's been encrypted w/ the Server's Public Key

![img_6.png](assets/7_symmetric_encryption_openssl.png)


### So why Certificates?

1) Imagine a Hacker manages to impersonate a banking website you normally access, and does the following:
    - Sends you a fake Public Key
    - You encrypt the symmetric key w/ their fake Public Key, & send it back to them
    - How can you ensure that you receive the correct Public Key?
    - ***Use a Certificate!!!***

![img_7.png](assets/7_certificate_basics.png)


### What Certificates Contain:
1) Issuer - Certificate Issuer
2) Subject - Certificate Issuee
3) Subject Alternative Name - Issuee's Alternative Names


### Self-Signed Certificates
These are generally not secure. Browser's have in-built security that check for this:
- ***NET::ERR_CERT_AUTHORITY_INVALID***    

![img_8.png](assets/7_browser_certificate_error.png)


### Certificate Authorities (CA)
Companies that will sign & validate your Certificate for you (ie. Symantec, GlobalSign, Digicert, etc. )

Process:
1) **Generate CSR (Certificate Signing Request)** - Using... 
   - Public_Key - You generated this earlier
   - Domain Name - Of your Website
   - Command: ***openssl req -new -key KEY.key -out KEY.csr -subj "/C=US/ST=CA/O=MyOrg, Inc./CN=my-bank.com"***
    
2) **CA** - Validates the Information

3) **CA** - Signs CA & Sends it back to you


### How do Browsers know whether or not CA is Valid?

*CA's have their own Private/Public Keys*
- ***Browsers have all the CAs' Public Keys***
- Great for Public Sites, but what about for internal websites?



### In Summary
1) CA (Certificate Authority) - Sends its Public_Key to a Browser, so that the Browser knows CA is valid
2) Server - Sends a CSR (Certificate Signing Request) to the CA for validation/signing
3) Server - Sends its Certificate + Public_Key to the Client 
4) Client - Verifies the Certificate 
5) Client - Encrypts its Symmetric_Key w/ the Server's Public_Key
6) Client - Sends encrypted Symmetric_Key back to the Server

Server - Sends Public Key


### Why doesn't User need Certificates

TODO: Elaborate here



### Conventions:

1) Public Keys - Usually end w/ ***.crt*** or ***.pem***

2) Private Keys - Usually end w/ ***.key*** or ***-key.pem***


![img_9.png](assets/7_tls_key_conventions.png)
