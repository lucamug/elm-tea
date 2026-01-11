module Main exposing (main)

import Browser
import Browser.Events
import Html exposing (..)
import Html.Attributes as HA
import Html.Events as HE
import Svg
import Svg.Attributes as SA



-- To edit SVG:
--
-- https://yqnn.github.io/svg-path-editor/
-- https://svg-path-visualizer.netlify.app/#M%20-4%207%20L%200%207%20M%20-4%208%20L%200%208%20M%200%207%20C%208%207%202%200%2010%200%20M%2010%206%20C%204%206%204%201%2010%201%20M%200%200%20C%208%200%202%207%2010%207%20M%205%209%20C%202%209%202%208%200%208%20M%205%209%20C%208%209%208%208%2010%208
-- https://www.joshwcomeau.com/svg/interactive-guide-to-paths/
--
-- Path goes from 0% to 100% where 100% == 0%. This is used by "offset-path" to position an item along the path.
-- Every 16 ms (60 fps) the counter get increase by 1.
-- That would take 100 frames to finish the circuit = 100/60 = 1.6667 seconds.
-- By default this is dived by 10, making it 16.667 seconds.


p =
    -- Note: use
    --
    -- ++ [ arrowLong { length = 120, deg = 0, percentage = model.count / 10 } ]
    --
    -- to find these numbers
    --
    { pointStart = 0
    , pointAfterStart = 1.7
    , pointRuntime = 9
    , pointUpdate = 20.72
    , pointRuntimeSecondPass = 31
    , pointView = 41.05
    , pointDom = 58.8
    , pointEffectsStart = 60
    , pointUpdate2 = 78.8
    , pointEffects = 97.2
    , pointEffectsEnd = 99.9
    , svgMainPath = "M 6 15 H 13 C 22 15 13 6 22 6 H 29 C 30.5 6 30.5 8 29 8 H 22 C 16 8 16 15 22 15 H 29 C 30.5 15 30.5 17 29 17 H 6 C 4.5 17 4.5 15 6 15 M 5 3 V 4 C 5 6 6 6 7 6 H 29 C 30.5 6 30.5 8 29 8 H 7 C 4 8 3 7 3 4 V 3"
    , svgArrowHead = "M 0 0 L 5 5 L 0 10 L 5 10 L 10 5 L 5 0 Z"
    , svgArrowExtra = "M 5 5 L 4 6 H -{{size}} V 4 H 4"
    , svgPointer = "M 0 0 L 4 12 L 1 11 L 1 15 L -1 15 L -1 11 L -4 12 Z"
    , svgOuterButton = "M 5 0 C 9 0 10 1 10 5 C 10 9 9 10 5 10 C 1 10 0 9 0 5 C 0 1 1 0 5 0"
    , svgInnerPlay = "M 8 5 L 3 2 L 3 8"
    , svgInnerPause = "M 4.5 2.5 L 2.5 2.5 L 2.5 7.5 L 4.5 7.5 M 7.5 2.5 L 5.5 2.5 L 5.5 7.5 L 7.5 7.5"
    , svgInnerStop = "M 7 3 L 3 3 L 3 7 L 7 7"
    , svgInnerDarkMode = "M 6 2 A 3.2 3.2 0 1 0 8 7 A 2 2 0 1 1 6 2"
    , svgInnerPath = "M 7 3 h -3 c -1 0 -1 0 -1 -1 h -1 c 0 1 0 2 1 2 c 2 0 2 2 0 2 c -1 0 -1 1 0 1 h 4 c 1 0 1 -1 0 -1 c -2 0 -2 -2 0 -2 c 1 0 1 -1 0 -1"
    , svgInnerArrows = "M 2 4 l 1 1 l -1 1 l 0 1 l 2 -2 l -2 -2 M 3 3 l 2 2 l -2 2 l 1 0 l 2 -2 l -2 -2 M 5 3 l 2 2 l -2 2 l 1 0 l 2 -2 l -2 -2 M 7 3 l 1 1 l 0 -1 M 8 6 l -1 1 l 1 0"
    , svgInnerSettings = "M 7 6 a 0.5 0.5 1 1 0 0 2 a 0.5 0.5 1 1 0 0 -2 M 4 5 l 2 3 a 1 1 1 1 0 2 -2 l -3 -2 c 1 -2 -1 -3 -2 -2 l 1 1 l 0 1 l -1 0 l -1 -1 c -1 1 0 3 2 2"
    , svgInnerReplay = "M 3 5 l -1 0 a 3 3 1 0 0 3 3 a 0.5 0.5 1 1 0 0 -6 m 0 0 l 0 -1 l -2 1.5 l 2 1.5 l 0 -1 a 0.5 0.5 1 0 1 0 4 a 2 2 0 0 1 -2 -2"
    , sizeWidth = 980
    , sizeWidthElmRuntime = 160
    , sizeHeight = 540
    , positionsArrowLong = [ 3.12, 16.51, 25, 36.8, 45.3, 54.6, 65.3, 92.45 ]
    , positionsArrowShort = [ 60.25, 99.7 ]
    , defaultSpeed = 9
    , fadeIn = 8
    , fadeOut = 8
    , colorBackgroundGray = "rgba(200, 200, 200, 0.2)"
    , colorPrimaryBlue = "rgb(18, 147, 216)" -- "#078dd8"
    , colorArrows = "rgba(160,160,160,0.5)"
    , colorArrowsTest = "rgba(220, 0, 0, 0.3)"
    }


cssForSlider =
    """
:root {
  /* Configuration Variables */
  --slider-track-height:4px;
  --slider-track-bg: """ ++ p.colorArrows ++ """;
  --slider-thumb-size-height: 40px;
  --slider-thumb-size-width: 14px;
  --slider-thumb-bg: """ ++ p.colorPrimaryBlue ++ """;
  --slider-thumb-radius: 6px;
  --slider-border-radius: 4px;
}

/* General styling for the input element */
.slider {
  -webkit-appearance: none;
  appearance: none;
  width: 100%;
  background: transparent;
  margin: 5px;
  padding-bottom: 3px;
  cursor: pointer;
}

/* --- TRACK STYLES --- */
/* Webkit (Chrome, Safari, Edge) */
.slider::-webkit-slider-runnable-track {
  width: 100%;
  height: var(--slider-track-height);
  background: var(--slider-track-bg);
  border-radius: var(--slider-border-radius);
}

/* Firefox */
.slider::-moz-range-track {
  width: 100%;
  height: var(--slider-track-height);
  background: var(--slider-track-bg);
  border-radius: var(--slider-border-radius);
}

/* --- THUMB STYLES --- */
/* Webkit (Chrome, Safari, Edge) */
.slider::-webkit-slider-thumb {
  -webkit-appearance: none;
  appearance: none;
  height: var(--slider-thumb-size-height);
  width: var(--slider-thumb-size-width);
  background: var(--slider-thumb-bg);
  border-radius: var(--slider-thumb-radius);
  /* Centering formula: (track-height / 2) - (thumb-height / 2) */
  margin-top: calc((var(--slider-track-height) / 2) - (var(--slider-thumb-size-height) / 2));
}

/* Firefox */
.slider::-moz-range-thumb {
  height: var(--slider-thumb-size-height);
  width: var(--slider-thumb-size-width);
  background: var(--slider-thumb-bg);
  border-radius: var(--slider-thumb-radius);
  border: none; /* Firefox adds a default border */
}
"""


type alias Model =
    { count : Float
    , state : State
    , animations : List Animation
    , debugMode : DebugMode
    , isTrackVisible : Bool
    , isDarkMode : Bool
    , cachedMaxCount : Float
    }


type DebugMode
    = ShowAllArrows
    | ShowOneArrow
    | Disabled


type State
    = Play
    | Pause


type alias Animation =
    { start : Float
    , end : Float
    , path : PathSection
    , object : Object
    }


type alias PathSection =
    { from : Float, to : Float }


type alias Timeline =
    List Animation


type Msg
    = ChangeState State
    | Reset
    | Replay
    | AddTimeline Timeline
    | ToggleDebugMode
    | OnAnimationFrame Float
    | ChangeSlider String
    | ToggleTrackVisibility
    | ToggleDarkMode


viewButtonTemplate : String -> Html msg
viewButtonTemplate extra =
    Svg.svg
        [ SA.viewBox "0 0 10 10"
        , SA.width "40px"
        , SA.fill p.colorPrimaryBlue
        , HA.style "margin" "5px"
        ]
        [ Svg.path [ SA.d (p.svgOuterButton ++ " " ++ extra) ] []
        ]


svgMultiplier : Float -> String -> String
svgMultiplier multiplier svg =
    String.split " " svg
        |> List.map
            (\item ->
                case String.toFloat item of
                    Just float ->
                        String.fromFloat (float * multiplier)

                    Nothing ->
                        item
            )
        |> String.join " "


svgMainPath : String
svgMainPath =
    svgMultiplier 28 p.svgMainPath


addPrecedingArrows : Float -> Animation -> List Animation
addPrecedingArrows speed anim =
    let
        distanceBetweenArrows : Float
        distanceBetweenArrows =
            speed / 2.1

        widthBox : Float
        widthBox =
            toFloat (widthText (.text (.argsFixed (objectToHtml anim.object))))

        distanceBetweenBoxAndArrow : Float
        distanceBetweenBoxAndArrow =
            speed * (widthBox / 55)
    in
    [ { start = anim.start - (distanceBetweenBoxAndArrow + distanceBetweenArrows)
      , end = anim.end - (distanceBetweenBoxAndArrow + distanceBetweenArrows)
      , path = anim.path
      , object = Arrow
      }
    , { start = anim.start - distanceBetweenBoxAndArrow
      , end = anim.end - distanceBetweenBoxAndArrow
      , path = anim.path
      , object = Arrow
      }
    , anim
    ]


init : () -> ( Model, Cmd msg )
init _ =
    ( { count = 0
      , state = Play
      , debugMode = Disabled
      , animations = timeline2 0 p.defaultSpeed
      , isTrackVisible = False
      , isDarkMode = False
      , cachedMaxCount = 0
      }
        |> updateCachedMaxCount
    , Cmd.none
    )


updateCachedMaxCount : Model -> Model
updateCachedMaxCount model =
    model.animations
        |> List.foldl (\anim acc -> max acc anim.end) 0
        |> (\max -> { model | cachedMaxCount = max })


timeline1 : Float -> Float -> List Animation
timeline1 current speed =
    let
        pathStartToRuntime : PathSection
        pathStartToRuntime =
            { from = p.pointStart, to = p.pointRuntime }

        pathRuntimeToUpdate : PathSection
        pathRuntimeToUpdate =
            { from = p.pointRuntime, to = p.pointUpdate }

        pathUpdateToView : PathSection
        pathUpdateToView =
            { from = p.pointUpdate, to = p.pointView }

        pathViewToDom : PathSection
        pathViewToDom =
            { from = p.pointView, to = p.pointDom }

        startDelay : Float
        startDelay =
            7

        f0 : Float
        f0 =
            (p.pointAfterStart + startDelay * speed) + current

        f1 : Float
        f1 =
            f0 + (pathStartToRuntime.to - pathStartToRuntime.from) * speed

        f2 : Float
        f2 =
            f1 + (pathRuntimeToUpdate.to - pathRuntimeToUpdate.from) * speed

        f3 : Float
        f3 =
            f2 + (pathUpdateToView.to - pathUpdateToView.from) * speed

        f4 : Float
        f4 =
            f3 + (pathViewToDom.to - pathViewToDom.from) * speed
    in
    []
        ++ [ { start = (p.pointRuntimeSecondPass * speed) + f0, end = f4, path = { from = p.pointRuntimeSecondPass, to = p.pointRuntimeSecondPass }, object = TipNew } ]
        ++ addPrecedingArrows speed { start = f0, end = f1, path = pathStartToRuntime, object = BoxYellow "Event" }
        ++ addPrecedingArrows speed { start = f1, end = f2, path = pathRuntimeToUpdate, object = BoxAzzurro "Model" }
        ++ [ { start = f1 + (speed * 1.5), end = f2 + (speed * 1.5), path = pathRuntimeToUpdate, object = BoxGreen "Msg" } ]
        ++ addPrecedingArrows speed { start = f2, end = f3, path = pathUpdateToView, object = BoxModelNew }
        ++ addPrecedingArrows speed { start = f3, end = f4, path = pathViewToDom, object = BoxYellow "Html" }
        ++ [ { start = 0 + current, end = 10 * speed + current, path = { from = 0, to = 300 }, object = Pointer } ]


timeline2 : Float -> Float -> List Animation
timeline2 current speed =
    let
        pathUpdateToEffects : PathSection
        pathUpdateToEffects =
            { from = p.pointUpdate2, to = p.pointEffectsEnd }

        pathEffectsToUpdate : PathSection
        pathEffectsToUpdate =
            { from = p.pointEffectsStart, to = p.pointUpdate2 }

        f0 : Float
        f0 =
            (p.pointAfterStart * speed) + current

        f1 : Float
        f1 =
            f0 + (pathUpdateToEffects.to - pathUpdateToEffects.from) * speed

        delay =
            10

        f1WithDelay : Float
        f1WithDelay =
            f1 + (delay * speed)

        f2 : Float
        f2 =
            f1 + (pathEffectsToUpdate.to - pathEffectsToUpdate.from + delay) * speed
    in
    []
        ++ addPrecedingArrows speed { start = f0, end = f1, path = pathUpdateToEffects, object = BoxYellow "Cmd" }
        ++ addPrecedingArrows speed { start = f1WithDelay, end = f2, path = pathEffectsToUpdate, object = BoxYellow "Response" }


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        Replay ->
            ( { model | count = 0, state = Play }, Cmd.none )

        Reset ->
            ( { model | count = 0, animations = [], cachedMaxCount = 0 }, Cmd.none )

        ChangeState state ->
            ( { model | state = state }, Cmd.none )

        ChangeSlider string ->
            case String.toFloat string of
                Just float ->
                    ( { model | count = float, state = Pause }, Cmd.none )

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

        AddTimeline timeline ->
            ( { model | animations = model.animations ++ timeline } |> updateCachedMaxCount, Cmd.none )

        OnAnimationFrame _ ->
            ( { model | count = model.count + 1 }, Cmd.none )

        ToggleTrackVisibility ->
            ( { model | isTrackVisible = not model.isTrackVisible }, Cmd.none )

        ToggleDarkMode ->
            ( { model | isDarkMode = not model.isDarkMode }, Cmd.none )


arrow_ : { count : Float, index : Float, opacity : Float } -> Html msg
arrow_ args =
    viewArrow
        { text = ""
        , textTip = Nothing
        , colorBackground = p.colorArrowsTest
        , colorForeground = ""
        }
        { percentage =
            -- It makes debug arrow to work until 300%, then they will accumulate
            -- in one place
            let
                newCount : Float
                newCount =
                    args.count + args.index
            in
            if newCount >= 200 then
                newCount - 200

            else if newCount >= 100 then
                newCount - 100

            else
                newCount
        , opacity = args.opacity
        }


view : Model -> Html Msg
view model =
    div
        [ HA.style "background-color"
            (if model.isDarkMode then
                "rgb(3,3,3)"

             else
                "rgb(255,255,255)"
            )
        , HA.style "height" "100dvh"
        , HA.style "display" "flex"
        , HA.style "align-items" "center"
        , HA.style "justify-content" "center"
        , HA.style "flex-direction" "column"
        ]
        [ viewMain model
        , viewControls model
        ]


viewMain : Model -> Html msg
viewMain model =
    div
        [ HA.style "height" (String.fromInt p.sizeHeight ++ "px")
        , HA.style "width" (String.fromInt p.sizeWidth ++ "px")
        , HA.style "margin-bottom" "12px"
        , HA.style "position" "relative"
        , HA.style "font-family" "monospace"
        , HA.style "border" "1px solid red"
        ]
        ([]
            ++ [ viewAreaUnsafe ]
            ++ [ viewAreaSafe ]
            ++ [ viewElmRuntime ]
            ++ [ viewBoxBlue { text = "update", translateX = 20, percentage = p.pointUpdate } ]
            ++ [ viewBoxBlue { text = "view", translateX = 20, percentage = p.pointView } ]
            ++ [ viewBoxYellow { text = "DOM", translateX = -20, percentage = p.pointDom } ]
            ++ [ viewBoxYellow { text = "Effects", translateX = 10, percentage = p.pointEffects } ]
            ++ List.map (\percentage -> arrowLong { length = 105, percentage = percentage }) p.positionsArrowLong
            ++ List.map (\percentage -> arrowLong { length = 46, percentage = percentage }) p.positionsArrowShort
            ++ [ viewObject (BoxAzzurro "Model") { percentage = 31.1, opacity = 1 } ]
            ++ viewSvgTrack model
            ++ viewDebuggingArrows model
            ++ viewAnimations model
            ++ viewSvgTrack model
            ++ [ node "style" [] [ text (css ++ cssForSlider) ] ]
         -- ++ [ arrowLong { length = 105, percentage = model.count / 10 } ]
         -- ++ [ arrowLong { length = 52, percentage = model.count / 10 } ]
        )


css : String
css =
    String.replace "{{svgMainPath}}" svgMainPath ".offset-box {offset-path: path('{{svgMainPath}}')}"


arrowLong : { length : Float, percentage : Float } -> Html msg
arrowLong args =
    Svg.svg
        [ SA.width (String.fromFloat (args.length * 2.14) ++ "px")
        , SA.class "offset-box"
        , SA.viewBox <| String.join " " (List.map String.fromFloat [ 0 - args.length + 5, 0, args.length + 5, 10 ])
        , SA.fill p.colorArrows
        , HA.style "offset-distance" (String.fromFloat args.percentage ++ "%")
        , HA.style "position" "absolute"
        ]
        [ Svg.path [ SA.d <| p.svgArrowHead ++ " " ++ String.replace "{{size}}" (String.fromFloat (args.length - 5)) p.svgArrowExtra ] [] ]


viewSvgTrack : Model -> List (Html msg)
viewSvgTrack model =
    if model.isTrackVisible then
        [ Svg.svg
            [ SA.width (String.fromInt p.sizeWidth)
            , SA.height (String.fromInt p.sizeHeight)
            , HA.style "position" "absolute"
            , HA.style "opacity" "0.3"
            ]
            [ Svg.path
                [ SA.d svgMainPath
                , SA.fill "transparent"
                , SA.stroke p.colorPrimaryBlue -- "rgb(11, 218, 149)"
                , SA.strokeWidth "7"

                -- , SA.strokeDasharray "4 10"
                ]
                []
            ]
        ]

    else
        []


viewAnimations : Model -> List (Html msg)
viewAnimations model =
    List.filterMap
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
                        if percentageRelative < p.fadeIn then
                            percentageRelative / p.fadeIn

                        else if percentageRelative > (100 - p.fadeOut) then
                            (100 - percentageRelative) / p.fadeOut

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
                Nothing
        )
        model.animations


viewDebuggingArrows : Model -> List (Html msg)
viewDebuggingArrows model =
    let
        debuggingArrowSpeed : Float
        debuggingArrowSpeed =
            10
    in
    case model.debugMode of
        Disabled ->
            []

        ShowAllArrows ->
            let
                qty : Float
                qty =
                    1.5
            in
            List.map
                (\index ->
                    arrow_
                        { count = model.count / debuggingArrowSpeed, index = toFloat index / qty, opacity = 1 }
                )
                (List.range 0 (round (100 * qty)))

        ShowOneArrow ->
            [ arrow_ { count = model.count / debuggingArrowSpeed, index = 0, opacity = 1 } ]


viewObject : Object -> ObjectDataVariable -> Html msg
viewObject object args =
    let
        f : { argsFixed : ObjectDataFixed, element : ObjectDataFixed -> ObjectDataVariable -> Html msg }
        f =
            objectToHtml object
    in
    f.element f.argsFixed args


size1 =
    80


fontSize =
    18


viewAreaUnsafe =
    div
        [ HA.style "position" "absolute"
        , HA.style "width" (String.fromFloat (((p.sizeWidth - p.sizeWidthElmRuntime) / 2) - 50) ++ "px")
        , HA.style "height" (String.fromFloat (p.sizeHeight - size1) ++ "px")
        , HA.style "background-color" p.colorBackgroundGray
        , HA.style "color" p.colorPrimaryBlue
        , HA.style "font-size" (String.fromFloat fontSize ++ "px")
        , HA.style "padding" "20px"
        , HA.style "left" "0px"
        , HA.style "top" (String.fromFloat size1 ++ "px")
        , HA.style "text-align" "right"
        , HA.style "box-sizing" "border-box"
        , HA.style "border-radius" "12px"
        ]
        [ text "Unsafe Area" ]


viewAreaSafe =
    div
        [ HA.style "position" "absolute"
        , HA.style "width" (String.fromFloat (((p.sizeWidth - p.sizeWidthElmRuntime) / 2) - 50) ++ "px")
        , HA.style "height" (String.fromFloat (p.sizeHeight - size1) ++ "px")
        , HA.style "background-color" p.colorBackgroundGray
        , HA.style "color" p.colorPrimaryBlue
        , HA.style "font-size" (String.fromFloat fontSize ++ "px")
        , HA.style "padding" "20px"
        , HA.style "right" "0px"
        , HA.style "top" (String.fromFloat size1 ++ "px")
        , HA.style "text-align" "left"
        , HA.style "box-sizing" "border-box"
        , HA.style "border-radius" "12px"
        ]
        [ text "Safe Area" ]


viewElmRuntime =
    div
        [ HA.style "position" "absolute"
        , HA.style "width" (String.fromFloat p.sizeWidthElmRuntime ++ "px")
        , HA.style "height" (String.fromFloat (p.sizeHeight - size1) ++ "px")
        , HA.style "background-color" "rgba(18, 147, 216, 0.3)"
        , HA.style "color" p.colorPrimaryBlue
        , HA.style "font-size" (String.fromFloat fontSize ++ "px")
        , HA.style "left" (String.fromFloat ((p.sizeWidth - p.sizeWidthElmRuntime) / 2) ++ "px")
        , HA.style "top" (String.fromFloat size1 ++ "px")
        , HA.style "text-align" "center"
        , HA.style "padding" "20px"
        , HA.style "box-sizing" "border-box"
        , HA.style "border-radius" "12px"
        ]
        [ text "Elm Runtime"
        ]


viewBoxYellow : { translateX : Float, percentage : Float, text : String } -> Html msg
viewBoxYellow =
    viewBoxGeneric
        { colorBackground = "rgba(255,230,0, 0.8)"
        , colorForeground = "rgba(100,100,0, 1)"
        }


viewBoxBlue : { translateX : Float, percentage : Float, text : String } -> Html msg
viewBoxBlue =
    viewBoxGeneric
        { colorBackground = "rgba(18, 147, 216, 0.3)"
        , colorForeground = p.colorPrimaryBlue
        }


viewBoxGeneric : { colorBackground : String, colorForeground : String } -> { translateX : Float, percentage : Float, text : String } -> Html msg
viewBoxGeneric args1 args2 =
    div
        [ HA.style "position" "absolute"
        , HA.style "width" "130px"
        , HA.style "transform" ("translateX(" ++ String.fromFloat args2.translateX ++ "px)")
        , HA.style "height" "100px"
        , HA.style "background-color" args1.colorBackground
        , HA.style "color" args1.colorForeground
        , HA.style "font-size" (String.fromFloat fontSize ++ "px")
        , HA.style "border-radius" "10px"
        , SA.class "offset-box"
        , HA.style "offset-distance" (String.fromFloat args2.percentage ++ "%")
        , HA.style "offset-rotate" "0deg"
        , HA.style "display" "flex"
        , HA.style "align-items" "center"
        , HA.style "justify-content" "center"
        ]
        [ text args2.text ]


attrsButton title msg =
    [ HA.style "border" "0"
    , HA.style "padding" "0"
    , HA.style "background-color" "transparent"
    , HA.title title
    , HE.onClick msg
    ]


viewControls : Model -> Html Msg
viewControls model =
    div
        [ HA.style "font-family" "monospace"
        , HA.style "width" (String.fromInt p.sizeWidth ++ "px")
        , HA.style "border" "1px solid red"
        ]
        ([]
            ++ [ div
                    [ HA.style "display" "flex" ]
                    ([ case model.state of
                        Play ->
                            button (attrsButton "Play" (ChangeState Pause)) [ viewButtonTemplate p.svgInnerPause ]

                        Pause ->
                            button (attrsButton "Pause" (ChangeState Play)) [ viewButtonTemplate p.svgInnerPlay ]
                     , button (attrsButton "Stop" Reset) [ viewButtonTemplate p.svgInnerStop ]
                     , button (attrsButton "Toggle Dark Mode" ToggleDarkMode) [ viewButtonTemplate p.svgInnerDarkMode ]
                     , button (attrsButton "Toggle Path" ToggleTrackVisibility) [ viewButtonTemplate p.svgInnerPath ]
                     , button (attrsButton "Toggle All Arrows" ToggleDebugMode) [ viewButtonTemplate p.svgInnerArrows ]
                     , button (attrsButton "Toggle All Arrows" ToggleDebugMode) [ viewButtonTemplate p.svgInnerSettings ]
                     , button (attrsButton "Replay" Replay) [ viewButtonTemplate p.svgInnerReplay ]
                     , input
                        [ HA.type_ "range"
                        , HA.min "0"
                        , HA.max (String.fromFloat model.cachedMaxCount)
                        , HA.style "width" "100%"
                        , HA.value (String.fromFloat model.count)
                        , HA.step (String.fromFloat 1)
                        , HA.class "slider"
                        , HE.onInput ChangeSlider
                        ]
                        []
                     ]
                        ++ (let
                                remainingTime =
                                    abs (model.cachedMaxCount - model.count)

                                remainingTimeSeconds =
                                    floor (remainingTime / 60)

                                remainingTime60 =
                                    remainingTime - (toFloat remainingTimeSeconds * 60)
                            in
                            [ div
                                [ HA.style "width" "90px"
                                , HA.style "display" "flex"
                                , HA.style "align-items" "center"
                                , HA.style "justify-content" "right"
                                , HA.style "font-size" "20px"
                                , HA.style "color" "gray"
                                ]
                                [ text <| String.fromInt remainingTimeSeconds
                                , text ":"
                                , text <| String.padLeft 2 '0' (String.fromInt <| floor remainingTime60)
                                ]
                            ]
                           )
                    )
               , div []
                    [ button [ HE.onClick <| AddTimeline <| timeline1 model.count 1 ] [ text "Add 1" ]
                    , button [ HE.onClick <| AddTimeline <| timeline1 model.count 3 ] [ text "Add 3" ]
                    , button [ HE.onClick <| AddTimeline <| timeline1 model.count 5 ] [ text "Add 5" ]
                    , button [ HE.onClick <| AddTimeline <| timeline1 model.count 10 ] [ text "Add 10" ]
                    ]
               , div []
                    [ button [ HE.onClick <| AddTimeline <| timeline2 model.count 1 ] [ text "Add 1" ]
                    , button [ HE.onClick <| AddTimeline <| timeline2 model.count 3 ] [ text "Add 3" ]
                    , button [ HE.onClick <| AddTimeline <| timeline2 model.count 5 ] [ text "Add 5" ]
                    , button [ HE.onClick <| AddTimeline <| timeline2 model.count 10 ] [ text "Add 10" ]
                    ]
               ]
        )


type Object
    = BoxGreen String
    | BoxYellow String
    | BoxAzzurro String
    | BoxModelNew
    | Arrow
    | TipNew
    | Pointer


objectToHtml :
    Object
    ->
        { argsFixed : ObjectDataFixed
        , element : ObjectDataFixed -> ObjectDataVariable -> Html msg
        }
objectToHtml object =
    case object of
        TipNew ->
            { argsFixed =
                { colorBackground = "red"
                , colorForeground = "white"
                , text = "New"
                , textTip = Nothing
                }
            , element = viewTip
            }

        BoxGreen text ->
            { argsFixed =
                { colorBackground = "green"
                , colorForeground = "white"
                , text = text
                , textTip = Nothing
                }
            , element = viewBox
            }

        BoxYellow text ->
            { argsFixed =
                { colorBackground = "rgb(255,220,0)"
                , colorForeground = "black"
                , text = text
                , textTip = Nothing
                }
            , element = viewBox
            }

        BoxAzzurro text ->
            { argsFixed =
                { colorBackground = p.colorPrimaryBlue
                , colorForeground = "white"
                , text = text
                , textTip = Nothing
                }
            , element = viewBox
            }

        BoxModelNew ->
            { argsFixed =
                { colorBackground = p.colorPrimaryBlue
                , colorForeground = "white"
                , text = "Model"
                , textTip = Just "New"
                }
            , element = viewBox
            }

        Arrow ->
            { argsFixed =
                { colorBackground = "rgba(18, 147, 216, 0.3)"
                , colorForeground = ""
                , text = ""
                , textTip = Nothing
                }
            , element = viewArrow
            }

        Pointer ->
            { argsFixed =
                { colorBackground = ""
                , colorForeground = ""
                , text = ""
                , textTip = Nothing
                }
            , element = viewPointer
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


widthText : String -> Int
widthText text =
    String.length text * 10 + 16


viewTip : ObjectDataFixed -> ObjectDataVariable -> Html msg
viewTip argsFixed args =
    div
        [ HA.class "offset-box"
        , HA.style "offset-distance" (String.fromFloat args.percentage ++ "%")
        , HA.style "offset-rotate" "0deg"
        , HA.style "position" "absolute"
        , HA.style "padding" "3px 0 0 0"
        , HA.style "height" "16px"
        , HA.style "width" (String.fromInt (widthText argsFixed.text - 6) ++ "px")
        , HA.style "border-radius" "30px"
        , HA.style "transform" "rotate(20deg) translateX(18px) translateY(-22px)"
        , HA.style "font-size" "12px"
        , HA.style "background-color" argsFixed.colorBackground
        , HA.style "color" argsFixed.colorForeground
        , HA.style "text-align" "center"
        , HA.style "opacity" (String.fromFloat args.opacity)
        ]
        [ text argsFixed.text ]


viewBox : ObjectDataFixed -> ObjectDataVariable -> Html msg
viewBox argsFixed args =
    div
        [ HA.class "offset-box"
        , HA.style "offset-distance" (String.fromFloat args.percentage ++ "%")
        , HA.style "offset-rotate" "0deg"
        , HA.style "position" "absolute"
        , HA.style "height" "20px"
        , HA.style "width" (String.fromInt (widthText argsFixed.text) ++ "px")
        , HA.style "padding" "4px 0 0 0"
        , HA.style "border-radius" "8px"
        , HA.style "text-align" "center"
        , HA.style "opacity" (String.fromFloat args.opacity)
        , HA.style "background-color" argsFixed.colorBackground
        , HA.style "color" argsFixed.colorForeground
        ]
        ([]
            ++ (case argsFixed.textTip of
                    Just textTip ->
                        [ div
                            [ HA.style "position" "absolute"
                            , HA.style "background-color" "red"
                            , HA.style "color" "white"
                            , HA.style "padding" "3px 0 0 0"
                            , HA.style "height" "16px"
                            , HA.style "width" (String.fromInt (widthText textTip - 6) ++ "px")
                            , HA.style "border-radius" "30px"
                            , HA.style "transform" "rotate(20deg)"
                            , HA.style "top" "-12px"
                            , HA.style "right" "-12px"
                            , HA.style "font-size" "12px"
                            ]
                            [ text textTip ]
                        ]

                    Nothing ->
                        []
               )
            ++ [ text argsFixed.text ]
        )


viewArrow : ObjectDataFixed -> ObjectDataVariable -> Html msg
viewArrow argsFixed argsVariable =
    Svg.svg
        [ SA.viewBox "0 0 10 10"
        , SA.class "offset-box"
        , SA.width "20px"
        , SA.height "20px"
        , SA.fill argsFixed.colorBackground
        , HA.style "offset-distance" (String.fromFloat argsVariable.percentage ++ "%")
        , HA.style "position" "absolute"
        ]
        [ Svg.path [ SA.d p.svgArrowHead ] [] ]


viewPointer : ObjectDataFixed -> ObjectDataVariable -> Html msg
viewPointer _ argsVariable =
    let
        rotation =
            if argsVariable.percentage < 100 then
                -- 0 ~ 99
                10

            else if argsVariable.percentage < 140 then
                -- 100 ~ 139
                -- from 0 to 39
                argsVariable.percentage - 90

            else if argsVariable.percentage < 160 then
                -- 140 ~ 159
                -- from 39 to 0
                160 - argsVariable.percentage

            else
                10

        -- + 5
    in
    Svg.svg
        [ SA.viewBox "-5 -2 10 19"
        , SA.width "40px"
        , SA.fill "brown"
        , SA.class "offset-box"
        , HA.style "offset-distance" (String.fromFloat p.pointDom ++ "%")
        , HA.style "position" "absolute"
        , HA.style "transform" ("translateX(28px) translateY(10px)  rotate(-" ++ String.fromFloat rotation ++ "deg)")
        , HA.style "transform-origin" "55% 65%"
        , HA.style "opacity" (String.fromFloat argsVariable.opacity)
        , HA.style "offset-rotate" "0deg"
        , SA.fill "rgba(255,255,255,1)"
        , SA.stroke "rgba(50,180,230,1)"

        -- , SA.strokeLinecap "round"
        , SA.strokeWidth "1px"
        ]
        [ Svg.path [ SA.d p.svgPointer ] []
        ]


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
