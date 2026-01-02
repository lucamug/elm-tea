module ReviewConfig exposing (config)

{-| Do not rename the ReviewConfig module or the config function, because
`elm-review` will look for these.

To add packages that contain rules, add them to this review project using

    `elm install author/packageName`

when inside the directory containing this file.

-}

import NoAlways
import NoDuplicatePorts
import NoEmptyText
import NoExposingEverything
import NoFloatIds
import NoImportingEverything
import NoInconsistentAliases
import NoMissingSubscriptionsCall
import NoMissingTypeAnnotation
import NoMissingTypeAnnotationInLetIn
import NoMissingTypeConstructor
import NoMissingTypeExpose
import NoModuleOnExposedNames
import NoPrematureLetComputation
import NoPrimitiveTypeAlias
import NoRecordAliasConstructor
import NoRecursiveUpdate
import NoSimpleLetBody
import NoSinglePatternCase
import NoUnapprovedLicense
import NoUnoptimizedRecursion
import NoUnsafePorts
import NoUnsortedConstructors
import NoUnsortedRecordFields
import NoUnused.CustomTypeConstructorArgs
import NoUnused.CustomTypeConstructors
import NoUnused.Dependencies
import NoUnused.Exports
import NoUnused.Modules
import NoUnused.Parameters
import NoUnused.Patterns
import NoUnused.Variables
import NoUnusedPorts
import NoUselessSubscriptions
import Review.Rule exposing (Rule)
import Simplify


config : List Rule
config =
    [ NoImportingEverything.rule
        [ "Element"
        , "Ui"
        ]
    , NoMissingTypeAnnotation.rule
    , NoMissingTypeAnnotationInLetIn.rule
        |> Review.Rule.ignoreErrorsForFiles
            [ "src/Main.elm", "src/TodoWrapper.elm" ]
    , NoMissingTypeExpose.rule
    , NoMissingTypeConstructor.rule
    , NoUnused.CustomTypeConstructors.rule []
    , NoUnused.CustomTypeConstructorArgs.rule
        |> Review.Rule.ignoreErrorsForFiles
            []
    , NoUnused.Dependencies.rule
    , NoUnused.Exports.rule
        |> Review.Rule.ignoreErrorsForFiles
            [ "elm-transformer/src/Transformer.elm"
            ]
    , NoUnused.Modules.rule
    , NoUnused.Parameters.rule
    , NoUnused.Patterns.rule
    , NoUnused.Variables.rule
    , NoUnusedPorts.rule
    , NoSimpleLetBody.rule
    , NoAlways.rule
    , NoUselessSubscriptions.rule

    -- , NoUnoptimizedRecursion.rule (NoUnoptimizedRecursion.optOutWithComment "IGNORE TCO")
    , NoPrematureLetComputation.rule
    , Simplify.rule Simplify.defaults
    , NoMissingSubscriptionsCall.rule |> Review.Rule.ignoreErrorsForDirectories [ "tests_" ]
    , NoDuplicatePorts.rule
    , NoUnsafePorts.rule NoUnsafePorts.any
        |> Review.Rule.ignoreErrorsForFiles
            []
    , NoFloatIds.rule
    , NoRecursiveUpdate.rule

    -- "NoModuleOnExposedNames" is a bit buggy
    -- , NoModuleOnExposedNames.rule
    --         |> Review.Rule.ignoreErrorsForFiles
    --         [ "elm-on-page-editor/src/OnPageEditor/View.elm" -- Because of Ui.turns
    --         , "elm-portal/src/Portal/ReleasesAndChangelog.elm" -- Because of Ui.radians
    --         ]
    , NoSinglePatternCase.rule NoSinglePatternCase.fixInArgument
    , NoPrimitiveTypeAlias.rule
        |> Review.Rule.ignoreErrorsForFiles
            [ "src/Main.elm", "src/Counter.elm" ]
    , NoRecordAliasConstructor.rule
    , NoUnapprovedLicense.rule { allowed = [ "BSD-3-Clause", "MIT", "Apache-2.0", "ISC", "MPL-2.0" ], forbidden = [ "GPL-3.0-only", "GPL-3.0-or-later" ] }
    , NoExposingEverything.rule
        |> Review.Rule.ignoreErrorsForFiles
            []
    , NoUnsortedConstructors.rule
    , NoUnsortedRecordFields.rule
    ]
        |> List.map
            (\rule ->
                rule
                    |> Review.Rule.ignoreErrorsForDirectories
                        [ "elm_modules"
                        , "elm-vendored"
                        , "elm_modules"
                        ]
                    |> Review.Rule.ignoreErrorsForFiles
                        [ "src/TodoOriginal.elm"
                        ]
            )
