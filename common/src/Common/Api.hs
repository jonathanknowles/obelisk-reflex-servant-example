{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

module Common.Api where
import Data.Text
import Servant.API ((:>), (:<|>) (..), Capture, Get, JSON)

commonStuff :: String
commonStuff =
  "Here is a string defined in code common to the frontend and backend."

type Api = "api" :> (Add :<|> Sub :<|> Echo)

type Add =
  "add" :> Capture "x" Integer :> Capture "y" Integer :> Get '[JSON] Integer

type Sub =
  "sub" :> Capture "x" Integer :> Capture "y" Integer :> Get '[JSON] Integer

type Echo = "echo" :> Get '[JSON] Text
