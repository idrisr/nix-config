{-# LANGUAGE ImportQualifiedPost #-}

-- [># OPTIONS_GHC -Wno-missing-signatures #<]

import Data.Map qualified as M
import XMonad
import XMonad.Actions.NoBorders
import XMonad.Actions.Search
import XMonad.Actions.Volume
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Layout.LayoutModifier qualified
import XMonad.Layout.MultiColumns ()
import XMonad.Layout.MultiToggle (
    EOT (EOT),
    Toggle (Toggle),
    mkToggle,
    (??),
 )
import XMonad.Layout.MultiToggle.Instances (
    StdTransformers (FULL, NOBORDERS),
 )
import XMonad.Layout.NoBorders (smartBorders)
import XMonad.Layout.Spacing (
    Border (Border),
    Spacing,
    spacingRaw,
 )
import XMonad.Prompt (XPConfig (height, position), XPPosition (CenteredAt), greenXPConfig)
import XMonad.StackSet qualified as W
import XMonad.Util.Dzen

alert :: Double -> X ()
alert = dzenConfig centered . (show :: Int -> String) . round

alertMute :: Bool -> X ()
alertMute = dzenConfig centered . f
  where
    f :: Bool -> String
    f True = "muted"
    f False = "unmuted"

centered :: (Int, [String]) -> X (Int, [String])
centered =
    onCurr (center 150 90)
        >=> font "-*-helvetica-*-r-*-*-64-*-*-*-*-*-*-*"
        >=> addArgs ["-fg", "#80c0ff"]
        >=> addArgs ["-bg", "#000040"]

myMouseBindings :: XConfig Layout -> M.Map (KeyMask, Button) (Window -> X ())
myMouseBindings (XConfig{XMonad.modMask = m}) = M.fromList [((m, button1), \_ -> pure ())]

mySpacing :: l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing =
    spacingRaw
        False -- False=Apply even when single window
        (Border 5 5 5 5) -- Screen border size top bot rght lft
        True -- Enable screen border
        (Border 5 5 5 5) -- Window border size
        True -- Enable window borders

promptConfig :: XPConfig
promptConfig = greenXPConfig{height = 200, position = CenteredAt 0.5 0.5}

qute :: String
qute = "qutebrowser"

brave :: String
brave = "brave"

quteSearch :: SearchEngine -> X ()
quteSearch = promptSearchBrowser promptConfig qute

braveSearch :: SearchEngine -> X ()
braveSearch = promptSearchBrowser promptConfig brave

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys :: XConfig Layout -> M.Map (KeyMask, KeySym) (X ())
myKeys conf@(XConfig{XMonad.modMask = modm}) =
    M.fromList $
        [ ((modm .|. shiftMask, xK_b), spawn qute)
        , ((modm .|. shiftMask, xK_f), sendMessage . Toggle $ FULL)
        , ((modm .|. shiftMask, xK_j), windows W.swapDown)
        , ((modm .|. shiftMask, xK_k), windows W.swapUp)
        , ((modm .|. shiftMask, xK_n), withFocused toggleBorder)
        , ((modm .|. shiftMask, xK_o), kill)
        , ((modm .|. shiftMask, xK_q), spawn "xmonad --recompile; xmonad --restart")
        , ((modm .|. shiftMask, xK_Return), spawn . XMonad.terminal $ conf)
        , ((modm .|. shiftMask, xK_space), setLayout . XMonad.layoutHook $ conf)
        , ((modm .|. shiftMask, xK_t), sendMessage ToggleStruts)
        , ((modm .|. shiftMask, xK_v), spawn brave)
        , ((modm, xK_6), lowerVolume 4 >>= alert)
        , ((modm, xK_7), raiseVolume 4 >>= alert)
        , ((modm, xK_8), toggleMute >> getMute >>= alertMute)
        , ((modm, xK_a), quteSearch nixos)
        , ((modm, xK_b), quteSearch flora)
        , ((modm, xK_c), braveSearch youtube)
        , ((modm, xK_d), braveSearch maps)
        , ((modm, xK_g), spawn "rofi -show window")
        , ((modm, xK_h), sendMessage Shrink)
        , ((modm, xK_j), windows W.focusDown)
        , ((modm, xK_k), windows W.focusUp)
        , ((modm, xK_l), sendMessage Expand)
        , ((modm, xK_p), spawn "rofi -show drun -show-icons")
        , ((modm, xK_r), spawn "rofi -modi drun,window,emoji -show emoji")
        , ((modm, xK_space), sendMessage NextLayout)
        , ((modm, xK_t), withFocused $ windows . W.sink)
        , ((modm, xK_t), withFocused actionA)
        ]
            ++ [ ((m .|. modm, k), windows $ f i)
               | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
               , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]
               ]

actionA :: Window -> X ()
actionA windowID = do
    floats <- gets $ W.floating . windowset
    if windowID `M.member` floats
        then withFocused $ windows . W.sink
        else float windowID

workspaceHook name index = className =? name --> doShift (show index) <+> doF (W.view (show index))

myManageHooks =
    composeAll
        [ workspaceHook "kitty" 1
        , workspaceHook "qutebrowser" 2
        , workspaceHook "brave-browser" 3
        , workspaceHook "Zathura" 4
        , workspaceHook "haruna" 5
        ]

myLayout =
    avoidStruts $
        smartBorders $
            mySpacing $
                mkToggle (NOBORDERS ?? FULL ?? EOT) $
                    tiled
                        ||| Mirror tiled
  where
    tiled = Tall nmaster delta ratio
    nmaster = 1
    ratio = 1 / 2
    delta = 3 / 100

main :: IO ()
main =
    spawn "polybar"
        >> (xmonad . docks . ewmh)
            def
                { terminal = "kitty"
                , focusFollowsMouse = True
                , clickJustFocuses = False
                , borderWidth = 8
                , modMask = mod1Mask
                , workspaces = show <$> [1 .. 5 :: Int]
                , normalBorderColor = "#000000"
                , focusedBorderColor = "#009B77"
                , keys = myKeys
                , mouseBindings = myMouseBindings
                , layoutHook = myLayout
                , manageHook = myManageHooks
                , handleEventHook = mempty
                , logHook = pure ()
                , startupHook = pure ()
                }
