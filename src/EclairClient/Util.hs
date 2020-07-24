module EclairClient.Util (genToQuery) where

import EclairClient.Import.External

genToQuery :: [(ByteString, a -> Maybe ByteString)] -> a -> Query
genToQuery fs x = toQuery $ (\(t, f) -> (t,) <$> f x) <$> fs
