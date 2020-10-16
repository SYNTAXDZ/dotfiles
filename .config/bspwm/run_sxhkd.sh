killall -q sxhkd
while pgrep -u $UID -x sxhkd >/dev/null; do sleep 1; done
sxhkd &
