{-# LANGUAGE DuplicateRecordFields #-}
{-# LANGUAGE NamedFieldPuns #-}

module EclairClient.RPC
  ( getInfo,
    getNewAddress,
    connect,
    openChannel,
  )
where

import Data.ByteString.Lazy as BL (ByteString, fromStrict)
import qualified EclairClient.Data.Connect as Connect
import qualified EclairClient.Data.GetInfo as GetInfo
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

--
-- TODO : remove me, just use
-- 3 args in rpc (eta reduction optimizations etc)
--
data RpcArgs a
  = RpcArgs
      { rpcEnv :: EclairEnv,
        rpcUrlPath :: String,
        rpcRequest :: a
      }

rpc ::
  (QueryLike a, FromJSON b) =>
  RpcArgs a ->
  IO (Either (Response BL.ByteString) b)
rpc
  RpcArgs
    { rpcEnv,
      rpcUrlPath,
      rpcRequest
    } = do
    req0 <- parseRequest $ coerce (eclairApiUrl rpcEnv) <> rpcUrlPath
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
getInfo env =
  rpc $
    RpcArgs
      { rpcEnv = env,
        rpcUrlPath = "/getinfo",
        rpcRequest = VoidRequest
      }

getNewAddress :: EclairEnv -> RpcResult BitcoinAddress
getNewAddress env =
  rpc $
    RpcArgs
      { rpcEnv = env,
        rpcUrlPath = "/getnewaddress",
        rpcRequest = VoidRequest
      }

connect :: EclairEnv -> Connect.Request -> RpcResult VoidResponse
connect env req =
  rpc $
    RpcArgs
      { rpcEnv = env,
        rpcUrlPath = "/connect",
        rpcRequest = req
      }

openChannel :: EclairEnv -> OpenChannel.Request -> RpcResult ChannelId
openChannel env req =
  rpc $
    RpcArgs
      { rpcEnv = env,
        rpcUrlPath = "/open",
        rpcRequest = req
      }
