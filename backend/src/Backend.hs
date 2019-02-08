{-# LANGUAGE EmptyCase #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE RankNTypes #-}
{-# LANGUAGE TypeFamilies #-}
module Backend where

import Frontend
import Common.Api
import Common.Route
import Control.Concurrent (forkIO)
import Network.Wai (Application)
import Network.Wai.Handler.Warp (run)
import Obelisk.Backend
import Servant ((:<|>) (..), Proxy (..), Server)

import qualified Servant as Servant

api :: Proxy Api
api = Proxy

server :: Server Api
server = add :<|> sub
  where
    add x y = return (x + y)
    sub x y = return (x - y)

app :: Application
app = Servant.serve api server

backend :: Backend BackendRoute FrontendRoute
backend = Backend
  { _backend_run = \serve -> serve $ const $ return ()
  , _backend_routeEncoder = backendRouteEncoder
  }

mainBackend :: IO ()
mainBackend = do
  _ <- forkIO $ run 8081 app
  runBackend backend frontend

