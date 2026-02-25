# SRDSI Cybersecurity

SRDSI stands for "Seguridad, Rendimiento y Disponibilidad en Servicios e Infraestructuras", a BSc course focused on cybersecurity. This repository gathers my lab work, notes, and experiments from that subject.

## Contents

| Folder | Focus | Notes |
| --- | --- | --- |
| `PKI - Public Key Infrastructure/` | Public Key Infrastructure | Build a CA with OpenSSL, CRL/OCSP workflows, plus lab statements and reports (PDF). |
| `SSL - Secure Socket Layer/` | SSL/TLS over sockets | C client/server, Wireshark analysis, certificate validation notes. |
| `SSH-VPN/` | SSH tunneling and VPNs | Netkit lab, routing, tcpdump/Wireshark captures, site-to-site setup. |
| `SE050/` | Secure element demo | Simple blockchain-style signing with SE050 + secp256k1 via `ssscli`. |

## How to navigate

- Each folder has its own README with background, steps, and screenshots.
- Paths include spaces; quote them in shell commands.

## Tech and tools

- OpenSSL, C sockets, SSL/TLS
- SSH tunneling, routing, tcpdump/Wireshark
- NXP SE050 secure element (`ssscli`), secp256k1

## Notes

- Educational work from a university course; not production-hardened.
- The PKI lab includes sample keys and certificates; do not reuse them.
