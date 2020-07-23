#!/bin/sh

echo "resetting test data..."
rm -rf $ECLAIR_CUSTOMER_DIR/regtest
rm -rf $ECLAIR_MERCHANT_DIR/regtest
rm -rf $BTCD_DIR/regtest
echo "test data has been reset!"
