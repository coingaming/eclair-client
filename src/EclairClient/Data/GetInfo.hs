module EclairClient.Data.GetInfo
  ( GetInfoResponse (..),
  )
where

import EclairClient.Import

newtype GetInfoResponse
  = GetInfoResponse
      { nodeId :: NodeId
      }
  deriving (Generic)

instance FromJSON GetInfoResponse
