#!/bin/sh

#
# app
#

export ECLAIR_CLIENT_LOG_ENV="dev"
export ECLAIR_CLIENT_LOG_FORMAT="Bracket" # Bracket | JSON
export ECLAIR_CLIENT_LIBPQ_CONN_STR="postgresql://nixbld1@localhost/eclair-client"
export ECLAIR_CLIENT_ENDPOINT_PORT="3000"
