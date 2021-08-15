import           Data.Ratio
import           System.IO
import           XMonad
import           XMonad.Hooks.DynamicLog
import           XMonad.Hooks.ManageDocks
import           XMonad.Layout.Fullscreen   (fullscreenFull, fullscreenSupport)
import           XMonad.Layout.Grid
import           XMonad.Layout.MultiColumns
import           XMonad.Layout.NoBorders    (noBorders, smartBorders)
import           XMonad.Layout.Spacing
import           XMonad.Layout.Spiral
import           XMonad.Layout.Tabbed       (simpleTabbed)
import           XMonad.Layout.ThreeColumns
import           XMonad.Util.EZConfig       (additionalKeys)
import           XMonad.Util.Run            (spawnPipe)

myLayouts = spacing 16 . smartBorders $
            layoutTall
            ||| layoutNoBordersFull
            ||| layoutTabbed
            ||| layoutThreeCol
            ||| layoutMirror
            ||| layoutFull
            ||| layoutSpiral
            ||| layoutGrid
            ||| layoutThreeColMid
            ||| layoutMultiCol
            ||| layoutMirrorMultiLine
    where
      layoutTall = Tall 1 (3/100) (1/2)
      layoutMirror = Mirror (Tall 1 (3/100) (3/5))
      layoutFull = Full
      layoutNoBordersFull = noBorders Full
      layoutSpiral = spiral (125 % 146)
      layoutGrid = Grid
      layoutThreeCol = ThreeCol 1 (3/100) (1/2)
      layoutThreeColMid = ThreeColMid 1 (3/100) (1/2)
      layoutMultiCol = multiCol [1] 1 0.01 (-0.5)
      layoutMirrorMultiLine = Mirror layoutMultiCol
      layoutTabbed = noBorders simpleTabbed

myPP = xmobarPP { ppCurrent = xmobarColor "#a89984" "" . wrap "<" ">" }

toggleStrutsKey XConfig {XMonad.modMask = modMask} = (modMask, xK_b)

myLayoutHook = spacingRaw True (Border 0 10 10 10) True (Border 10 10 10 10) True $
               layoutHook def

myConfig = def
    { borderWidth = 1
    , modMask = mod4Mask
    , terminal = "alacritty"
    , normalBorderColor = "#32302f"
    , focusedBorderColor = "#a89984"
    , layoutHook = myLayouts
    } `additionalKeys`
    [
      ((0, 0x1008FF11), spawn "amixer -q sset Master 5%-"),
      ((0, 0x1008FF13), spawn "amixer -q sset Master 5%+"),
      ((0, 0x1008FF12), spawn "amixer set Master toggle"),
      ((mod4Mask, xK_F1), spawn "flameshot gui"),
      ((mod4Mask, xK_F2), spawn "clipmenu"),
      ((mod4Mask, xK_x), spawn "slock"),
      ((mod4Mask, xK_F4), spawn "xterm"),
      ((mod4Mask, xK_f), spawn "firefox")
    ]

main = xmonad myConfig
