module Lib
  ( someFunc,
  )
where

import Eclairclient.Import

someFunc :: IO ()
someFunc = putStrLn ("someFunc" :: Text)
