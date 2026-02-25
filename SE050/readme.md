# SE050 - Secure Element Demo

Minimal "blockchain-style" signing demo using an NXP SE050 secure element and the secp256k1 curve. The script generates a key inside the secure element, exports the public key, and then signs a sequence of blocks while chaining them with SHA-256 hashes.

## Files

- `blockchain-demo.sh`: interactive demo script.

## Requirements

- NXP SE050 (or SE05x) connected and accessible.
- `ssscli` in your `PATH` (NXP Plug & Trust tools).
- OpenSSL (`openssl dgst -sha256`).
- Bash (the script uses `[[ ... ]]` and `read -p`).

## Run

```sh
cd SE050
bash blockchain-demo.sh
```

Optional:

```sh
chmod +x blockchain-demo.sh
./blockchain-demo.sh
```

## What the script does

1. Generates an ECC key pair (Secp256k1) inside the SE050 at key ID `0x25020401`.
2. Exports the public key to `blockchain/public_key.pem`.
3. Creates a genesis block and signs it with the secure element.
4. Verifies the signature.
5. Repeats interactively to append more blocks:
   - Hashes the previous block with SHA-256.
   - Writes a new block containing the previous hash.
   - Signs and verifies the new block.

## Output

The script creates a `blockchain/` folder with:

- `public_key.pem`
- `block1.txt`, `block2.txt`, ...
- `block1.sig`, `block2.sig`, ...

## Notes

- This is a learning demo, not a production blockchain.
- The private key never leaves the secure element.
- If the key ID is already in use, update `SE050_KEY_ID` inside `blockchain-demo.sh`.
