module Main exposing (main)

import Browser
import Browser.Events
import Html exposing (..)
import Html.Attributes as HA exposing (..)
import Html.Events as HE
import Svg
import Svg.Attributes as SA



-- To edit SVG:
--
-- https://yqnn.github.io/svg-path-editor/
-- https://svg-path-visualizer.netlify.app/#M%20-4%207%20L%200%207%20M%20-4%208%20L%200%208%20M%200%207%20C%208%207%202%200%2010%200%20M%2010%206%20C%204%206%204%201%2010%201%20M%200%200%20C%208%200%202%207%2010%207%20M%205%209%20C%202%209%202%208%200%208%20M%205%209%20C%208%209%208%208%2010%208
-- https://www.joshwcomeau.com/svg/interactive-guide-to-paths/
--


path01 =
    -- https://yqnn.github.io/svg-path-editor/
    -- "M 6 13 L 13 13 C 19 13 15 4 22 4 L 29 4 C 31 4 31 6 29 6 L 22 6 C 17 6 17 13 22 13 L 29 13 C 31 13 31 15 29 15 L 6 15 C 4 15 4 13 6 13"
    -- "M 6 13 L 13 13 C 19 13 15 4 22 4 L 29 4 C 30.5 4 30.5 6 29 6 L 22 6 C 17 6 17 13 22 13 L 29 13 C 30.5 13 30.5 15 29 15 L 6 15 C 4.5 15 4.5 13 6 13 M 22 6 L 10 6 C 5.5 6 5 5.5 5 1 C 5 -0.5 7 -0.5 7 1 C 7 4 7 4 13 4 L 22 4 M 17.5 12 C 17.5 8 17 4 23 4 M 22 6 C 18 6 17.5 9 17.5 12"
    "M 6 15 L 13 15 C 20 15 15 6 22 6 L 29 6 C 30.5 6 30.5 8 29 8 L 22 8 C 16 8 16 15 22 15 L 29 15 C 30.5 15 30.5 17 29 17 L 6 17 C 4.5 17 4.5 15 6 15 Z M 29 8 L 10 8 C 5.5 8 5 7.5 5 3 C 5 1.5 7 1.5 7 3 C 7 6 7 6 13 6 L 29 6 C 30.5 6 30.5 8 29 8 Z"
        |> String.split " "
        |> List.map
            (\item ->
                case String.toFloat item of
                    Just float ->
                        String.fromFloat (float * 28)

                    Nothing ->
                        item
            )
        |> String.join " "


type alias Model =
    { count : Float
    , state : State
    , animations : List Animation
    , speed : Float
    , debugMode : DebugMode
    , isTrackVisible : Bool
    }


type DebugMode
    = ShowAllArrows
    | ShowOneArrow
    | Disabled


type State
    = Play
    | Pause


addArrows speed anim =
    let
        distance =
            speed / 2.2

        widthBox =
            toFloat (widthText (.text (.argsFixed (objectToHtml anim.object))))

        ff =
            speed - ((widthHtml - widthBox) / 10)
    in
    [ { start = anim.start - (ff + distance), end = anim.end - (ff + distance), path = anim.path, object = Arrow }
    , { start = anim.start - ff, end = anim.end - ff, path = anim.path, object = Arrow }
    , anim
    ]


widthHtml =
    toFloat (widthText "Html")


init : () -> ( Model, Cmd msg )
init _ =
    let
        speed =
            7
    in
    ( { count = 0
      , state = Play
      , speed = speed
      , debugMode = Disabled
      , animations = animation1 speed
      , isTrackVisible = False
      }
    , Cmd.none
    )


animation1 speed =
    let
        start =
            16

        lengthDomToRuntime =
            pathDomToRuntime.to - pathDomToRuntime.from

        lengthRuntimeToUpdate =
            pathRuntimeToUpdate.to - pathRuntimeToUpdate.from

        lengthUpdateToView =
            pathUpdateToView.to - pathUpdateToView.from

        lengthViewToDom =
            pathViewToDom.to - pathViewToDom.from

        f1 =
            start + lengthDomToRuntime * speed

        f2 =
            f1 + lengthRuntimeToUpdate * speed

        f3 =
            f2 + lengthUpdateToView * speed

        f4 =
            f3 + lengthViewToDom * speed
    in
    []
        ++ addArrows speed
            { start = start
            , end = f1
            , path = pathDomToRuntime
            , object = BoxEvent
            }
        ++ addArrows speed
            { start = f1
            , end = f2
            , path = pathRuntimeToUpdate
            , object = BoxModel
            }
        ++ [ { start = f1 + (speed * 1.5)
             , end = f2 + (speed * 1.5)
             , path = pathRuntimeToUpdate
             , object = BoxMsg
             }
           ]
        ++ addArrows speed
            { start = f2
            , end = f3
            , path = pathUpdateToView
            , object = BoxModelNew
            }
        ++ addArrows speed
            { start = f3
            , end = f4
            , path = pathViewToDom
            , object = BoxHtml
            }


type Msg
    = ChangeState State
    | ChangeSpeed String
    | Init
    | ToggleDebugMode
    | OnAnimationFrame Float
    | ChangeSlider String
    | ToggleTrackVisibility


increment =
    1


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        ChangeState state ->
            ( { model | state = state }, Cmd.none )

        ChangeSlider string ->
            case String.toFloat string of
                Just float ->
                    ( { model | count = float }, Cmd.none )

                Nothing ->
                    ( model, Cmd.none )

        ChangeSpeed string ->
            case String.toFloat string of
                Just float ->
                    ( { model | speed = float }, Cmd.none )

                Nothing ->
                    ( model, Cmd.none )

        ToggleDebugMode ->
            ( { model
                | debugMode =
                    case model.debugMode of
                        ShowAllArrows ->
                            ShowOneArrow

                        ShowOneArrow ->
                            Disabled

                        Disabled ->
                            ShowAllArrows
              }
            , Cmd.none
            )

        Init ->
            ( { model | animations = animation1 model.speed, count = 0 }, Cmd.none )

        OnAnimationFrame _ ->
            ( { model | count = model.count + increment }, Cmd.none )

        ToggleTrackVisibility ->
            ( { model | isTrackVisible = not model.isTrackVisible }, Cmd.none )


arrow_ : { count : Float, index : Float, opacity : Float } -> Html msg
arrow_ args =
    arrow
        { text = ""
        , textTip = Nothing
        , colorBackground = ""
        , colorForeground = ""
        }
        { percentage =
            let
                newCount =
                    args.count + args.index
            in
            if newCount >= 100 then
                newCount - 100

            else
                newCount
        , opacity = args.opacity
        }


type alias Path =
    { from : Float, to : Float }


pathDomToRuntime : Path
pathDomToRuntime =
    { from = 0, to = 8 }


pathRuntimeToUpdate : Path
pathRuntimeToUpdate =
    { from = 8, to = 20.4 }


pathUpdateToView : Path
pathUpdateToView =
    { from = 20.4, to = 40.9 }


pathViewToDom : Path
pathViewToDom =
    { from = 40.9, to = 59 }


type alias Animation =
    { start : Float
    , end : Float
    , path : Path
    , object : Object
    }


fadeIn =
    8


fadeOut =
    8


view : Model -> Html Msg
view model =
    div []
        [ viewMain model
        , viewExtra model
        ]


arrowLong : { length : Float, percentage : Float } -> Html msg
arrowLong args =
    Svg.svg
        [ SA.width (String.fromFloat (args.length * 2.14) ++ "px")
        , SA.class "animated-box"
        , HA.style "offset-distance" (String.fromFloat args.percentage ++ "%")
        , HA.style "position" "absolute"
        , SA.viewBox <|
            String.join " "
                (List.map String.fromFloat
                    [ 0 - args.length + 5
                    , 0
                    , args.length + 5
                    , 10
                    ]
                )
        , SA.fill "#eee"
        ]
        [ Svg.path [ SA.d <| arrowHead ++ " " ++ arrowExtra args.length ] [] ]


arrowHead : String
arrowHead =
    "M 0 0 L 5 5 L 0 10 L 5 10 L 10 5 L 5 0 Z"


arrowExtra : Float -> String
arrowExtra size =
    -- "M 5 5 L 3 7 H -" ++ String.fromInt (size - 5) ++ " V 3 H 3"
    "M 5 5 L 4 6 H -" ++ String.fromFloat (size - 5) ++ " V 4 H 4"


positionsArrow =
    -- Note: use
    --
    -- ++ [ arrowLong { length = 120, deg = 0, percentage = model.count / 10 } ]
    --
    -- to find these numbers
    [ 3.38, 15.9, 24.9, 36.4, 45.4, 54.37, 72.3, 85.4 ]


positionsArrowShort =
    [ 78.7, 81.5 ]


viewMain model =
    div
        [ HA.style "height" "640px"
        , HA.style "width" "1000px"
        , HA.style "border" "1px solid red"
        ]
        ([]
            ++ List.map (\percentage -> arrowLong { length = 120, percentage = percentage }) positionsArrow
            ++ List.map (\percentage -> arrowLong { length = 40, percentage = percentage }) positionsArrowShort
            -- ++ [ arrowLong { length = 40, percentage = model.count / 10 } ]
            ++ (if model.isTrackVisible then
                    [ Svg.svg
                        [ SA.width "1200"
                        , SA.height "500"
                        , style "position" "absolute"
                        ]
                        [ Svg.path
                            [ SA.d path01
                            , SA.fill "transparent"
                            , SA.stroke "rgba(0,0,0,0.3)"
                            , SA.strokeWidth "1"
                            , SA.strokeDasharray "0"
                            ]
                            []
                        ]
                    ]

                else
                    []
               )
            ++ (case model.debugMode of
                    Disabled ->
                        []

                    ShowAllArrows ->
                        List.map (\index -> arrow_ { count = model.count / 10, index = toFloat index / 2, opacity = 1 }) (List.range 0 200)

                    ShowOneArrow ->
                        [ arrow_ { count = model.count / 10, index = 0, opacity = 1 } ]
               )
            ++ List.filterMap
                (\anim ->
                    if anim.start < model.count && model.count < anim.end then
                        let
                            position : Float
                            position =
                                model.count - anim.start

                            animLength : Float
                            animLength =
                                anim.end - anim.start

                            temp : Float
                            temp =
                                position / animLength

                            percentageRelative : Float
                            percentageRelative =
                                temp * 100

                            pathLength : Float
                            pathLength =
                                anim.path.to - anim.path.from

                            percentageAbsolute : Float
                            percentageAbsolute =
                                (temp * pathLength) + anim.path.from

                            opacity : Float
                            opacity =
                                if percentageRelative < fadeIn then
                                    percentageRelative / fadeIn

                                else if percentageRelative > (100 - fadeOut) then
                                    (100 - percentageRelative) / fadeOut

                                else
                                    1
                        in
                        Just <|
                            let
                                html =
                                    objectToHtml anim.object
                            in
                            html.element html.argsFixed
                                { percentage = percentageAbsolute
                                , opacity = opacity
                                }

                    else
                        -- Animation not started yet
                        Nothing
                )
                model.animations
            ++ [ div
                    [ style "position" "absolute"
                    , style "width" "100px"
                    , style "height" "400px"
                    , style "background-color" "rgba(18, 147, 216, 0.3)"
                    , style "color" "rgba(18, 147, 216, 1)"
                    , style "font-size" "20px"
                    , style "text-align" "center"
                    , style "padding" "20px 10px"
                    , style "border-radius" "10px"
                    , style "left" "440px"
                    , style "top" "95px"
                    ]
                    [ text "Elm Runtime"
                    ]
               ]
        )


viewExtra model =
    div []
        ([]
            ++ [ node "style" [] [ text css ]
               , input
                    [ type_ "range"
                    , HA.min "0"
                    , HA.max "999"
                    , style "width" "100%"
                    , value (String.fromFloat model.count)
                    , step (String.fromFloat increment)
                    , HE.onInput ChangeSlider
                    ]
                    []
               , case model.state of
                    Play ->
                        button [ HE.onClick (ChangeState Pause) ] [ text "Pause" ]

                    Pause ->
                        button [ HE.onClick (ChangeState Play) ] [ text "Play" ]
               , button [ HE.onClick ToggleDebugMode ] [ text "Toggle All Arrows" ]
               , button [ HE.onClick Init ] [ text "Init" ]
               , button [ HE.onClick ToggleTrackVisibility ] [ text "Toggle Track" ]
               , input
                    [ type_ "range"
                    , HA.min "0"
                    , HA.max "20"
                    , style "width" "100%"
                    , value (String.fromFloat model.speed)
                    , step "0.1"
                    , HE.onInput ChangeSpeed
                    ]
                    []
               ]
            ++ [ div [] [ text <| String.fromFloat model.speed ] ]
            ++ [ div [] [ text <| String.fromFloat (model.count / 10) ++ "%" ] ]
        )


type Object
    = BoxMsg
    | BoxEvent
    | BoxHtml
    | BoxModel
    | BoxModelNew
    | Arrow


objectToHtml : Object -> { argsFixed : ObjectDataFixed, element : ObjectDataFixed -> ObjectDataVariable -> Html msg }
objectToHtml object =
    case object of
        BoxMsg ->
            { argsFixed =
                { colorBackground = "green"
                , colorForeground = "white"
                , text = "Msg"
                , textTip = Nothing
                }
            , element = box
            }

        BoxEvent ->
            { argsFixed =
                { colorBackground = "rgb(255,220,0)"
                , colorForeground = "black"
                , text = "Event"
                , textTip = Nothing
                }
            , element = box
            }

        BoxHtml ->
            { argsFixed =
                { colorBackground = "rgb(255,220,0)"
                , colorForeground = "black"
                , text = "Html"
                , textTip = Nothing
                }
            , element = box
            }

        BoxModel ->
            { argsFixed =
                { colorBackground = "rgb(18, 147, 216)"
                , colorForeground = "white"
                , text = "Model"
                , textTip = Nothing
                }
            , element = box
            }

        BoxModelNew ->
            { argsFixed =
                { colorBackground = "rgb(18, 147, 216)"
                , colorForeground = "white"
                , text = "Model"
                , textTip = Just "New"
                }
            , element = box
            }

        Arrow ->
            { argsFixed =
                { colorBackground = ""
                , colorForeground = ""
                , text = ""
                , textTip = Nothing
                }
            , element = arrow
            }


type alias ObjectDataVariable =
    { percentage : Float
    , opacity : Float
    }


type alias ObjectDataFixed =
    { text : String
    , textTip : Maybe String
    , colorBackground : String
    , colorForeground : String
    }


widthText text =
    String.length text * 10 + 16


box : ObjectDataFixed -> ObjectDataVariable -> Html msg
box argsFixed args =
    div
        [ HA.class "animated-box"
        , style "height" "20px"
        , style "width" (String.fromInt (widthText argsFixed.text) ++ "px")
        , style "padding" "4px 0 0 0"
        , style "border-radius" "8px"
        , style "text-align" "center"
        , style "opacity" (String.fromFloat args.opacity)
        , style "background-color" argsFixed.colorBackground
        , style "color" argsFixed.colorForeground
        , style "offset-distance" (String.fromFloat args.percentage ++ "%")
        , style "offset-rotate" "0deg"
        , style "position" "absolute"
        ]
        ([]
            ++ (case argsFixed.textTip of
                    Just textTip ->
                        [ div
                            [ style "position" "absolute"
                            , style "background-color" "red"
                            , style "color" "white"
                            , style "padding" "3px 0 0 0"
                            , style "height" "16px"
                            , style "width" (String.fromInt (widthText textTip - 6) ++ "px")
                            , style "border-radius" "30px"
                            , style "transform" "rotate(20deg)"
                            , style "top" "-12px"
                            , style "right" "-12px"
                            , style "font-size" "12px"
                            ]
                            [ text textTip ]
                        ]

                    Nothing ->
                        []
               )
            ++ [ text argsFixed.text ]
        )


arrow : ObjectDataFixed -> ObjectDataVariable -> Html msg
arrow argsFixed args =
    Svg.svg
        [ SA.viewBox "0 0 10 10"
        , SA.class "animated-box"
        , SA.width "20px"
        , SA.height "20px"
        , SA.fill "#ddd"
        , style "opacity" (String.fromFloat args.opacity)
        , style "offset-distance" (String.fromFloat args.percentage ++ "%")
        , style "position" "absolute"
        ]
        [ Svg.path [ SA.d arrowHead ] [] ]


arrow2 count =
    Svg.svg
        [ SA.viewBox "0 0 20 18"
        , SA.class "animated-box"
        , SA.width "60px"
        , SA.height "40px"
        , style "offset-distance" (String.fromFloat count ++ "%")
        , style "position" "absolute"
        ]
        [ Svg.path [ SA.d "M 10 5 H 0 V 13 H 10 V 18 L 20 9 L 10 0 V 5 Z" ] [] ]


filterMapAnimations : List Animation -> Float -> List Animation
filterMapAnimations animations count =
    List.filterMap
        (\anim ->
            if count < anim.end then
                Just anim

            else
                Nothing
        )
        animations


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions =
            \model ->
                if List.isEmpty (filterMapAnimations model.animations model.count) then
                    Sub.none

                else
                    case model.state of
                        Play ->
                            Browser.Events.onAnimationFrameDelta OnAnimationFrame

                        Pause ->
                            Sub.none
        }


css =
    """
body { font-family: monospace }

body2 {
    display: flex;
    justify-content: center;
    align-items: center;
    height: 100vh;
    margin: 0;
    background-color: #f0f4f8;
}


.animated-box {
    offset-path: path(\"""" ++ path01 ++ """");
    /* offset-rotate: auto; */
}

"""
