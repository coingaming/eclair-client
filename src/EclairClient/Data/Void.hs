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
  deriving (Generic, Show)

data VoidResponse
  = VoidResponse
      {
      }
  deriving (Generic, Show, Read, Eq)

instance ToJSON VoidRequest where
  toJSON _ = object []

instance FromJSON VoidResponse where
  parseJSON _ = pure VoidResponse