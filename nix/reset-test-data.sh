#!/bin/sh

shopt -s extglob

echo "resetting test data..."
(cd $BTCD_DIR && rm -rf -v !("bitcoin.conf"))
(cd $ECLAIR_CUSTOMER_DIR && rm -rf -v !("eclair.conf"))
(cd $ECLAIR_MERCHANT_DIR && rm -rf -v !("eclair.conf"))
echo "test data has been reset!"
