module EclairClient.TestEnv
  ( newMerchantEnv,
    newCustomerEnv,
    newBtcClient,
    setupEnv,
    liftRpcResult,
  )
where

import Data.ByteString.Lazy as BL
import EclairClient
import EclairClient.Import
import Network.Bitcoin as BTC (Client, getClient)
import Network.Bitcoin.Mining (generateToAddress)
import Network.HTTP.Client (Response (..))

newMerchantEnv :: IO EclairEnv
newMerchantEnv =
  newEclairEnv
    (LnHost "localhost")
    (LnPort 9735)
    (EclairApiUrl "http://localhost:8080")
    (EclairPassword "developer")

newCustomerEnv :: IO EclairEnv
newCustomerEnv =
  newEclairEnv
    (LnHost "localhost")
    (LnPort 9736)
    (EclairApiUrl "http://localhost:8081")
    (EclairPassword "developer")

newBtcClient :: IO BTC.Client
newBtcClient =
  getClient
    "http://localhost:18443"
    "developer"
    "developer"

setupEnv :: IO ()
setupEnv = do
  bc <- newBtcClient
  env <- newCustomerEnv
  addr <- liftRpcResult =<< getNewAddress env
  _ <- generateToAddress bc 101 (coerce addr) Nothing
  return ()

liftRpcResult :: Either (Response BL.ByteString) a -> IO a
liftRpcResult (Right x) = return x
liftRpcResult (Left x) = fail $ "liftRpcResult failed " <> show x
