module EclairClient.Data.Channel
  ( ChannelState (..),
    Channel (..),
  )
where

import EclairClient.Import

data ChannelState
  = WAIT_FOR_INIT_INTERNAL
  | WAIT_FOR_OPEN_CHANNEL
  | WAIT_FOR_ACCEPT_CHANNEL
  | WAIT_FOR_FUNDING_INTERNAL
  | WAIT_FOR_FUNDING_CREATED
  | WAIT_FOR_FUNDING_SIGNED
  | WAIT_FOR_FUNDING_CONFIRMED
  | WAIT_FOR_FUNDING_LOCKED
  | NORMAL
  | SHUTDOWN
  | NEGOTIATING
  | CLOSING
  | CLOSED
  | OFFLINE
  | SYNCING
  | WAIT_FOR_REMOTE_PUBLISH_FUTURE_COMMITMENT
  | ERR_FUNDING_LOST
  | ERR_INFORMATION_LEAK
  deriving (Generic, Eq)

instance FromJSON ChannelState

data Channel
  = Channel
      { nodeId :: NodeId,
        channelId :: ChannelId,
        state :: ChannelState
      }
  deriving (Generic)

instance FromJSON Channel
