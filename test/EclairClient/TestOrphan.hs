{-# LANGUAGE StandaloneDeriving #-}
{-# OPTIONS_GHC -fno-warn-orphans #-}

module EclairClient.TestOrphan
  (
  )
where

import EclairClient.Data.Channel
import qualified EclairClient.Data.GetInfo as GetInfo
import EclairClient.Data.Invoice
import EclairClient.Import

deriving instance Show BitcoinAddress

deriving instance Show NodeId

deriving instance Show GetInfo.Response

deriving instance Show VoidResponse

deriving instance Show ChannelId

deriving instance Show Invoice

deriving instance Show InvoiceDescription

deriving instance Show PaymentHash

deriving instance Show InvoiceExpirySeconds

deriving instance Show Satoshi

deriving instance Show MilliSatoshi

deriving instance Show Channel

deriving instance Show ChannelState
