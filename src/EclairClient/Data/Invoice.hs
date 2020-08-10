module EclairClient.Data.Invoice
  ( Invoice (..),
  )
where

import EclairClient.Import

data Invoice
  = Invoice
      { prefix :: Text,
        timestamp :: Word64,
        nodeId :: NodeId,
        serialized :: Text,
        description :: InvoiceDescription,
        paymentHash :: PaymentHash,
        expiry :: InvoiceExpirySeconds,
        amount :: MilliSatoshi
      }
  deriving (Generic)

instance FromJSON Invoice
