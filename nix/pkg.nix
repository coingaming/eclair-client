{ mkDerivation, async, base, bytestring, chronos, concur-core
, concur-replica, containers, envparse, esqueleto, extra
, file-embed, hpack, hspec, hspec-wai, katip, lens, microlens
, monad-logger, persistent, persistent-migration
, persistent-postgresql, persistent-template, replica
, resource-pool, retry, stdenv, stm, template-haskell, text, time
, unbounded-delays, universum, unliftio, wai
, wai-middleware-static-embedded, warp, websockets
}:
mkDerivation {
  pname = "eclair-client";
  version = "0.1.0.0";
  src = ./..;
  libraryHaskellDepends = [
    async base bytestring chronos concur-core concur-replica containers
    envparse esqueleto extra file-embed hspec hspec-wai katip lens
    microlens monad-logger persistent persistent-migration
    persistent-postgresql persistent-template replica resource-pool
    retry stm template-haskell text time unbounded-delays universum
    unliftio wai wai-middleware-static-embedded warp websockets
  ];
  libraryToolDepends = [ hpack ];
  testHaskellDepends = [
    async base bytestring chronos concur-core concur-replica containers
    envparse esqueleto extra file-embed hspec hspec-wai katip lens
    microlens monad-logger persistent persistent-migration
    persistent-postgresql persistent-template replica resource-pool
    retry stm template-haskell text time unbounded-delays universum
    unliftio wai wai-middleware-static-embedded warp websockets
  ];
  prePatch = "hpack";
  homepage = "https://github.com/githubuser/eclair-client#readme";
  license = stdenv.lib.licenses.bsd3;
}
