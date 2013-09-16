#!/bin/sh
#
# name     : tmux script
# author   : dalang dalang1987@gmail.com
# license  : GPL
# created  : 2013 Sep 16
#

cmd=$(which tmux) # tmux path
session=codemyfuture # session name

if [ -z $cmd ]; then
    echo "tmux command was not found"
    exit 1
fi

$cmd has -t $session

if [ $? != 0 ]; then
    $cmd new -d -n vim -s $session "vim"
    $cmd splitw -v -p 20 -t $session "pry"
    $cmd neww -n zsh -t $session "zsh"
    $cmd selectw -t $session:0
fi

$cmd att -t $session

exit 0
