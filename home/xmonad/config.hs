import XMonad (
    Button,
    ChangeLayout (NextLayout),
    Default (def),
    Dimension,
    KeySym,
    Event,
    KeyMask,
    Layout,
    Mirror (Mirror),
    Query,
    Resize (Expand, Shrink),
    Tall (Tall),
    Window,
    WindowSet,
    X,
    XConfig (
        XConfig,
        borderWidth,
        clickJustFocuses,
        focusFollowsMouse,
        focusedBorderColor,
        handleEventHook,
        keys,
        layoutHook,
        logHook,
        manageHook,
        modMask,
        mouseBindings,
        normalBorderColor,
        startupHook,
        terminal,
        workspaces
    ),
    button1,
    composeAll,
    doIgnore,
    kill,
    mod1Mask,
    resource,
    sendMessage,
    setLayout,
    shiftMask,
    spawn,
    windows,
    withFocused,
    xK_1, xK_6, xK_7, xK_9, xK_Return, xK_b, xK_c, xK_f, xK_g, xK_h, xK_j, xK_k,
    xK_l, xK_m, xK_n, xK_p, xK_q, xK_space, xK_t, xK_v, xK_z,
    xmonad,
    (-->),
    (.|.),
    (=?),
    (|||),
 )

import XMonad.Actions.GridSelect
import XMonad.Actions.Minimize
import XMonad.Actions.NoBorders
import XMonad.Actions.Volume
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.SetWMName
import XMonad.Layout.Tabbed

import XMonad.Layout.Minimize
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

import XMonad.Util.Dzen
import XMonad.Util.Run
import XMonad.Util.SpawnOnce

import Data.Map qualified as M
import XMonad.StackSet qualified as W

import System.Exit

-- Imports for Polybar --
import Codec.Binary.UTF8.String qualified as UTF8
import DBus qualified as D
import DBus.Client qualified as D
import XMonad.Hooks.DynamicLog

import XMonad.Hooks.EwmhDesktops (
    ewmh,
    ewmhFullscreen,
 )
import XMonad.Layout.LayoutModifier qualified

alert :: Double -> X ()
alert = dzenConfig centered . show . round

centered :: (Int, [String]) -> X (Int, [String])
centered =
    onCurr (center 150 66)
        >=> font "-*-helvetica-*-r-*-*-64-*-*-*-*-*-*-*"
        >=> addArgs ["-fg", "#80c0ff"]
        >=> addArgs ["-bg", "#000040"]

myMouseBindings :: XConfig Layout -> M.Map (KeyMask, Button) (Window -> X ())
myMouseBindings (XConfig{XMonad.modMask = modMask}) =
    M.fromList
        [((modMask, button1), \_ -> return ())]

myTerminal :: String
myTerminal = "alacritty"

myFocusFollowsMouse :: Bool
myFocusFollowsMouse = False

myClickJustFocuses :: Bool
myClickJustFocuses = False

myBorderWidth :: Dimension
myBorderWidth = 8

myWorkspaces :: [String]
myWorkspaces = ["1", "2", "3", "4", "5"]

myNormalBorderColor :: String
myNormalBorderColor = "#000000"

myFocusedBorderColor :: String
myFocusedBorderColor = "#009B77"

myModMask :: KeyMask
myModMask = mod1Mask

appLauncher :: String
appLauncher = "rofi -modi drun,ssh,window -show drun -show-icons"

mySpacing :: l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing =
    spacingRaw
        False -- False=Apply even when single window
        (Border 5 5 5 5) -- Screen border size top bot rght lft
        True -- Enable screen border
        (Border 5 5 5 5) -- Window border size
        True -- Enable window borders

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys :: XConfig Layout -> M.Map (KeyMask, KeySym) (X ())
myKeys conf@(XConfig{XMonad.modMask = modm}) =
    M.fromList
        $ [ ((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)
          , ((modm .|. shiftMask, xK_h), spawn "haruna")
          , ((modm, xK_b), spawn "qutebrowser")
          , ((modm, xK_z), spawn "zathura")
          , ((modm, xK_v), spawn "brave")
          , ((modm, xK_g), goToSelected def)
          , ((modm, xK_6), lowerVolume 4 >>= alert)
          , ((modm, xK_7), raiseVolume 4 >>= alert)
          , ((modm .|. shiftMask, xK_c), kill)
          , ((modm, xK_space), sendMessage NextLayout)
          , ((modm .|. shiftMask, xK_space), setLayout $ XMonad.layoutHook conf)
          , ((modm, xK_p), spawn "rofi -show run")
          , ((modm, xK_j), windows W.focusDown)
          , ((modm, xK_k), windows W.focusUp)
          , ((modm .|. shiftMask, xK_j), windows W.swapDown)
          , ((modm .|. shiftMask, xK_k), windows W.swapUp)
          , ((modm, xK_h), sendMessage Shrink)
          , ((modm, xK_l), sendMessage Expand)
          , ((modm .|. shiftMask, xK_t), sendMessage ToggleStruts)
          , ((modm, xK_t), withFocused $ windows . W.sink)
          , ((modm, xK_q), spawn "xmonad --recompile; xmonad --restart")
          , ((modm, xK_m), withFocused minimizeWindow)
          , ((modm .|. shiftMask, xK_m), withLastMinimized maximizeWindowAndFocus)
          , ((modm .|. shiftMask, xK_n), withFocused toggleBorder)
          , ((modm, xK_f), sendMessage $ Toggle FULL)
          ]
        ++ [ ((m .|. modm, k), windows $ f i)
           | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
           , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]
           ]

myLayout =
    avoidStruts
        $ smartBorders
        $ mySpacing
        $ mkToggle (NOBORDERS ?? FULL ?? EOT)
        $ tiled
        ||| Mirror tiled
  where
    tiled = Tall nmaster delta ratio
    nmaster = 1
    ratio = 1 / 2
    delta = 3 / 100

myManageHook =
    composeAll
        [ resource =? "desktop_window" --> doIgnore
        , resource =? "kdesktop" --> doIgnore
        ]

-- myEventHook :: Event -> X All
myEventHook = mempty

myLogHook :: X ()
myLogHook = mempty

myStartupHook :: X ()
myStartupHook = setWMName "LG3D"

defaults =
    def
        { -- simple stuff
          terminal = myTerminal
        , focusFollowsMouse = myFocusFollowsMouse
        , clickJustFocuses = myClickJustFocuses
        , borderWidth = myBorderWidth
        , modMask = myModMask
        , workspaces = myWorkspaces
        , normalBorderColor = myNormalBorderColor
        , focusedBorderColor = myFocusedBorderColor
        , -- key bindings
          keys = myKeys
        , mouseBindings = myMouseBindings
        , -- hooks, layouts
          layoutHook = myLayout
        , manageHook = myManageHook
        , handleEventHook = myEventHook
        , logHook = myLogHook
        , startupHook = myStartupHook
        }

main :: IO ()
main = do
    xmprov <- spawnPipe "polybar"
    xmonad $ (docks . ewmh) defaults
