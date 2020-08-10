module EclairClient.RPCSpec (spec) where

import EclairClient
import qualified EclairClient.Data.Connect as Connect
import qualified EclairClient.Data.GetInfo as GetInfo
import qualified EclairClient.Data.OpenChannel as OpenChannel
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
  describe "connect" $ do
    it "connect succeeds" $ do
      me <- newMerchantEnv
      ce <- newCustomerEnv
      GetInfo.Response mid <- liftRpcResult =<< getInfo me
      let req = Connect.Request mid (eclairLnHost me) (Just $ eclairLnPort me)
      res <- connect req ce
      res `shouldSatisfy` isRight
  describe "openChannel" $ do
    it "openChannel succeeds" $ do
      me <- newMerchantEnv
      ce <- newCustomerEnv
      GetInfo.Response mid <- liftRpcResult =<< getInfo me
      let req =
            OpenChannel.Request
              { OpenChannel.nodeId = mid,
                OpenChannel.fundingSatoshis = Satoshi 1000000,
                OpenChannel.pushMsat = Just $ MilliSatoshi 500
              }
      res <- openChannel req ce
      res `shouldSatisfy` isRight
