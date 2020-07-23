module EclairClient.Data.EclairEnv
  ( EclairEnv (..),
  )
where

import EclairClient.Data.Type
import EclairClient.Import.External

data EclairEnv
  = EclairEnv
      { eclairHost :: EclairHost,
        eclairPort :: EclairPort,
        eclairPassword :: EclairPassword
      }
