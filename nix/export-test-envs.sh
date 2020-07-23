#!/bin/sh

THIS_DIR="$(pwd)"

#
# bitcoind
#

export BTCD_DIR="$THIS_DIR/.bitcoin"
alias bitcoind="bitcoind -datadir=$BTCD_DIR"
alias bitcoin-cli="bitcoin-cli -datadir=$BTCD_DIR -rpcport=18443"
export BTC_RPC_USER="developer"
export BTC_RPC_PASSWORD="developer"
export BTC_RPC_URL="http://localhost:18443"

#
# eclair
#

export ECLAIR_MERCHANT_DIR="$THIS_DIR/.eclair-merchant"
alias eclair-merchant="eclair-cli -p developer -a localhost:8080"
export ECLAIR_CUSTOMER_DIR="$THIS_DIR/.eclair-customer"
alias eclair-customer="eclair-cli -p developer -a localhost:8081"

#
# lib
#

export ECLAIR_CLIENT_ENV='
{
  "host":"localhost",
  "port":8080,
  "password":"developer"
}
'
