{-# LANGUAGE BangPatterns #-}

module Eclairclient.Data.Env
  ( Env (..),
    RawConfig (..),
    rawConfig,
    newEnv
  )
where

import Eclairclient.Data.Type
import Eclairclient.Import.External
import Env ((<=<), auto, header, help, keep, nonempty, parse, str, var)

data Env
  = Env
      { -- general
        envEndpointPort :: Int,
        -- logging
        envKatipNS :: Namespace,
        envKatipCTX :: LogContexts,
        envKatipLE :: LogEnv
      }

data RawConfig
  = RawConfig
      { -- general
        rawConfigEndpointPort :: Int,
        -- katip
        rawConfigLogEnv :: Text,
        rawConfigLogFormat :: LogFormat,
        rawConfigLogVerbosity :: Verbosity
      }

rawConfig :: IO RawConfig
rawConfig =
  parse (header "Eclairclient config") $
    RawConfig
      <$> var (auto <=< nonempty) "ECLAIR_CLIENT_ENDPOINT_PORT" op
      <*> var (str <=< nonempty) "ECLAIR_CLIENT_LOG_ENV" op
      <*> var (auto <=< nonempty) "ECLAIR_CLIENT_LOG_FORMAT" op
      <*> var (auto <=< nonempty) "ECLAIR_CLIENT_LOG_VERBOSITY" op
    where
      op = keep <> help ""

newEnv :: RawConfig -> KatipContextT IO Env
newEnv !rc = do
  le <- getLogEnv
  ctx <- getKatipContext
  ns <- getKatipNamespace
  return $
    Env
      { -- general
        envEndpointPort = rawConfigEndpointPort rc,
        -- logging
        envKatipLE = le,
        envKatipCTX = ctx,
        envKatipNS = ns
      }
