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


> **Note:** This repository contains private keys. This is just an example for educational purposes only. You should **never** share your private keys.

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

### Configuration and Key Generation

To correctly configure the PKI and generate the key pair, follow these steps:
1. Filling the ca_openssl.cnf file: The "ca_openssl.cnf" file contains the configuration settings for OpenSSL. Ensure that you provide the necessary information and adjust the file according to your specific requirements. Open the file in a text editor and make the required modifications. The file has already been modified according to the proposed path structure.
2. Generating the Key Pair: To generate the key pair, use the following command while considering the relative paths:

    ```sh
    sudo openssl req -new -nodes -keyout private/ca-root.key -out certs/ca-root.crt -config ca_openssl.cnf
    ```
    
    By using sudo before the command, you ensure that the command is executed with the necessary administrative privileges to write to the private and certs folders.

The openssl req command is used to generate a new key pair and certificate signing request (CSR). Here's an explanation of the options used in the command:

- new: Generate a new CSR and private key.
- nodes: Generate the private key without encryption (no password protection).
- keyout private/ca-root.key: Specify the output file path for the private key. Here, the relative path private/ca-root.key is used to save the private key inside the private folder.
- out certs/ca-root.crt: Specify the output file path for the certificate. Here, the relative path certs/ca-root.crt is used to save the certificate inside the certs folder.
- config ca_openssl.cnf: Specify the path to the configuration file (ca_openssl.cnf).

### Self-Signing the Key

To self-sign the key and generate a self-signed certificate, follow these steps:

1. Make sure you have properly configured the ca_openssl.cnf file with the necessary settings. Open the file in a text editor and make any required modifications.
2. Open a terminal or command prompt and navigate to the root directory of your PKI repository.
3. Generate the self-signed key and certificate using the following command:
    ```sh
    sudo openssl req -new -nodes -keyout private/ca-root.key -out certs/ca-root.crt -config ca_openssl.cnf
    ```
4. Follow the prompts to provide the necessary information for the self-signed certificate, such as the Common Name (CN) and other details.
5. Review the generated self-signed key (private/ca-root.key) and certificate (certs/ca-root.crt) in their respective folders.

> **Important Note:** A self-signed certificate is not issued by a recognized Certificate Authority (CA), but it can be used for self-validation within your own PKI infrastructure.

### Generating an Empty CRL

To generate an empty Certificate Revocation List (CRL), which is used to list revoked certificates along with relevant information, follow these steps:

1. Make sure you have properly configured the ca_openssl.cnf and tou are on a terminal opened in the root directory of your PKI repository.
2. Generate the empty CRL using the following command:
    ```sh
    sudo openssl ca -gencrl -out certs/crl-ca-root.pem -config ca_openssl.cnf
    ```
3. The command will generate an empty CRL file, certs/crl-ca-root.pem, which you can use to list any revoked certificates in the future. This file can be updated with revoked certificates and relevant details such as the revocation date and reason.

The openssl ca command with the -gencrl option is used to generate the CRL. Here's an explanation of the options used in the command:
- gencrl: Generate the Certificate Revocation List.
- out certs/crl-ca-root.pem: Specify the output file path for the CRL. Here, the relative path certs/crl-ca-root.pem is used to save the CRL inside the certs folder.
- config ca_openssl.cnf: Specify the path to the configuration file (ca_openssl.cnf).


> **Important Note:** At this stage the CRL is empty since no certificates have been revoked yet. As you issue and potentially revoke certificates, you can update the CRL accordingly.
    
### Generating the Key and Certificate for the OCSP Server
To generate the key and certificate for an OCSP (Online Certificate Status Protocol) server, follow these steps:

1. Make sure you have properly configured the ca_openssl.cnf file with the necessary settings. Open the file in a text editor and make any required modifications.
2. Open a terminal or command prompt and navigate to the root directory of your PKI repository.
3. Generate the key pair for the OCSP server using the following command (similar to the previous key generation command):
    ```sh
    sudo openssl req -new -nodes -keyout private/clave-privada-ca-ocsp.key -out certs/certificado-ca-ocsp.csr -config ca_openssl.cnf
    ```
    The openssl req command is used to generate a new key pair and certificate signing request (CSR) for the OCSP server. Here's an explanation of the options used in the command:
4. Follow the prompts to provide the necessary information for the OCSP server certificate, such as the Common Name (CN) and other details.
5. Sign the OCSP server certificate using the PKI's private key. Assuming the PKI's private key is private/ca-root.key, use the following command:
    ```sh
    sudo openssl ca -in certs/certificado-ca-ocsp.csr -out certs/certificado-ca-ocsp.crt -config ca_openssl.cnf -extensions ocsp_ext
    ```
6. Review the generated OCSP server certificate (certs/certificado-ca-ocsp.crt) and the corresponding private key (private/clave-privada-ca-ocsp.key) in their respective folders.

> **Important Note:** The private key should be kept secure and protected.
    
## Using the PKI

Great! Now we have the PKI working. As the PKI infrastructure is set up and operational, various operations can be performed to leverage its capabilities. This section will guide you through the essential tasks of issuing certificates, revoking certificates, validating certificates via an OCSP responder, and exporting certificates and private keys. By following these instructions, you'll be able to effectively utilize the PKI to establish trust, enable secure communication, and ensure the integrity of digital assets within your environment.

### Issuing a Certificate
When issuing a certificate within a PKI, it is common practice to request a certificate with the same name as the CA (Certificate Authority). This naming convention ensures consistency and clarity within the PKI hierarchy. By having the CA's name as the subject of the issued certificate, it clearly indicates that the certificate has been issued by the trusted CA and helps establish trust in the certificate's authenticity.

To create a new certificate and sign it using the CA's private key, the next steps were followed:
1. Generate a new key pair and certificate signing request (CSR) for "user3" using the following command:
    ```sh
    openssl req -new -nodes -keyout private/user3.key -out certs/user3_request.csr -config ca_openssl.cnf
    ```
    This command generates a new private key file (private/user3.key) and a certificate signing request file (certs/user3_request.csr) for "user3" using the configuration file ca_openssl.cnf.
2. Submit the CSR file (user3_request.csr) to the Certificate Authority (CA) for signing. Transfer the CSR securely to the CA following your organization's established procedures. This step will be not needed in our environment, as we are into the PKI itself.
3. Once the CA receives the CSR, it can sign the certificate using the CA's private key. Use the following command to sign the certificate:
     ```sh
    openssl ca -in certs/user3_request.csr -out certs/user3.crt -config ca_openssl.cnf
    ```
    This command reads the CSR file (certs/user3_request.csr), signs it using the CA's private key, and generates the signed certificate file (certs/user3.crt). The CA's configuration file (ca_openssl.cnf) is used to define the certificate signing policies and extensions.

4. The CA may require additional steps, such as verifying the identity of the entity requesting the certificate, conducting a certificate revocation check, or applying additional security measures as per your organization's policies.
5. Review the signed certificate (certs/user3.crt) in the certs folder. The issued certificate can now be used by "user3" for secure communication and authentication purposes.

### Revoking a Certificate
Revoking a certificate is an important step in maintaining the integrity and security of a PKI (Public Key Infrastructure). There are several reasons why you might want to revoke a certificate from a user:

1. **Compromised Private Key:** If the user's private key associated with the certificate has been compromised or is suspected to be compromised, it is crucial to revoke the certificate. By revoking the certificate, you ensure that any attempts to use the compromised private key for unauthorized access or fraudulent activities are rendered invalid.
2. **Employee Departure or Role Change:** When an employee leaves the organization or changes roles, it is often necessary to revoke their certificate to prevent unauthorized access to sensitive systems, data, or resources. Revoking the certificate ensures that the user no longer possesses a valid credential for authentication and secure communication within the organization.
3. **Certificate Expiration:** Certificates have a defined validity period. When a certificate reaches its expiration date, it is considered invalid. However, it is good practice to formally revoke the expired certificate to maintain an accurate record of its status and prevent any potential misuse or confusion.
4. **Certificate Policy Violation:** If a user violates the organization's certificate policies or terms of use, their certificate may be revoked as a disciplinary measure or to enforce compliance. Examples of policy violations include unauthorized certificate usage, misuse of privileges, or violations of security policies.
5. **Suspected or Detected Certificate Tampering:** If there is evidence or suspicion of certificate tampering, such as modifications or alterations, it is necessary to revoke the certificate. Tampering with a certificate compromises its integrity and authenticity, undermining the trustworthiness of the PKI.

By revoking a certificate, you invalidate its status and communicate to relying parties that the certificate should no longer be trusted. This helps ensure that only valid and trusted certificates are used for secure communication, authentication, and access control within the PKI environment. Let's see how this is done on _user3_:

1. Revoke the certificate for "user3" using the following command:
     ```sh
    openssl ca -revoke certs/user3.crt -config ca_openssl.cnf
    ```
    This command revokes the certificate (certs/user3.crt) for "user3" based on the CA's configuration file (ca_openssl.cnf).
2. Update the Certificate Revocation List (CRL) to include the revoked certificate. Use the following command:
     ```sh
    openssl ca -gencrl -out certs/crl-ca-root.pem -config ca_openssl.cnf
    ```
    This command generates an updated CRL file (certs/crl-ca-root.pem) that includes the information about the revoked certificate.
3. Review the CRL file (pki/certs/crl-ca-root.pem) in the pki/certs folder to ensure that the revoked certificate for "user3" is listed.

> **Important Note:** Distribute the updated CRL to relevant parties, such as relying parties, OCSP responders, or other entities that need to verify the revocation status of certificates issued by the PKI.

### Certificate validation with OCSP responder
To perform certificate validation using an OCSP (Online Certificate Status Protocol) responder, follow these steps (We will be using 2 different terminals or tabs):

1. Start the OCSP responder using the following command on **Terminal 1**:
     ```sh
    openssl ocsp -port 444 -index db/index.txt -CA certs/ca-root.crl -rsigner certs/certificado-ca-ocsp.crt -rkey private/clave-privada-ca-ocsp -text -out log.txt
    ```
    This command starts the OCSP responder on port 444. It uses the certificate revocation list (certs/ca-root.crl) and the OCSP responder's certificate (certs/certificado-ca-ocsp.crt) and private key (private/clave-privada-ca-ocsp) for verification. The -text option enables verbose output, and the -out log.txt option redirects the log output to a file.
2. Open a **Terminal 2** and perform certificate validation using the OCSP responder with the following command:
     ```sh
    openssl ocsp -CAfile certs/ca-root.crt -issuer certs/ca-root.crt -url https://127.0.0.1:444 -cert certs/user3.crt -resp_text
    ```
    This command performs the certificate validation process. It specifies the CA certificate (certs/ca-root.crt) and the issuer certificate (certs/ca-root.crt) for verification. The -url option sets the URL of the OCSP responder (in this case, https://127.0.0.1:444). The -cert option specifies the certificate to be validated (certs/user3.crt). The -resp_text option displays the response in text format.
3. The OCSP responder should provide a response indicating the status of the certificate. If the certificate for "user3" was previously revoked, the server should indicate that the certificate has been revoked.
