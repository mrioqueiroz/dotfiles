import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Layout.Spacing
import XMonad.Layout.MultiColumns
import XMonad.Layout.Spiral
import XMonad.Layout.ThreeColumns
import XMonad.Layout.NoBorders (noBorders, smartBorders)
import XMonad.Layout.Fullscreen (fullscreenFull, fullscreenSupport)
import XMonad.Layout.Tabbed (simpleTabbed)
import XMonad.Layout.Grid
import Data.Ratio


myLayouts = spacing 0 . smartBorders $
            layoutTall
            ||| layoutMirror
            ||| layoutFull
            ||| layoutSpiral
            ||| layoutGrid
            ||| layoutThreeCol
            ||| layoutThreeColMid
            ||| layoutMultiCol
            ||| layoutMirrorMultiLine
            ||| layoutTabbed
    where
      layoutTall = Tall 1 (3/100) (1/2)
      layoutMirror = Mirror (Tall 1 (3/100) (3/5))
      layoutFull = Full
      layoutSpiral = spiral (125 % 146)
      layoutGrid = Grid
      layoutThreeCol = ThreeCol 1 (3/100) (1/2)
      layoutThreeColMid = ThreeColMid 1 (3/100) (1/2)
      layoutMultiCol = multiCol [1] 1 0.01 (-0.5)
      layoutMirrorMultiLine = Mirror layoutMultiCol
      layoutTabbed = simpleTabbed

myPP = xmobarPP { ppCurrent = xmobarColor "#a89984" "" . wrap "<" ">" }
toggleStrutsKey XConfig {XMonad.modMask = modMask} = (modMask, xK_b)
myLayoutHook = spacingRaw True (Border 0 10 10 10) True (Border 10 10 10 10) True $
               layoutHook def

myConfig = def
    { borderWidth = 3
    , terminal = "alacritty"
    , normalBorderColor = "#574e45"
    , focusedBorderColor = "#b9ad9c"
    , layoutHook = myLayouts
    }

main = xmonad =<< statusBar "xmobar" myPP toggleStrutsKey myConfig
