module EclairClient.RPCSpec (spec) where

import EclairClient
import EclairClient.Import
import EclairClient.TestEnv
import EclairClient.TestOrphan ()
import Test.Hspec

spec :: Spec
spec = do
  describe "getInfo" $ do
    it "getInfo succeeds" $ do
      env <- newMerchantEnv
      res <- getInfo env
      res `shouldSatisfy` isRight
  describe "getNewAddress" $ do
    it "getNewAddress succeeds" $ do
      env <- newMerchantEnv
      res <- getNewAddress env
      res `shouldSatisfy` isRight
