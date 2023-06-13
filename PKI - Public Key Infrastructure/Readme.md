# PKI - Public Key Infrastructure
## _Creating our own Certification Authority_


## Introduction
In today's digital age, securing sensitive information and maintaining trust in online communication is of paramount importance. Public Key Infrastructure (PKI) provides a framework for secure and trusted digital communication. It is a fundamental building block of modern cybersecurity, enabling secure communication, data protection, and identity verification in the digital realm. By leveraging cryptographic keys, digital certificates, and trusted authorities, PKI establishes the foundation for secure online transactions and helps mitigate the risks associated with unauthorized access, data breaches, and identity fraud.

### What is PKI?
PKI, short for Public Key Infrastructure, is a comprehensive system of technologies, policies, and procedures designed to establish and manage the secure exchange of information in a networked environment. At its core, PKI enables the secure sharing of sensitive data, authentication of digital identities, and the encryption of information to protect its confidentiality and integrity.

### How does PKI work?
PKI relies on a pair of cryptographic keys: a public key and a private key. The public key is freely distributed and used to encrypt data, while the private key is kept secret and used for decrypting the encrypted data. These keys are mathematically related, and any data encrypted with one key can only be decrypted using the corresponding key from the pair.

### Key Components of PKI:
1.	Certificate Authority (CA): A trusted entity that issues and manages digital certificates. The CA is responsible for verifying the identity of individuals or organizations and digitally signing their certificates, thereby ensuring trust in the PKI ecosystem.
2.	Digital Certificates: These are electronic documents that bind a public key to a specific identity. Digital certificates serve as proof of the authenticity and integrity of the public key holder, enabling secure communication and verifying the identity of participants in digital transactions.
3.	Certificate Revocation: PKI incorporates mechanisms to revoke certificates in cases where a private key is compromised or no longer valid. Revocation ensures that unauthorized parties cannot misuse certificates or impersonate legitimate entities.

### Benefits of PKI (CIAAN):
1.	**Confidentiality:** PKI enables the encryption of sensitive information, ensuring that only authorized recipients can access and decipher it. This protects data from interception and unauthorized access during transmission.
2.	**Integrity:** Through digital signatures, PKI guarantees the integrity of data by verifying that it has not been tampered with during transit. Any alteration to the data will render the digital signature invalid, indicating a breach of integrity.
3.	**Availability:** PKI can contribute to ensuring the availability of services and resources by implementing measures such as certificate backups and redundancy. This helps prevent disruptions caused by system failures, natural disasters, or other unforeseen events.
4.	**Authentication:** PKI facilitates strong authentication by verifying the identity of individuals or entities in online transactions. Digital certificates issued by trusted CAs help establish trust, enabling secure interactions in various contexts such as e-commerce, online banking, and secure email communication.
5.	**Non-repudiation:** PKI provides non-repudiation capabilities, meaning that the sender of a message or the signer of a document cannot later deny having sent or signed it. Digital signatures, created using the sender's private key, serve as cryptographic proof of authenticity and can be independently verified, thus preventing individuals from disowning their actions.


> Note: This repository contains private keys. This is just an example for educational purposes only. You should **never** share your private keys.

## Creating the PKI structure

    .
    ├── pki                             # Main Folder. PKI.
        ├── certs                       # Folder to store certificates.
        │   └── ca-root.crt             # Root CA certificate file.
        ├── db                          # Folder to store the PKI database files.
        │   ├── index.txt               # Index file to keep track of issued certificates.
        │   ├── certnum.srl             # Certificate serial number file.
        │   └── crlnum.srl              # CRL (Certificate Revocation List) serial number file.
        ├── private                     # O# Folder to store private key(s). Only admins have access.
        │   └── ca-root.key             # Root CA private key file.
        └── ca_openssl.cnf              # Configuration file for OpenSSL.



- pki: This is the main folder of your PKI repository, which holds all the PKI-related files and folders.
   - certs: This folder is used to store certificates issued by the PKI. In this case, it contains the ca-root.crt file, which represents the root CA certificate.
    - db: This folder contains the PKI database files. These files include the index.txt file, which maintains a record of issued certificates, and the certnum.srl and crlnum.srl files, which store the serial numbers for certificates and CRLs, respectively.
    - private: This folder is meant to securely store private key(s) associated with the PKI. In this case, it includes the ca-root.key file, which represents the private key for the root CA. Access to this folder should be restricted to authorized administrators only.
- ca_openssl.cnf: This file is a configuration file specific to OpenSSL, a commonly used software library for PKI operations. It likely contains settings and parameters for the PKI, such as certificate extensions, cryptographic algorithms, and other configuration options.

### Initialization steps:
Before using the PKI, ensure the initialization of the following files in the db folder:

- **certnum.srl** and **crlnum.srl:** These files need to be initialized with random hexadecimal values. You can use the following command to generate random values and write them to the respective files:

```sh
openssl rand -hex 8 > db/certnum.srl
openssl rand -hex 8 > db/crlnum.srl
```
- **index.txt:** This file needs to be created to maintain a record of issued certificates. You can create this file using a console editor like "nano" or with the command "touch":

```sh
touch db/index.txt
```

Ensure that you have appropriate permissions to access and modify the necessary files and folders. Additionally, it is recommended to secure the private folder, allowing access only to authorized administrators.

```sh
chmod 700 private
```
