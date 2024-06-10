# SSH-VPN

## Index

1. [Introduction](##Introduction)
2. [Topology](##Topology)
3. [Work Environment](##Work-Environment)
4. [Development](##Development)


## Introduction

In this activity, a temporary SSH-VPN connection will be established between two isolated (virtual) networks connected via the "Internet". Both networks use private IP addresses, so they do not have direct access to the Internet. All communication between these networks (to any port) will be done through the SSH-VPN tunnel.
Routes and interfaces configurations are temporary, to make them fixed it would be necessary to modify the corresponding system files. It is necessary to access as root.
We will work on a Netkit simulation.

## Topology
![Topology](https://github.com/jagumiel/SRDSI-Cybersecurity/blob/main/SSH-VPN/imgs/Topology/0.png?raw=true)
| Machine  | IP Address       | Router | IP Address       |
|---------|------------------|--------|------------------|
| servpn  | 172.16.134.20    | RS(1)     | 172.16.134.1     |
| pcs     | 172.16.134.30    | RS(0)     | 158.227.100.100  |
| clivpn  | 192.168.2.20     | RC(1)     | 192.168.2.1      |
| pcc     | 192.168.2.30     | RC(0)     | 158.227.200.200  |

## Work Environment

Similar to the Firewall-IPtables practice, we will work with a Netkit distribution based on Debian. The environment is exactly the same, using the Netkit ISO on a VMware Workstation 11 virtual machine.
The Netkit scenario is the following:
![Topology](https://github.com/jagumiel/SRDSI-Cybersecurity/blob/main/SSH-VPN/imgs/Topology/1.png?raw=true)

## Development

The following sections explain the detailed execution of the practice and the tests performed, along with the corresponding analysis of the results obtained.

### Establishment of SSH-VPN

1. Change the password on the SERVPN machine. In this case, the password is set to "aaaaaa".
![Pass change](https://github.com/jagumiel/SRDSI-Cybersecurity/blob/main/SSH-VPN/imgs/Console/00.png?raw=true)
2. On the client CLIVPN, create a tunnel and configure the "tun2" end. On the server side, the end will be called "tun1".
![Tun conf](https://github.com/jagumiel/SRDSI-Cybersecurity/blob/main/SSH-VPN/imgs/Console/01.png?raw=true)
3. On the SERVPN machine, configure the "tun1" end of the tunnel. Then, add the route to redirect all packets directed to the LANC network through the tunnel. Also, check the new routes in the forwarding table.
![Forwarding](https://github.com/jagumiel/SRDSI-Cybersecurity/blob/main/SSH-VPN/imgs/Console/02.png?raw=true)

#### Testing

1. Verify that the tunnel is working. This can be done using ping.
![Ping test](https://github.com/jagumiel/SRDSI-Cybersecurity/blob/main/SSH-VPN/imgs/Console/03.png?raw=true)
2. Test access to the web service of LANS, using the private address of the SERVPN server.
![Web service test](https://github.com/jagumiel/SRDSI-Cybersecurity/blob/main/SSH-VPN/imgs/Console/04.png?raw=true)
It can be observed in the routing table that the network "112.16.134.0" does not have a default gateway, so it is not yet possible to reach that address. Analyzing the routing table of the client router (RC), there is also no route to this network. However, this is verified by introducing the command.
3. Add the route to the LANS network through the tunnel. Repeat the previous test to see if there are any changes.
![Add route](https://github.com/jagumiel/SRDSI-Cybersecurity/blob/main/SSH-VPN/imgs/Console/05.png?raw=true)
In the image above, it can be seen how the new route has been added. The ping command was executed again, and unlike before, there is now a connection. A wget was also done to download the web, and it works correctly.
4. Perform the following tests with tcpdump:
- Download a web page on clivpn over eth0.
  Follow these steps:
  a. Activate tcpdump to listen on the eth0 network interface:
     ```
     tcpdump -i eth0 -w capture-eth0
     ```
  b. On the CLIVPN machine, make the request:
     ```
     wget 172.16.134.20
     ```
  c. The file is on the virtual machine; it needs to be moved to the host. The extension can then be changed to ".pcapng" and opened with WireShark:
     ```
     cp capture-eth0 /hostname/capture-tun1.pcapng
     ```
  The obtained results were as follows:
  ![Wireshark](https://github.com/jagumiel/SRDSI-Cybersecurity/blob/main/SSH-VPN/imgs/Wireshark/0.png?raw=true)

- Download a web page on clivpn over tun1.
  Follow the same steps, but this time listen on the tun1 interface. The obtained results were the following:
  ![Wireshark](https://github.com/jagumiel/SRDSI-Cybersecurity/blob/main/SSH-VPN/imgs/Wireshark/1.png?raw=true)

#### Conclusion

On the eth0 interface, the traffic is encrypted since a tunnel has been established. In the case of tun1, which is the virtual interface, it contains the packets that will later be sent through eth0, where they will travel encrypted.

### Site-to-Site VPN

So far, a connection has been established between the ends of two machines. In this section, the two networks will be connected so that any devices can access each other. The following steps need to be taken:

#### On CLIVPN:

1. Enable IP forwarding and mask the addresses coming from the tunnel.
![Enable Forwarding](https://github.com/jagumiel/SRDSI-Cybersecurity/blob/main/SSH-VPN/imgs/Console/06.png?raw=true)
2. On all machines (PCC) in the LANC network, redirect all packets to the remote LANS network through CLIVPN. Check the routing tables to verify.
![Add route](https://github.com/jagumiel/SRDSI-Cybersecurity/blob/main/SSH-VPN/imgs/Console/07.png?raw=true)

#### On SERVPN:

1. Enable IP forwarding and mask the addresses coming from the tunnel.
![Enable Forwarding](https://github.com/jagumiel/SRDSI-Cybersecurity/blob/main/SSH-VPN/imgs/Console/08.png?raw=true)
IP forwarding is done the same way as on CLIVPN, using the same line.
2. On all machines (PCS), redirect all packets to the remote LANC network through SERVPN. Obtain the routing tables to verify correctness.
![Add route](https://github.com/jagumiel/SRDSI-Cybersecurity/blob/main/SSH-VPN/imgs/Console/09.png?raw=true)

#### Testing Site-to-Site VPN

The following tests were performed:

##### On CLIVPN:

- **Capture traffic on the eth0 interface when making a request from PCC.**
Put tcpdump listening on CLIVPN, and launch a wget request to SERVPN on PCC. The obtained results are: ![Wireshark](https://github.com/jagumiel/SRDSI-Cybersecurity/blob/main/SSH-VPN/imgs/Wireshark/2.png?raw=true)
According to the connection scheme, PCC and CLIVPN are connected to the same switch. PCC sends the requests unencrypted, which arrive at the switch and are redirected to CLIVPN. The latter is responsible for encrypting them to send through the tunnel. This is why both types of protocols can be seen in use.

- **Capture traffic on the tun2 interface when making a request from PCC.**
Do the same as before, obtaining the following result:
![Wireshark](https://github.com/jagumiel/SRDSI-Cybersecurity/blob/main/SSH-VPN/imgs/Wireshark/3.png?raw=true)

##### On SERVPN:

- **Check access between remote machines with traceroute:**
![Traceroute](https://github.com/jagumiel/SRDSI-Cybersecurity/blob/main/SSH-VPN/imgs/Console/10.png?raw=true)
Access was verified from PCC to PCS as they are the farthest machines, meaning with the most hops. It worked correctly.
