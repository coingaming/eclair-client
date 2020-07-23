#!/bin/sh

set -m

#
# Bitcoind
#

echo "starting bitcoind..."
bitcoind -datadir=$BTCD_DIR
bitcoin-cli -rpcwait -datadir=$BTCD_DIR -rpcport=18443 \
  generatetoaddress 101 2NE5UEcr8VJMby5G2ACRDzwTHPybeHuZ4kw
bitcoin-cli -rpcwait -datadir=$BTCD_DIR -rpcport=18443 getblockchaininfo
echo "bitcoind has been started!"

#
# Eclair
#

THIS_DIR="$(pwd)"

echo "starting eclair-merchant..."
nohup eclair-node.sh -Declair.datadir=$ECLAIR_MERCHANT_DIR > $THIS_DIR/.eclair-merchant/stdout.log &
echo "eclair-merchant has been started!"

echo "starting eclair-customer..."
nohup eclair-node.sh -Declair.datadir=$ECLAIR_CUSTOMER_DIR > $THIS_DIR/.eclair-customer/stdout.log &
echo "eclair-customer has been started!"

echo "spawn-test-deps executed"
