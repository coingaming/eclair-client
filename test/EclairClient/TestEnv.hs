module EclairClient.TestEnv
  ( newMerchantEnv,
    newCustomerEnv,
    newBtcClient,
    setupEnv,
    mine101,
    liftRpcResult,
  )
where

import Data.ByteString.Lazy as BL hiding (all)
import EclairClient
import qualified EclairClient.Data.Channel as Channel
import qualified EclairClient.Data.CloseChannel as CloseChannel
import EclairClient.Import
import EclairClient.TestOrphan ()
import Network.Bitcoin as BTC (Client, HexString, getClient)
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

mine101 :: EclairEnv -> IO [BTC.HexString]
mine101 env = do
  bc <- newBtcClient
  addr <- liftRpcResult =<< getNewAddress env
  generateToAddress bc 101 (coerce addr) Nothing

setupEnv :: IO ()
setupEnv = do
  ce <- newCustomerEnv
  cs <-
    liftRpcResult
      =<< listChannels ce
  _ <-
    liftRpcResult
      =<< closeChannel (CloseChannel.Request $ Channel.channelId <$> cs) ce
  -- ??? _ <- delay 300000
  _ <- mine101 ce
  _ <- waitForChannel (const (== Channel.CLOSED)) ce
  return ()

waitForChannel :: (ChannelId -> Channel.ChannelState -> Bool) -> EclairEnv -> IO ()
waitForChannel f env = do
  cs <-
    liftRpcResult
      =<< listChannels env
  print cs
  if all (\x -> f (Channel.channelId x) (Channel.state x)) cs
    then return ()
    else waitForChannel f env

liftRpcResult :: Either (Response BL.ByteString) a -> IO a
liftRpcResult (Right x) = return x
liftRpcResult (Left x) = fail $ "liftRpcResult failed " <> show x
