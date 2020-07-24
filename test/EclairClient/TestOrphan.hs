{-# LANGUAGE StandaloneDeriving #-}
{-# OPTIONS_GHC -fno-warn-orphans #-}

module EclairClient.TestOrphan
  (
  )
where

import qualified EclairClient.Data.GetInfo as GetInfo
import EclairClient.Import

deriving instance Show BitcoinAddress

deriving instance Show NodeId

deriving instance Show GetInfo.Response

deriving instance Show VoidResponse

deriving instance Show ChannelId
