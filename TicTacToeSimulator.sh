#!/bin/bash
echo "Welcome To TicTacToe Simulator "

#!Initializing variable 
declare -a gameBoard

#!Resetting Game Board By Initilizing Array With Default Value
function resetBoard() {
	gameBoard=(1 2 3 4 5 6 7 8 9)
}
