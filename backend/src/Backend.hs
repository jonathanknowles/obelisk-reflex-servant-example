{-# LANGUAGE EmptyCase #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE RankNTypes #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE OverloadedStrings #-}

module Backend where

import Frontend
import Common.Api
import Common.Route
import Obelisk.Route
import Obelisk.Backend

import Servant.API ((:<|>) (..))
import Servant (serveSnap, Server)
import Snap.Core (MonadSnap)


server :: MonadSnap m => Server Api l m
server = add :<|> sub :<|> echo
  where
    add x y = return (x + y)
    sub x y = return (x - y)
    echo = return "echo"

apiServer :: MonadSnap m => m ()
apiServer = serveSnap api server

backend :: Backend BackendRoute FrontendRoute
backend = Backend
  { _backend_run = \serve -> serve $ \case
      (BackendRoute_Api     :/ _)  -> apiServer
      (BackendRoute_Missing :/ ()) -> return ()
  , _backend_routeEncoder = fullRouteEncoder
  }

mainBackend :: IO ()
mainBackend = do
  runBackend backend frontend
