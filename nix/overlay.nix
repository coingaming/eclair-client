{
  hexOrganization,
  hexApiKey,
  robotSshKey
}:
[
  (self: super:
    let
      callPackage = self.lib.callPackageWith self.haskellPackages;
      dontCheck = self.haskell.lib.dontCheck;
      doJailbreak = self.haskell.lib.doJailbreak;
    in
    {
        eclair = import (fetchTarball "https://github.com/coingaming/eclair/tarball/c09e932097c7c0c2befc909233b4f807a2564ed5") {};
        haskell-ide = import (fetchTarball "https://github.com/tim2CF/ultimate-haskell-ide/tarball/master") {};
        haskellPackages = super.haskell.packages.ghc865.extend(
          self': super': {
            universum = dontCheck super'.universum;
            persistent-migration = dontCheck (
              callPackage ./overlay/persistent-migration.nix {
                stdenv = self.stdenv;
                fetchgit = self.fetchgit;
              });
            hspec-wai = callPackage ./overlay/hspec-wai.nix {
              stdenv = self.stdenv;
            };
            hspec-wai-json = callPackage ./overlay/hspec-wai-json.nix {};
            scotty = callPackage ./overlay/scotty.nix {};
            HaskellNet = callPackage ./overlay/haskell-net.nix {};
            concur-core = callPackage ./overlay/concur-core.nix {
              stdenv = self.stdenv;
              fetchgit = self.fetchgit;
            };
            replica = callPackage ./overlay/replica.nix {
              stdenv = self.stdenv;
              fetchgit = self.fetchgit;
            };
            concur-replica = callPackage ./overlay/concur-replica.nix {
              stdenv = self.stdenv;
              fetchgit = self.fetchgit;
            };
            proto3-suite = dontCheck (doJailbreak super'.proto3-suite);
          }
        );
    }
  )
]
