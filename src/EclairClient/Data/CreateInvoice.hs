module EclairClient.Data.CreateInvoice
  ( Request (..),
  )
where

import qualified Data.Aeson as A
import qualified Data.ByteString.Lazy as BL
import EclairClient.Import

data Request
  = Request
      { description :: InvoiceDescription,
        amountMsat :: MilliSatoshi,
        expireIn :: InvoiceExpirySeconds,
        paymentPreimage :: Maybe PaymentPreimage
      }

instance QueryLike Request where
  toQuery =
    genToQuery
      [ ( "description",
          Just
            . encodeUtf8
            . (coerce :: InvoiceDescription -> Text)
            . description
        ),
        ( "amountMsat",
          Just
            . (BL.toStrict . A.encode)
            . (coerce :: MilliSatoshi -> Word64)
            . amountMsat
        ),
        ( "expireIn",
          Just
            . (BL.toStrict . A.encode)
            . (coerce :: InvoiceExpirySeconds -> Word64)
            . expireIn
        ),
        ( "paymentPreimage",
          (BL.toStrict . A.encode <$>)
            . paymentPreimage
        )
      ]
