#Tmux Productive Mouse-Free Development

##Book notes

###Chapter 1: The Basics

###Creating Named Sessions

tmux new -s name

exit tmuxt


###Detach from session

ctrl-b then d

ctrl-b is the default command prefix

List sessions:

tmux ls

Attach 

tmux attach

Create a new tmux instance in the background:
tmux new -s second_session -d

Attach session using -t

tmux attach -t second_session

Kill Session

tmux kill-session -t name

##Windows:

Session with two windows:

tmux new -s windows -n shell

-s is the screen name, -n is the windown name

Creating a window in current session:

[Prefix]+ c

Rename a window
[Predix] + ,

###Moving between windows

Next window:
[prefix] + n

Previous window
[prefix] + p

Numbers:
[prefix] + number (0-9)

Find window by name
[p] + f

View menu of windows
[p] + w

Close a windows

exit or [p]&

##Panes

Divide vertically
[p] + %

Divide horizonally
[p] + "

Move between panes

[p]+o

or [p] + arrow key


Pane Layouts

Cycle through layouts
[p] + spacebar


Closing panes:

type exit or press [p] + x




 
