#!/bin/SH

# Simple Blockchain Using SE050 & Secp256k1
# Uses SE050 for secure key storage & signing.

BLOCKCHAIN_DIR="./blockchain"
BLOCK_ID=1
SE050_KEY_ID="0x25020401"
CURVE="Secp256k1"

# Setup Blockchain Directory
mkdir -p $BLOCKCHAIN_DIR

echo "Step 1: Generating ECC Key Pair (Secp256k1) in SE050..."
ssscli generate ecc $SE050_KEY_ID $CURVE

echo "Step 2: Retrieving Public Key for Verification..."
ssscli get ecc pub $SE050_KEY_ID $BLOCKCHAIN_DIR/public_key.pem

echo "Step 3: Creating the First Block (Genesis Block)..."
echo "Block 1" > $BLOCKCHAIN_DIR/block1.txt
echo "Previous Hash: 0000000000" >> $BLOCKCHAIN_DIR/block1.txt
echo "Transaction Data: Alice to Bob: 5 BTC" >> $BLOCKCHAIN_DIR/block1.txt

echo "Step 4: Signing Block 1 Using SE050..."
ssscli sign $SE050_KEY_ID $BLOCKCHAIN_DIR/block1.txt $BLOCKCHAIN_DIR/block1.sig # No puedo agregar esto --hashalgo RSASSA_PKCS1_V1_5_SHA256

echo "Step 5: Verifying Block 1 Signature..."
ssscli verify $SE050_KEY_ID $BLOCKCHAIN_DIR/block1.txt $BLOCKCHAIN_DIR/block1.sig

echo "Block 1 Successfully Created & Verified!"
BLOCK_ID=$((BLOCK_ID + 1))

while true; do
    read -p "Add a new block? (y/n): " choice
    if [[ "$choice" != "y" ]]; then
        break
    fi

    PREV_BLOCK="block$((BLOCK_ID - 1)).txt"
    NEW_BLOCK="block$BLOCK_ID.txt"
    SIG_FILE="block$BLOCK_ID.sig"

    echo "Step 6: Hashing Previous Block..."
    PREV_HASH=$(openssl dgst -sha256 $BLOCKCHAIN_DIR/$PREV_BLOCK | awk '{print $2}')

    echo "Step 7: Creating Block $BLOCK_ID..."
    echo "Block $BLOCK_ID" > $BLOCKCHAIN_DIR/$NEW_BLOCK
    echo "Previous Hash: $PREV_HASH" >> $BLOCKCHAIN_DIR/$NEW_BLOCK
    echo "Transaction Data: Bob → Charlie: 3 BTC" >> $BLOCKCHAIN_DIR/$NEW_BLOCK

    echo "Step 8: Signing Block $BLOCK_ID..."
    ssscli sign $SE050_KEY_ID $BLOCKCHAIN_DIR/$NEW_BLOCK $BLOCKCHAIN_DIR/$SIG_FILE

    echo "Step 9: Verifying Signature for Block $BLOCK_ID..."
    ssscli verify $SE050_KEY_ID $BLOCKCHAIN_DIR/$NEW_BLOCK $BLOCKCHAIN_DIR/$SIG_FILE

    if [[ $? -eq 0 ]]; then
        echo "Block $BLOCK_ID Successfully Created & Verified!"
    else
        echo "ERROR: Block $BLOCK_ID Signature Verification Failed!"
        exit 1
    fi

    BLOCK_ID=$((BLOCK_ID + 1))
done

echo "Blockchain Creation Complete!"
echo "Blockchain Stored in: $BLOCKCHAIN_DIR"
