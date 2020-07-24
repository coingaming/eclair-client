{-# LANGUAGE StandaloneDeriving #-}
{-# OPTIONS_GHC -fno-warn-orphans #-}

module EclairClient.TestOrphan
  (
  )
where

import EclairClient.Data.GetInfo as GetInfo (GetInfoResponse (..))
import EclairClient.Import

deriving instance Show BitcoinAddress

deriving instance Show NodeId

deriving instance Show GetInfo.GetInfoResponse
