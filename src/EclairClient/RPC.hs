{-# LANGUAGE DuplicateRecordFields #-}
{-# LANGUAGE NamedFieldPuns #-}

module EclairClient.RPC
  ( getNewAddress,
  )
where

import Data.ByteString.Lazy as BL (ByteString)
import EclairClient.Import
import Network.HTTP.Client
  ( RequestBody (RequestBodyLBS),
    Response (..),
    httpLbs,
    method,
    parseRequest,
    queryString,
    requestBody,
    requestHeaders,
    responseStatus,
  )
import Network.HTTP.Types.Method (StdMethod (..), renderStdMethod)
import Network.HTTP.Types.Status (ok200)
import Network.HTTP.Types.URI (Query, renderQuery)

data RpcArgs a
  = RpcArgs
      { rpcEnv :: EclairEnv,
        rpcMethod :: StdMethod,
        rpcUrlPath :: String,
        --
        -- TODO : remove it if url query string is
        -- not used in Eclair API
        --
        rpcUrlQuery :: Query,
        rpcReqBody :: Maybe a
      }

rpc ::
  (ToJSON a, FromJSON b, MonadUnliftIO m) =>
  RpcArgs a ->
  m (Either (Response BL.ByteString) b)
rpc
  RpcArgs
    { rpcEnv,
      rpcMethod,
      rpcUrlPath,
      rpcUrlQuery,
      rpcReqBody
    } = do
    req0 <- liftIO $ parseRequest $ coerce (eclairUrl rpcEnv) <> rpcUrlPath
    let req1 =
          req0
            { method = renderStdMethod rpcMethod,
              queryString = renderQuery False rpcUrlQuery,
              requestHeaders =
                [ coerce $ eclairAuthHeader rpcEnv,
                  ("Content-Type", "application/json")
                ]
            }
    let req2 =
          maybe
            req1
            (\b -> req1 {requestBody = RequestBodyLBS $ encode b})
            rpcReqBody
    res <- liftIO $ httpLbs req2 $ coerce $ eclairNetworkManager rpcEnv
    return $
      if responseStatus res == ok200
        then first (const res) $ eitherDecode $ responseBody res
        else Left res

getNewAddress ::
  MonadUnliftIO m =>
  EclairEnv ->
  m (Either (Response BL.ByteString) BitcoinAddress)
getNewAddress env =
  rpc $
    RpcArgs
      { rpcEnv = env,
        rpcMethod = POST,
        rpcUrlPath = "/getnewaddress",
        rpcUrlQuery = [],
        rpcReqBody = Nothing :: Maybe VoidRequest
      }
