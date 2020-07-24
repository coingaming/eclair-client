{-# LANGUAGE DerivingStrategies #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}

module EclairClient.Data.Type
  ( EclairUrl (..),
    EclairPassword (..),
    EclairAuthHeader (..),
    EclairNetworkManager (..),
    EclairEnv (..),
    BitcoinAddress (..),
    NodeId (..),
    newEclairEnv,
  )
where

import qualified Data.ByteString.Base64 as B64 (encode)
import EclairClient.Import.External
import Network.Connection (TLSSettings (..))
import Network.HTTP.Client (Manager, newManager)
import Network.HTTP.Client.TLS (mkManagerSettings)
import Network.TLS (defaultParamsClient)

newtype EclairUrl = EclairUrl String

newtype EclairPassword = EclairPassword ByteString

newtype EclairAuthHeader = EclairAuthHeader Header

newtype EclairNetworkManager = EclairNetworkManager Manager

data EclairEnv
  = EclairEnv
      { eclairUrl :: EclairUrl,
        eclairAuthHeader :: EclairAuthHeader,
        eclairNetworkManager :: EclairNetworkManager
      }

newtype BitcoinAddress = BitcoinAddress Text
  deriving newtype (ToJSON, FromJSON)

newtype NodeId = NodeId Text
  deriving newtype (ToJSON, FromJSON)

newEclairAuthHeader :: EclairPassword -> EclairAuthHeader
newEclairAuthHeader =
  EclairAuthHeader
    . ("Authorization",)
    . ("Basic " <>)
    . B64.encode
    . (":" <>)
    . coerce

newEclairEnv :: EclairUrl -> EclairPassword -> IO EclairEnv
newEclairEnv eu ep = do
  manager <-
    newManager $
      mkManagerSettings
        (TLSSettings $ defaultParamsClient "" "")
        Nothing
  return $
    EclairEnv
      { eclairUrl = eu,
        eclairAuthHeader = newEclairAuthHeader ep,
        eclairNetworkManager = EclairNetworkManager manager
      }
