let nixpkgs = import ./nixpkgs.nix;
in
{
  pkgs ? null,
  hexOrganization ? null, # organization account name on hex.pm
  hexApiKey ? null,       # plain text account API key on hex.pm
  robotSshKey ? null      # base64-encoded private id_rsa (for private git)
}:
let overlays = import ./overlay.nix {
                 inherit hexOrganization hexApiKey robotSshKey;
               };
    pkgs' = if pkgs == null
            then import nixpkgs {inherit overlays;}
            else pkgs;
in
with pkgs';

stdenv.mkDerivation {
  name = "eclair-client-env";
  buildInputs = [
    /* IDE */
    haskell-ide
    /* Apps */
    bitcoin
    eclair
    /* Utils */
    git
    nix-prefetch-scripts
    openssh
    cabal2nix
    cacert
    xxd
  ];

  TERM="xterm-256color";
  GIT_SSL_CAINFO="${cacert}/etc/ssl/certs/ca-bundle.crt";
  NIX_SSL_CERT_FILE="${cacert}/etc/ssl/certs/ca-bundle.crt";
  NIX_PATH="/nix/var/nix/profiles/per-user/root/channels";
  HEX_ORGANIZATION=hexOrganization;
  HEX_API_KEY=hexApiKey;
  ROBOT_SSH_KEY=robotSshKey;
  shellHook = ''
    source ./nix/export-test-envs.sh
    sh ./nix/reset-test-data.sh
    sh ./nix/spawn-test-deps.sh

    export HOOGLEDB=/root/.hoogle
    if [ "$(ls -A $HOOGLEDB)" ]; then
      echo "hoogle database already exists..."
    else
      echo "building hoogle database..."
      stack --stack-yaml=/app/stack.yaml exec hoogle generate
    fi

    if [ "$(ls -A ~/.cabal)" ]; then
      echo "cabal database already exists..."
    else
      echo "building cabal database..."
      cabal v2-update
    fi
  '';
}
