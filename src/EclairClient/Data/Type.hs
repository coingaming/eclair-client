{-# LANGUAGE DerivingStrategies #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}

module EclairClient.Data.Type
  ( LnHost (..),
    LnPort (..),
    EclairApiUrl (..),
    EclairPassword (..),
    EclairAuthHeader (..),
    EclairNetworkManager (..),
    EclairEnv (..),
    BitcoinAddress (..),
    NodeId (..),
    ChannelId (..),
    Satoshi (..),
    MilliSatoshi (..),
    InvoiceExpirySeconds (..),
    PaymentPreimage (..),
    PaymentHash (..),
    InvoiceDescription (..),
    newEclairEnv,
  )
where

import qualified Data.ByteString.Base64 as B64 (encode)
import EclairClient.Import.External
import Network.Connection (TLSSettings (..))
import Network.HTTP.Client (Manager, newManager)
import Network.HTTP.Client.TLS (mkManagerSettings)
import Network.TLS (defaultParamsClient)

newtype LnHost = LnHost Text
  deriving newtype (ToJSON, FromJSON)

newtype LnPort = LnPort Word64
  deriving newtype (ToJSON, FromJSON)

newtype EclairApiUrl = EclairApiUrl String

newtype EclairPassword = EclairPassword ByteString

newtype EclairAuthHeader = EclairAuthHeader Header

newtype EclairNetworkManager = EclairNetworkManager Manager

data EclairEnv
  = EclairEnv
      { eclairLnHost :: LnHost,
        eclairLnPort :: LnPort,
        eclairApiUrl :: EclairApiUrl,
        eclairAuthHeader :: EclairAuthHeader,
        eclairNetworkManager :: EclairNetworkManager
      }

newtype BitcoinAddress = BitcoinAddress Text
  deriving newtype (ToJSON, FromJSON)

newtype NodeId = NodeId Text
  deriving newtype (ToJSON, FromJSON)

newtype ChannelId = ChannelId Text
  deriving newtype (ToJSON, FromJSON)

newtype Satoshi = Satoshi Word64
  deriving newtype (ToJSON, FromJSON, Eq, Ord)

newtype MilliSatoshi = MilliSatoshi Word64
  deriving newtype (ToJSON, FromJSON, Eq, Ord)

newtype InvoiceExpirySeconds = InvoiceExpirySeconds Word64
  deriving newtype (ToJSON, FromJSON, Eq, Ord)

newtype PaymentPreimage = PaymentPreimage Text
  deriving newtype (ToJSON, FromJSON)

newtype PaymentHash = PaymentHash Text
  deriving newtype (ToJSON, FromJSON)

newtype InvoiceDescription = InvoiceDescription Text
  deriving newtype (ToJSON, FromJSON, Eq)

newEclairAuthHeader :: EclairPassword -> EclairAuthHeader
newEclairAuthHeader =
  EclairAuthHeader
    . ("Authorization",)
    . ("Basic " <>)
    . B64.encode
    . (":" <>)
    . coerce

newEclairEnv ::
  LnHost ->
  LnPort ->
  EclairApiUrl ->
  EclairPassword ->
  IO EclairEnv
newEclairEnv lh lp au p = do
  manager <-
    newManager $
      mkManagerSettings
        (TLSSettings $ defaultParamsClient "" "")
        Nothing
  return $
    EclairEnv
      { eclairLnHost = lh,
        eclairLnPort = lp,
        eclairApiUrl = au,
        eclairAuthHeader = newEclairAuthHeader p,
        eclairNetworkManager = EclairNetworkManager manager
      }
