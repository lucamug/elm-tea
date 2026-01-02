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
-- M 0 7 C 9 6 1 1 10 0 M 10 6 C 4 7 4 0 10 1 M 0 0 C 9 1 1 6 10 7 M 10 8 C 7 9 3 9 0 8
-- M -4 7 L 0 7 M -4 8 L 0 8 M 0 7 C 8 7 2 0 10 0 M 10 6 C 4 6 4 1 10 1 M 0 0 C 8 0 2 7 10 7 M 5 9 C 2 9 2 8 0 8 M 5 9 C 8 9 8 8 10 8


type alias Model =
    { count : Float
    , state : State
    , animations : List Animation
    }


type State
    = Play
    | Pause


addArrows distance anim =
    [ { start = anim.start - (distance + 6), end = anim.end - (distance + 6), path = anim.path, object = Arrow }
    , { start = anim.start - distance, end = anim.end - distance, path = anim.path, object = Arrow }
    , anim
    ]


init : () -> ( Model, Cmd msg )
init _ =
    ( { count = 0
      , state = Play
      , animations =
            []
                ++ addArrows 15 { start = 21, end = 159, path = path1a, object = BoxEvent }
                ++ addArrows 12 { start = 159, end = 320, path = path1b, object = BoxMsg }
                ++ addArrows 17 { start = 22, end = 322, path = path2, object = BoxModel }
      }
    , Cmd.none
    )


type Msg
    = ChangeState State
    | OnAnimationFrame Float
    | ChangeSlider String


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

        OnAnimationFrame _ ->
            ( { model
                | count = model.count + increment

                -- , animations =
                --     List.filterMap
                --         (\anim ->
                --             if anim.end <= model.count + increment then
                --                 Nothing
                --             else
                --                 Just anim
                --         )
                --         model.animations
              }
            , Cmd.none
            )


track01 : String
track01 =
    "M 50 450 C 74 123 229 347 250 50"



-- type SvgStuff
--     = Move ( Int, Int )
--     | Line ( Int, Int )
--     | Cubic ( Int, Int ) ( Int, Int ) ( Int, Int )
-- path01 =
--     [ Move ( 0, 7 )
--     , Line ( 5, 7 )
--     , Cubic ( 14, 7 ) ( 6, 0 ) ( 15, 0 )
--     , Line ( 20, 0 )
--     ]
-- M 0 7
-- L 5 7
-- C 14 7 6 0 15 0
-- L 20 0


track02 =
    """
M -4 7 L 0 7 
M -4 8 L 0 8 
M 0 7 C 8 7 2 0 10 0 
M 10 6 C 4 6 4 1 10 1 
M 0 0 C 8 0 2 7 10 7 
M 5 9 C 2 9 2 8 0 8 
M 5 9 C 8 9 8 8 10 8 
M 12 12 Q 13 10 14 12
"""



-- PATH 1
-- M 6 13 L 13 13 C 19 13 15 4 22 4 L 29 4 C 31 4 31 6 29 6 L 22 6 C 17 6 17 13 22 13 L 29 13 C 31 13 31 15 29 15 L 6 15 C 4 15 4 13 6 13
-- PATH 2
-- M 16 12 C 16 9 17 4 22 4 L 29 4 C 31 4 31 6 29 6 L 22 6 C 18 6 18 7 18 11 C 18 13 16 13 16 11
-- "M 10 5 H 0 V 13 H 10 V 18 L 20 9 L 10 0 V 5 Z"
-- <svg xmlns="http://www.w3.org/2000/svg" width="20" height="18"><path d="M10 5H0v8h10v5l10-9-10-9v5z"/></svg>
-- <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 18"><path d="M10 5H0v8h10v5l10-9-10-9v5z"/></svg>


arrow_ : Float -> Float -> Float -> Html msg
arrow_ count index opacity =
    arrow
        { text = ""
        , colorBackground = "red"
        , colorForeground = "white"
        }
        { percentage =
            let
                newCount =
                    count + index
            in
            if newCount >= 100 then
                newCount - 100

            else
                newCount
        , opacity = opacity
        }


path01 =
    -- "M 6 13 L 13 13 C 19 13 15 4 22 4 L 29 4 C 31 4 31 6 29 6 L 22 6 C 17 6 17 13 22 13 L 29 13 C 31 13 31 15 29 15 L 6 15 C 4 15 4 13 6 13"
    "M 6 13 L 13 13 C 19 13 15 4 22 4 L 29 4 C 30.5 4 30.5 6 29 6 L 22 6 C 17 6 17 13 22 13 L 29 13 C 30.5 13 30.5 15 29 15 L 6 15 C 4.5 15 4.5 13 6 13 M 22 6 L 10 6 C 5.5 6 5 5.5 5 1 C 5 -0.5 7 -0.5 7 1 C 7 4 7 4 13 4 L 22 4 M 17.5 12 C 17.5 8 17 4 23 4 M 22 6 C 18 6 17.5 9 17.5 12"
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


type alias Path =
    { from : Float, to : Float }


path1 : Path
path1 =
    { from = 0, to = 18.9 }


path1a : Path
path1a =
    { from = 0, to = 8.8 }


path1b : Path
path1b =
    { from = 9.0, to = 18.9 }


path2 : Path
path2 =
    { from = 21.2, to = 38.4 }


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
        ([ div
            [ HA.style "height" "500px"
            , HA.style "border" "1px solid red"
            , HA.style "position" "relative"
            ]
            ([]
                ++ [ Svg.svg
                        [ SA.width "1200"
                        , SA.height "500"
                        , style "position" "absolute"
                        ]
                        [ Svg.path
                            [ SA.d path01
                            , SA.fill "transparent"
                            , SA.stroke "rgba(0,0,0,0)"
                            , SA.strokeWidth "1"

                            -- , SA.strokeDasharray "6"
                            ]
                            []
                        ]
                   ]
                ++ List.map (\index -> arrow_ (model.count / 10) (toFloat index) 1) (List.range 0 0)
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
                                objectToHtml anim.object
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
                        , style "height" "200px"
                        , style "background-color" "rgba(18, 147, 216, 0.3)"
                        , style "color" "rgba(18, 147, 216, 1)"
                        , style "font-size" "20px"
                        , style "text-align" "center"
                        , style "padding" "80px 10px"
                        , style "border-radius" "10px"
                        , style "left" "430px"
                        , style "top" "100px"
                        ]
                        [ text "Elm Runtime"
                        ]
                   ]
            )
         ]
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
               ]
            ++ [ div [] [ text <| String.fromFloat model.count ] ]
        )


type Object
    = BoxMsg
    | BoxEvent
    | BoxModel
    | Arrow


objectToHtml object =
    case object of
        BoxMsg ->
            box
                { colorBackground = "green"
                , colorForeground = "white"
                , text = "Msg"
                }

        BoxEvent ->
            box
                { colorBackground = "rgb(255,220,0)"
                , colorForeground = "black"
                , text = "Event"
                }

        BoxModel ->
            box
                { colorBackground = "rgb(18, 147, 216)"
                , colorForeground = "white"
                , text = "Model"
                }

        Arrow ->
            arrow
                { colorBackground = ""
                , colorForeground = ""
                , text = ""
                }


type alias ObjectData =
    { percentage : Float
    , opacity : Float
    }


type alias ObjectDataFixed =
    { text : String
    , colorBackground : String
    , colorForeground : String
    }


box : ObjectDataFixed -> ObjectData -> Html msg
box argsFixed args =
    div
        [ HA.class "animated-box"
        , style "height" "20px"
        , style "width" (String.fromInt (String.length argsFixed.text * 10 + 8) ++ "px")
        , style "padding" "4px 0 0 0"
        , style "border-radius" "8px"
        , style "text-align" "center"
        , style "opacity" (String.fromFloat args.opacity)
        , style "background-color" argsFixed.colorBackground
        , style "color" argsFixed.colorForeground
        , style "offset-distance" (String.fromFloat args.percentage ++ "%")

        -- , style "offset-rotate" "0deg"
        , style "position" "absolute"
        ]
        [ text argsFixed.text ]


arrow : ObjectDataFixed -> ObjectData -> Html msg
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
        [ Svg.path [ SA.d "M 0 0 L 5 5 L 0 10 L 5 10 L 10 5 L 5 0 Z" ] [] ]


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
