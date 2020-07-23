module EclairClient.Data.Type
  ( EclairUrl (..),
    EclairPassword (..),
    EclairAuthHeader (..),
    EclairNetworkManager (..),
    EclairEnv (..),
    BitcoinAddress (..),
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

newtype BitcoinAddress = BitcoinAddress Text

data EclairEnv
  = EclairEnv
      { eclairUrl :: EclairUrl,
        eclairAuthHeader :: EclairAuthHeader,
        eclairNetworkManager :: EclairNetworkManager
      }

newEclairAuthHeader :: EclairPassword -> EclairAuthHeader
newEclairAuthHeader =
  EclairAuthHeader
    . ("Authorization",)
    . ("Basic " <>)
    . B64.encode
    . (":" <>)
    . coerce

newEclairEnv :: MonadUnliftIO m => EclairUrl -> EclairPassword -> m EclairEnv
newEclairEnv eu ep = do
  manager <-
    liftIO
      $ newManager
      $ mkManagerSettings
        (TLSSettings $ defaultParamsClient "" "")
        Nothing
  return $
    EclairEnv
      { eclairUrl = eu,
        eclairAuthHeader = newEclairAuthHeader ep,
        eclairNetworkManager = EclairNetworkManager manager
      }

instance FromJSON BitcoinAddress where
  parseJSON (String x) = pure $ BitcoinAddress x
  parseJSON _ = fail "BitcoinAddress should be an JSON String"
