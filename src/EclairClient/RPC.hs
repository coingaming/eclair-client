{-# LANGUAGE DuplicateRecordFields #-}
{-# LANGUAGE NamedFieldPuns #-}

module EclairClient.RPC
  ( getInfo,
    getNewAddress,
    connect,
    openChannel,
    createInvoice,
  )
where

import Data.ByteString.Lazy as BL (ByteString, fromStrict)
import qualified EclairClient.Data.Connect as Connect
import qualified EclairClient.Data.CreateInvoice as CreateInvoice
import qualified EclairClient.Data.GetInfo as GetInfo
import EclairClient.Data.Invoice (Invoice)
import qualified EclairClient.Data.OpenChannel as OpenChannel
import EclairClient.Import
import Network.HTTP.Client
  ( RequestBody (RequestBodyLBS),
    Response (..),
    httpLbs,
    method,
    parseRequest,
    requestBody,
    requestHeaders,
    responseStatus,
  )
import Network.HTTP.Types.Method (StdMethod (..), renderStdMethod)
import Network.HTTP.Types.Status (ok200)
import Network.HTTP.Types.URI (renderQuery)

type RpcResult a = IO (Either (Response BL.ByteString) a)

newtype RpcUrlPath = RpcUrlPath String

rpc ::
  (QueryLike a, FromJSON b) =>
  RpcUrlPath ->
  a ->
  EclairEnv ->
  IO (Either (Response BL.ByteString) b)
rpc rpcUrlPath rpcRequest rpcEnv = do
  req0 <- parseRequest $ coerce (eclairApiUrl rpcEnv) <> coerce rpcUrlPath
  let req1 =
        req0
          { method =
              renderStdMethod POST,
            requestBody =
              RequestBodyLBS
                $ BL.fromStrict
                $ renderQuery False
                $ toQuery rpcRequest,
            requestHeaders =
              [ coerce $ eclairAuthHeader rpcEnv,
                ("Content-Type", "application/x-www-form-urlencoded")
              ]
          }
  res <- httpLbs req1 $ coerce $ eclairNetworkManager rpcEnv
  return $
    if responseStatus res == ok200
      then first (const res) $ eitherDecode $ responseBody res
      else Left res

getInfo :: EclairEnv -> RpcResult GetInfo.Response
getInfo = rpc (RpcUrlPath "/getinfo") VoidRequest

getNewAddress :: EclairEnv -> RpcResult BitcoinAddress
getNewAddress = rpc (RpcUrlPath "/getnewaddress") VoidRequest

connect :: Connect.Request -> EclairEnv -> RpcResult VoidResponse
connect = rpc $ RpcUrlPath "/connect"

openChannel :: OpenChannel.Request -> EclairEnv -> RpcResult ChannelId
openChannel = rpc $ RpcUrlPath "/open"

createInvoice :: CreateInvoice.Request -> EclairEnv -> RpcResult Invoice
createInvoice = rpc $ RpcUrlPath "/createinvoice"
