{ xdotool, writeText }: writeText "libinput-gestures.conf" ''

gesture: swipe left  3 ${xdotool}/bin/xdotool key super+h
gesture: swipe right 3 ${xdotool}/bin/xdotool key super+s

''
