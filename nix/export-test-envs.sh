#!/bin/sh

THIS_DIR="$(pwd)"

#
# bitcoind
#

export BTCD_DIR="$THIS_DIR/.bitcoin"
alias bitcoin-cli="bitcoin-cli -rpcwait -datadir=$BTCD_DIR -rpcport=18443"

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
