#!/bin/bash
doit(){ polybar-msg cmd $1 && bspc config -m focused top_padding ${p[$1]}; }
declare -A p=([hide]=0 [show]=${PANELPAD:-25})
doit $(xlsw | awk '$3=="Polybar/polybar" && $2~/^-..$/{e="hide"}BEGIN{e="show"}END{print e}')

