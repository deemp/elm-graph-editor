port module Main exposing (..)

import Browser
import Html exposing (Html, text)
import Graph exposing(..)
import Graph.DOT exposing(..)
import Json.Decode as D
import Json.Encode as E

-- MAIN



main : Program Int Model Msg
main =
  Browser.element
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }


-- PORTS

port insertEdge : (D.Value -> msg) -> Sub msg
port removeEdge : (D.Value -> msg) -> Sub msg

-- MODEL

type alias Model = { 
  currentTime : Int 
  
  }

init : Int -> ( Model, Cmd Msg )
init currentTime =
  ( { currentTime = currentTime }
  , Cmd.none
  )


-- UPDATE

type Msg 
  = Insert D.Value
  | Remove D.Value

update : Msg -> Model -> ( Model, Cmd Msg )
update _ model =
  ( model, Cmd.none )


-- VIEW

view : Model -> Html Msg
view model =
  text (String.fromInt model.currentTime)


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions _ =
  Sub.none


{-
page:
Add edge:
Label 1: []
Label 2: []
Type: []
-}