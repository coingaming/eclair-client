module EclairClient.RPCSpec (spec) where

import EclairClient
import qualified EclairClient.Data.Connect as Connect
import qualified EclairClient.Data.CreateInvoice as CreateInvoice
import qualified EclairClient.Data.GetInfo as GetInfo
import qualified EclairClient.Data.Invoice as Invoice
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
  describe "createInvoice" $ do
    it "createInvoice succeeds" $ do
      env <- newMerchantEnv
      let desc = InvoiceDescription "reckless"
      let amount = MilliSatoshi 10
      let expiry = InvoiceExpirySeconds 3600
      res <- createInvoice (CreateInvoice.Request desc amount expiry Nothing) env
      res
        `shouldSatisfy` ( \case
                            Left _ -> False
                            Right i ->
                              (Invoice.description i == desc)
                                && (Invoice.amount i == amount)
                                && (Invoice.expiry i == expiry)
                        )
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
      setupEnv
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
