module EclairClient.Data.CloseChannel
  ( Request (..),
  )
where

import qualified Data.Aeson as A
import qualified Data.ByteString.Lazy as BL
import EclairClient.Import

newtype Request
  = Request
      { channelIds :: [ChannelId]
      }

instance QueryLike Request where
  toQuery =
    genToQuery
      [ ("channelIds", Just . BL.toStrict . A.encode . channelIds)
      ]
