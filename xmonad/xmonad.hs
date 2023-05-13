import XMonad
import XMonad.Layout.Spacing
import XMonad.Util.EZConfig
import XMonad.Hooks.FloatNext
import XMonad.Hooks.ServerMode

import qualified Data.Map         as M
import qualified XMonad.StackSet  as W


--------------------------------------------------------------------------------
-- Window rules

-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
    
myManageHook =  composeAll 
  [ floatNextHook
  , className =? "eww-man-prompt" --> doFloatPrompt
  , className =? "eww-dict-prompt" --> doFloatPrompt
  , className =? "eww-zeal-prompt" --> doFloatPrompt
  ]


--------------------------------------------------------------------------------
-- Custom command server mode

myServerModeEventHook = serverModeEventHookCmd' $ return myCommands'
myCommands' = ("list-commands", listMyServerCmds) : myCommands

listMyServerCmds :: X ()
listMyServerCmds = spawn ("echo '" ++ asmc ++ "' | xmessage -file -")
    where asmc = concat $ "Available commands:" : map (\(x, _)-> "    " ++ x) myCommands'

myHandleEventHook = myServerModeEventHook

myCommands :: [(String, X ())]
myCommands = 
  [ ("float-next" , floatNext True)
  , ("float-active-center", withFocused toggleFloat) 
  ]


--------------------------------------------------------------------------------
-- Custom keybindings

myKeybindings = 
  [ (("M-s"), spawn "code /home/patrick/typed-notes")
  , (("M-m"), spawn "alacritty -e bash -c 'man $(xclip -o)'")
  , (("M-z"), spawn "zeal $(xclip -o)")
  , (("M-a"), kill)
  , (("M-t"), withFocused toggleFloat)
  , (("M-n"), spawn "exec /usr/local/bin/eww open-many controls power calendar-full disk info todo")
  , (("M-b"), spawn "exec /usr/local/bin/eww close-all")
  , (("M-S-m"), spawn "exec /usr/local/bin/eww open man-prompt")
  , (("M-S-d"), spawn "exec /usr/local/bin/eww open dict-prompt")
  , (("M-S-z"), spawn "exec /usr/local/bin/eww open zeal-prompt")
  , (("M-f"), toggleFloatNext)
  ]


--------------------------------------------------------------------------------
-- Floating window positions

toggleFloat w = windows (\s -> if M.member w (W.floating s)
                          then W.sink w s
                          else (W.float w (W.RationalRect (1/6) (1/6) (2/3) (2/3)) s))

doFloatPrompt :: ManageHook
doFloatPrompt = ask >>= \w -> doF . W.float w . snd =<< liftX (floatPrompt w)

-- Floating window locations
floatPrompt :: Window -> X (ScreenId, W.RationalRect)
floatPrompt w = do
      sc <- gets $ W.current . windowset
      return (W.screen sc, W.RationalRect (3/8) (1/4) (1/4) (1/15))


--------------------------------------------------------------------------------
-- Main

myLayoutHook = Tall 1 (3/100) (1/2)

myConfig = def
  {
    layoutHook = spacingRaw True (Border 15 15 15 15) True (Border 30 30 30 30) True $ myLayoutHook,
    borderWidth = 2,
    normalBorderColor  = "#2D353B",
    focusedBorderColor = "#E67E80",
    handleEventHook = myHandleEventHook,
    manageHook = myManageHook
  } `additionalKeysP` myKeybindings

main = xmonad myConfig
