module Eclairclient.Class
  ( EnvM (..),
  )
where

import Eclairclient.Data.Env (Env (..))
import Eclairclient.Import.External

class MonadIO m => EnvM m where
  getEnv :: m Env
