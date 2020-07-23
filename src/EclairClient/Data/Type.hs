module EclairClient.Data.Type
  ( EclairHost (..),
    EclairPort (..),
    EclairPassword (..),
    LogFormat (..),
  )
where

import EclairClient.Import.External

newtype EclairHost = EclairHost Text

newtype EclairPort = EclairPort Int

newtype EclairPassword = EclairPassword Text

data LogFormat
  = Bracket
  | JSON
  deriving (Read)
