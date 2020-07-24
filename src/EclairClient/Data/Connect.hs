module EclairClient.Data.Connect
  ( Request (..),
  )
where

import qualified Data.Aeson as A
import qualified Data.ByteString.Lazy as BL
import EclairClient.Import

data Request
  = Request
      { nodeId :: NodeId,
        host :: LnHost,
        port :: Maybe LnPort
      }

instance QueryLike Request where
  toQuery =
    genToQuery
      [ ("nodeId", Just . encodeUtf8 . (coerce :: NodeId -> Text) . nodeId),
        ("host", Just . encodeUtf8 . (coerce :: LnHost -> Text) . host),
        ("port", (BL.toStrict . A.encode <$>) . port)
      ]
