{ mkDerivation, aeson, async, base, base64-bytestring, bytestring
, chronos, conduit, connection, extra, hpack, hspec, hspec-wai
, http-client, http-client-tls, http-conduit, http-types, retry
, stdenv, stm, text, time, tls, unbounded-delays, universum
}:
mkDerivation {
  pname = "eclair-client";
  version = "0.1.0.0";
  src = ./..;
  libraryHaskellDepends = [
    aeson async base base64-bytestring bytestring chronos conduit
    connection extra hspec hspec-wai http-client http-client-tls
    http-conduit http-types retry stm text time tls unbounded-delays
    universum
  ];
  libraryToolDepends = [ hpack ];
  testHaskellDepends = [
    aeson async base base64-bytestring bytestring chronos conduit
    connection extra hspec hspec-wai http-client http-client-tls
    http-conduit http-types retry stm text time tls unbounded-delays
    universum
  ];
  prePatch = "hpack";
  homepage = "https://github.com/githubuser/eclair-client#readme";
  license = stdenv.lib.licenses.bsd3;
}
