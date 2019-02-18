{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

module Common.Api where

import Servant (JSON)
import Servant.API ((:>), (:<|>) (..), Capture, Get)

commonStuff :: String
commonStuff =
  "Here is a string defined in code common to the frontend and backend."

type Api = Add :<|> Sub

type Add =
  "add" :> Capture "x" Integer :> Capture "y" Integer :> Get '[JSON] Integer

type Sub =
  "sub" :> Capture "x" Integer :> Capture "y" Integer :> Get '[JSON] Integer
