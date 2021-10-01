port module Main exposing (..)

import Browser
import Dict exposing (..)
import Graph exposing (..)
import Graph.DOT exposing (..)
import Html exposing (Html, div)
import Json.Decode as D
import Json.Decode.Pipeline exposing (required)
import Json.Encode as E



-- MAIN


main : Program () Model Msg
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

port updateGraph : String -> Cmd msg

-- MODEL


type alias Model =
    { labelId : Dict String Int
    , edges : Dict (List Int) String
    , nodeCounter : Int
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model Dict.empty Dict.empty 0
    , Cmd.none
    )



-- UPDATE


type Msg
    = Insert D.Value
    | Remove D.Value


type alias InsertEdge =
    { from : Label
    , to : Label
    , label : Label
    , edgeType : Label
    }


insertEdgeDecoder : D.Decoder InsertEdge
insertEdgeDecoder =
    D.succeed InsertEdge
        |> required "from" D.string
        |> required "to" D.string
        |> required "label" D.string
        |> required "type" D.string


type alias RemoveEdge =
    { from : Label
    , to : Label
    }


type alias Increment =
    Int


{-| Insert a node with label and return its id-}
addNode : Label -> Model -> ( Model, NodeId )
addNode label model =
    case Dict.get label model.labelId of
        Just id ->
            ( model, id )

        Nothing ->
            ( { model
                | labelId = Dict.insert label model.nodeCounter model.labelId
                , nodeCounter = model.nodeCounter + 1
              }
            , model.nodeCounter
            )


type alias Label =
    String


addEdge : NodeId -> NodeId -> Label -> Model -> Model
addEdge v1 v2 label model =
    { model | edges = Dict.insert [ v1, v2 ] label model.edges }


insertEdgeHandler : D.Value -> Model -> ( Model, Cmd Msg )
insertEdgeHandler value model =
    case D.decodeValue insertEdgeDecoder value of
        Ok e ->
            let
                ( m1, fromId ) =
                    addNode e.from model

                ( m2, toId ) =
                    addNode e.to m1

                m3 =
                    addEdge fromId toId e.label m2
            in
            ( m3, Cmd.none )

        Err _ ->
            ( model, Cmd.none )


removeEdgeDecoder : D.Decoder RemoveEdge
removeEdgeDecoder =
    D.succeed RemoveEdge
        |> required "from" D.string
        |> required "to" D.string



removeEdgeHandler : D.Value -> Model -> ( Model, Cmd Msg )
removeEdgeHandler value model =
    case D.decodeValue removeEdgeDecoder value of
        Ok e ->
            let
                fromId =
                    Dict.get e.from model.labelId

                toId =
                    Dict.get e.to model.labelId

                makeInt x =
                    case x of
                        Nothing ->
                            -1

                        Just id ->
                            id

                p =
                    List.map makeInt [ fromId, toId ]
                newModel = { model | edges = Dict.remove p model.edges }
            in
            ( newModel, updateGraph "newModel")

        Err _ ->
            ( model, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Insert edge ->
            insertEdgeHandler edge model

        Remove edge ->
            removeEdgeHandler edge model



-- VIEW


view : Model -> Html Msg
view _ =
    div [] []



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch [ insertEdge Insert, removeEdge Remove ]



{-
   page:
   Add edge:
   Label 1: []
   Label 2: []
   Type: []
-}
