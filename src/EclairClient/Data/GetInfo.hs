module EclairClient.Data.GetInfo
  ( Response (..),
  )
where

import EclairClient.Import

newtype Response
  = Response
      { nodeId :: NodeId
      }
  deriving (Generic)

instance FromJSON Response
