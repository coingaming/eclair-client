# eclair-client

Lightning Network Node (Eclair) client library for Haskell. Docker is the only thing required to get started. Everything what is needed for development is included into nix-shell. Provide environment variables if needed:

```bash
vi ~/.zshrc

export VIM_BACKGROUND="light" # or "dark"
export VIM_COLOR_SCHEME="PaperColor" # or "jellybeans"
```

And then spawn development environment:

```bash
# start nix-shell
./nix/shell.sh

# run tests in nix-shell
stack test

# develop in nix-shell
vi .
```

# eclair-cli

Both (merchant and customer) LN nodes are using the same bitcoind node which is running in regtest mode. You can play around with cli utilities in nix-shell. Let's connect merchant and customer LN nodes and open LN channel:

```bash
eclair-customer connect --uri="$(eclair-merchant getinfo | jq -r '.nodeId')@localhost:9735"
# connected

eclair-customer open --nodeId="$(eclair-merchant getinfo | jq -r '.nodeId')" --fundingSatoshis=100000
# created channel 7b5da9c88f30c0f80f428ee8a4855cf768b0ad486fa7cd0732630610f2e123c5

eclair-customer channels
# TODO - continue ...
```
