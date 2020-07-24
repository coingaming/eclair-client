module EclairClient.TestEnv
  ( newMerchantEnv,
    newCustomerEnv,
    setupEnv,
    liftRpcResult,
  )
where

import Data.ByteString.Lazy as BL
import EclairClient.Import
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

setupEnv :: IO ()
setupEnv = return ()

liftRpcResult :: Either (Response BL.ByteString) a -> IO a
liftRpcResult (Right x) = return x
liftRpcResult (Left x) = fail $ "liftRpcResult failed " <> show x
