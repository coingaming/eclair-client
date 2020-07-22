let nixpkgs = import ./nixpkgs.nix;
in
{
  pkgs ? import nixpkgs {},
  hexOrganization ? null, # organization account name on hex.pm
  hexApiKey ? null,       # plain text account API key on hex.pm
  robotSshKey ? null      # base64-encoded private id_rsa (for private git)
}:
let pkg = import ./default.nix {inherit hexOrganization hexApiKey robotSshKey;};
in
with pkgs;

dockerTools.buildImage {
  name = "heathmont/eclair-client";
  contents = [ pkg ];

  config = {
    Cmd = [ "${pkg}/bin/eclair-client-exe" ];
    ExposedPorts = {
      "80/tcp" = {};
    };
  };
}
