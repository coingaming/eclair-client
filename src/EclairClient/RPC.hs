{-# LANGUAGE DuplicateRecordFields #-}
{-# LANGUAGE NamedFieldPuns #-}

module EclairClient.RPC
  ( getInfo,
    getNewAddress,
  )
where

import Data.ByteString.Lazy as BL (ByteString)
import EclairClient.Data.GetInfo as GetInfo (GetInfoResponse (..))
import EclairClient.Import
import Network.HTTP.Client
  ( Response (..),
    httpLbs,
    method,
    parseRequest,
    queryString,
    requestHeaders,
    responseStatus,
  )
import Network.HTTP.Types.Method (StdMethod (..), renderStdMethod)
import Network.HTTP.Types.Status (ok200)
import Network.HTTP.Types.URI (renderQuery)

type RpcResult a = IO (Either (Response BL.ByteString) a)

data RpcArgs a
  = RpcArgs
      { rpcEnv :: EclairEnv,
        rpcMethod :: StdMethod,
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
      rpcMethod,
      rpcUrlPath,
      rpcRequest
    } = do
    req0 <- parseRequest $ coerce (eclairUrl rpcEnv) <> rpcUrlPath
    let req1 =
          req0
            { method = renderStdMethod rpcMethod,
              queryString = renderQuery False $ toQuery rpcRequest,
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

getInfo :: EclairEnv -> RpcResult GetInfo.GetInfoResponse
getInfo env =
  rpc $
    RpcArgs
      { rpcEnv = env,
        rpcMethod = POST,
        rpcUrlPath = "/getinfo",
        rpcRequest = VoidRequest
      }

getNewAddress :: EclairEnv -> IO (Either (Response BL.ByteString) BitcoinAddress)
getNewAddress env =
  rpc $
    RpcArgs
      { rpcEnv = env,
        rpcMethod = POST,
        rpcUrlPath = "/getnewaddress",
        rpcRequest = VoidRequest
      }
