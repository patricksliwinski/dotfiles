import XMonad
import XMonad.Layout.Spacing
import XMonad.Util.EZConfig

import qualified Data.Map         as M
import qualified XMonad.StackSet  as W

main = xmonad myConfig

myConfig = def
  {
    layoutHook = spacingRaw True (Border 15 15 15 15) True (Border 30 30 30 30) True $ myLayoutHook,
    borderWidth = 0
  } `additionalKeysP` myKeybindings

myLayoutHook = Tall 1 (3/100) (1/2)
myKeybindings = 
  [ (("M-s"), spawn "code /home/patrick/typed-notes"),
    (("M-d"), spawn "alacritty -e bash -c 'xclip -o | sdcv | less'"),
    (("M-m"), spawn "alacritty -e bash -c 'man $(xclip -o)'"),
    (("M-z"), spawn "zeal $(xclip -o)"),
    (("M-a"), kill),
    (("M-t"), withFocused toggleFloat),
    (("M-n"), spawn "exec /usr/local/bin/eww open-many controls power calendar-full disk todo"),
    (("M-b"), spawn "exec /usr/local/bin/eww close-all")
  ]


toggleFloat w = windows (\s -> if M.member w (W.floating s)
                          then W.sink w s
                          else (W.float w (W.RationalRect (1/4) (1/4) (1/2) (1/2)) s))
