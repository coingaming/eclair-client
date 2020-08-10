{-# LANGUAGE DeriveGeneric #-}

module EclairClient.Data.Void
  ( VoidRequest (..),
    VoidResponse (..),
    OkResponse (..),
  )
where

import EclairClient.Import.External

data VoidRequest
  = VoidRequest
      {
      }

data VoidResponse
  = VoidResponse
      {
      }
  deriving (Generic)

data OkResponse = OkResponse

instance QueryLike VoidRequest where
  toQuery = const []

instance FromJSON VoidResponse where
  parseJSON _ = pure VoidResponse

instance FromJSON OkResponse where
  parseJSON = \case
    String "ok" -> return OkResponse
    _ -> empty
