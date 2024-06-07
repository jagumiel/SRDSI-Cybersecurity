# SSH - Secure SHell

## Introduction
Secure Sockets Layer is a security system for encrypting data in a distributed application protocol based on the socket interface. In this lab, the aim is to see how the content of frames can be intercepted in an unsecured application protocol. In the second section, SSL will be implemented, so that the information will no longer travel in plain text.

## Environment
A physical machine with a Debian 8 distribution will be used. To run the server and the client it will be done in LocalHost, opening two terminals, one with the server and the other with the client.

## Testing the Application Environment
In this section, we will test a distributed application utilizing the socket interface. This application consists of two main components: a server and a client.

### Server
The server will be implemented as a process that runs continuously, listening for incoming connections from client applications. When a client connects to the server, the server will execute the Unix finger command and send the results back to the client.

### Client
The client application, running on a different machine, will establish a connection to the server. Upon successful connection, it will send a request to the server, prompting the server to execute the finger command and return the output.

### The finger Command
In Unix, finger is a program that provides information about system users. When executed, it typically displays details such as the user's username, real name, home directory, shell, and other available information configured in the system.

### Communication Protocol
The communication protocol between the server and the client will follow these steps:

1. Connection Establishment:
    - The client initiates a connection to the server using the server's IP address and a predefined port number.
    - The server accepts the connection, establishing a communication channel between the client and server.
2. Request Handling:
    - Upon connection, the client sends a request to the server.
    - The server processes this request, which involves running the finger command on its system.
3. Response Transmission:
    - The server captures the output of the finger command.
    - The server sends this output back to the client over the established connection.
4. Connection Termination:
    - Once the client receives the response, it may process the information as needed.
    - After the data exchange, the connection can be gracefully terminated by either the client or server.

![Protocol scheme](https://github.com/jagumiel/SRDSI-Cybersecurity/blob/main/SSL%20-%20Secure%20Socket%20Layer/images/0.png?raw=true)

This setup demonstrates a simple yet powerful use of socket programming to enable inter-machine communication and remote command execution. WireShark can be used to check whether this protocol is actually complied with:

![Wireshark frame capture](https://github.com/jagumiel/SRDSI-Cybersecurity/blob/main/SSL%20-%20Secure%20Socket%20Layer/images/1.png?raw=true)

In frames numbered 103 and 104, the client sends a message to the server, initiating a synchronization process. This interaction establishes the connection and is represented in the graph as a 'TCP connection'.

#### Frame-by-Frame Analysis:

1. Frames 103 and 104:
    - Client Message: The client initiates communication by sending a message to the server.
    - Server Response: The server responds to the client's message, completing the initial synchronization phase of the TCP connection.
2. Frame 105:
    - Acknowledgment (ACK): The client sends an ACK (acknowledgment) packet to the server. This packet confirms that the client has received the server's response and is ready to proceed.
3. Frames 106 and 107:
    - Data Transmission: The server begins transmitting data to the client. The data is segmented into packets, and frames 106 and 107 contain these data segments.
4. Client Confirmation and Connection Closure:
    - Client ACK: The client sends an acknowledgment to the server, confirming the receipt of the transmitted data.
    - Connection Termination: The client sends a message to close the connection. The server responds with an ACK, indicating that the connection closure process is acknowledged and will proceed.

#### Verification of the Protocol:

The protocol used for this communication is verified to match the one indicated in the image. By examining the frames, it is evident that the data travels as plain text, which is typical for a TCP connection without any encryption. This plain text transmission allows us to observe the raw data being exchanged between the client and server, confirming the integrity and expected behavior of the protocol.

This detailed step-by-step interaction highlights the typical lifecycle of a TCP connection, from establishment to data exchange and eventual termination.

![Wireshark frame capture](https://github.com/jagumiel/SRDSI-Cybersecurity/blob/main/SSL%20-%20Secure%20Socket%20Layer/images/2.png?raw=true)
This is the message that the client receives, as this screenshot demonstrates, it is visible to anyone analysing the network traffic.

## Securing an Application Protocol
### Enhancing Security with SSL/TLS
In the previous section, we demonstrated how TCP transmissions lack inherent security, resulting in data being sent in plain text. In this section, we will explore how to secure data exchanges using an SSL (Secure Sockets Layer) security layer, which encrypts the transmitted data.

### SSL vs. TLS
It is important to note that SSL is not fully secure by modern standards. The key derivation process in SSL 3.0 is particularly weak, as it relies partially on the MD5 hash, which has known vulnerabilities. Therefore, it is recommended to use TLS (Transport Layer Security) instead of SSL for better security. TLS is the successor to SSL and addresses many of its weaknesses, providing a more robust security mechanism.

### Securing the Application
To secure the distributed application tested previously tested, the provided files will be used. Specifically, it is needed to combine ssl_***-auth.c with ***-infouser.c. The asterisks denote that the file names should be adjusted to refer to either the server or the client, as this is a distributed application.

### Steps to Implement SSL/TLS
1. File Integration:
    - Combine the authentication logic from ssl_***-auth.c with the user information logic from ***-infouser.c.
    - Ensure that the resulting files correctly handle SSL/TLS initialization, handshake, encryption, and decryption processes.
2. Server-Side Implementation:
    - Merge ssl_server-auth.c with server-infouser.c to create a secure server implementation.
    - The server should initialize SSL/TLS, listen for incoming connections, perform the SSL handshake, and handle encrypted data transmission.
3. Client-Side Implementation:
    - Merge ssl_client-auth.c with client-infouser.c to create a secure client implementation.
    - The client should initiate an SSL/TLS connection to the server, perform the SSL handshake, and transmit encrypted data.

### Resulting Secure Application
The resulting code, which combines SSL/TLS with the existing application logic, is available in the source folder. This secure implementation ensures that data exchanged between the client and server is encrypted, providing confidentiality and integrity during transmission.

By following these steps, you can enhance the security of your distributed application, mitigating the risks associated with plain text data transmission.

## Results
The results of this lab were not entirely satisfactory, as some problems were encountered. These problems were not caused by the implementation of SSL, nor by the understanding of the ‘handshake’ to be performed, but by the validation of certificates by the client. The certificates presented by the server are not validated, despite being signed by a Certificate Authority (CA) that is present in the application through the use of the SSL_CTX_load_verify_locations function. The following screenshots show the problem:

### Server:
![Server screenshot](https://github.com/jagumiel/SRDSI-Cybersecurity/blob/main/SSL%20-%20Secure%20Socket%20Layer/images/3.png?raw=true)

### Client:
![Client screenshot](https://github.com/jagumiel/SRDSI-Cybersecurity/blob/main/SSL%20-%20Secure%20Socket%20Layer/images/4.png?raw=true)

### Certificate Validation Issues
This test demonstrates that the certificate issued by the server is not validated by the client. This issue is critical as it prevents the establishment of a secure connection.
Comparative Test with a Known Website

To further illustrate the problem, we conducted a comparative test using a well-known website, such as Facebook. During this test, the client attempts to establish a connection with the website. The following observations were made:

1. Server Connection Attempt:
    - The client successfully connects to the Facebook server.
2. Certificate Validation Attempt:
    - The server (Facebook) attempts to validate the client's certificate.
3. Validation Failure:
    - Since the Facebook server's certificate is not the same as the one used in our application, and there is no real CA present to validate it, the client reports that no valid certificates are available.
    - As a result, the connection is terminated by the server due to the lack of valid certificates on the client side.

## Expected Next Steps
Had the certificate validation worked correctly, the following steps would have been conducted:

- WireShark Analysis:
    - Using WireShark, we would capture and analyze the network traffic to verify that the information is traveling securely over the SSL/TLS encrypted channel.
    - This analysis would confirm that the data exchanged between the client and server is indeed encrypted, preventing any plain-text transmission.

- Further Security Tests:
    - Additional tests would include simulating different types of attacks to ensure the robustness of the SSL/TLS implementation.
    - We would also test the application under various conditions to verify the stability and reliability of the secure connection.

## Conclusion
The current test highlights a significant issue with the certificate validation process, which needs to be addressed to ensure secure communication. By resolving this issue, we can proceed with further tests and analyses to confirm the effectiveness of the SSL/TLS security layer.
