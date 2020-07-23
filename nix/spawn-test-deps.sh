#!/bin/sh

set -m

#
# Bitcoind
#

echo "starting bitcoind..."
bitcoind -datadir=$BTCD_DIR
alias bitcoin-cli="bitcoin-cli -rpcwait -datadir=$BTCD_DIR -rpcport=18443"
bitcoin-cli generatetoaddress 101 "$(bitcoin-cli getnewaddress)"
bitcoin-cli getblockchaininfo
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
