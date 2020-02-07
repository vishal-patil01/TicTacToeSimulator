#!/bin/bash
echo "Welcome To TicTacToe Simulator "

#!Initializing variable 
declare -a gameBoard

#!Resetting Game Board By Initilizing Array With Default Value
function resetBoard() {
	gameBoard=(1 2 3 4 5 6 7 8 9)
}

#!Assigning Letter X or O To Player and decide who Play First 
function tossForPlay() {
	if [ $((RANDOM % 2)) -eq 0 ]
	then
		playerSign='X'
		playerTurn=true
	else
		playerSign='O'
		playerTurn=true
	fi
	echo "Player1 Sign $playerSign"
}

#!Starting Game
resetBoard
tossForPlay
