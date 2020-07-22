module Eclairclient.Data.Type (LogFormat(..)) where

import Eclairclient.Import.External

data LogFormat
  = Bracket
  | JSON
  deriving (Read)
