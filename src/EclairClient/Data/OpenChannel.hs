module EclairClient.Data.OpenChannel
  ( Request (..),
  )
where

import qualified Data.Aeson as A
import qualified Data.ByteString.Lazy as BL
import EclairClient.Import

data Request
  = Request
      { nodeId :: NodeId,
        fundingSatoshis :: Satoshi,
        pushMsat :: Maybe MilliSatoshi
      }

instance QueryLike Request where
  toQuery =
    genToQuery
      [ ("nodeId", Just . encodeUtf8 . (coerce :: NodeId -> Text) . nodeId),
        ("fundingSatoshis", Just . BL.toStrict . A.encode . fundingSatoshis),
        ("pushMsat", (BL.toStrict . A.encode <$>) . pushMsat)
      ]
