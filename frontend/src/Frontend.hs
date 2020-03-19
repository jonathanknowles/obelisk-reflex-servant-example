{-# LANGUAGE KindSignatures #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE RankNTypes #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE NoMonomorphismRestriction #-}
{-# LANGUAGE OverloadedStrings #-}

module Frontend where

import qualified Data.Text as T
import Obelisk.Frontend
import Obelisk.Route
import Reflex.Dom.Core

import Common.Api
import Common.Route
import Obelisk.Generated.Static

import Data.Proxy
import Servant.API ((:<|>)(..))
import Servant.Reflex (BaseUrl(..), SupportsServantReflex, ReqResult, client, reqSuccess)


getAdd  :: forall t m. (SupportsServantReflex t m) => Dynamic t (Either T.Text Integer) -> Dynamic t (Either T.Text Integer) -> Event t () -> m (Event t (ReqResult () Integer))
getSub  :: forall t m. (SupportsServantReflex t m) => Dynamic t (Either T.Text Integer) -> Dynamic t (Either T.Text Integer) -> Event t () -> m (Event t (ReqResult () Integer))
getEcho :: forall t m. (SupportsServantReflex t m) => Event t () -> m (Event t (ReqResult () T.Text))
(getAdd :<|> getSub :<|> getEcho) = client api (Proxy :: Proxy (m :: * -> *)) (Proxy :: Proxy ()) (constDyn (BasePath "/"))

comp :: forall t m. (SupportsServantReflex t m, DomBuilder t m, PostBuild t m, MonadHold t m) => m ()
comp = do
  (e,_) <- el' "button" $ text "echo"
  r' <- getEcho $ domEvent Click e
  dynText =<< holdDyn "Waiting" (T.pack . show . reqSuccess <$> r')
  return ()

frontend :: Frontend (R FrontendRoute)
frontend = Frontend
  { _frontend_head = el "title" $ text "Obelisk Small Example"
  , _frontend_body = do
      text "Welcome to Obelisk!"
      el "p" $ text $ T.pack commonStuff
      elAttr "img" ("src" =: static @"obelisk.jpg") blank
      prerender_ blank comp
  }
