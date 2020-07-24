module EclairClient.TestEnv
  ( merchantNodeUrl,
    customerNodeUrl,
    newMerchantEnv,
    newCustomerEnv,
    setupEnv,
  )
where

import EclairClient.Import

merchantNodeUrl :: EclairUrl
merchantNodeUrl = EclairUrl "http://localhost:8080"

customerNodeUrl :: EclairUrl
customerNodeUrl = EclairUrl "http://localhost:8081"

nodePassword :: EclairPassword
nodePassword = EclairPassword "developer"

newMerchantEnv :: IO EclairEnv
newMerchantEnv = newEclairEnv merchantNodeUrl nodePassword

newCustomerEnv :: IO EclairEnv
newCustomerEnv = newEclairEnv customerNodeUrl nodePassword

setupEnv :: IO ()
setupEnv = return ()
