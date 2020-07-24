{-# LANGUAGE DeriveGeneric #-}

module EclairClient.Data.Void
  ( VoidRequest (..),
    VoidResponse (..),
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

instance QueryLike VoidRequest where
  toQuery = const []

instance FromJSON VoidResponse where
  parseJSON _ = pure VoidResponse
