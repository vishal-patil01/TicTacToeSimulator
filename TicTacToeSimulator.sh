#!/bin/bash
echo "Welcome To TicTacToe Simulator "

#!Initializing variable 
declare -a gameBoard
playerMoves=0

#!Initializing Constants
TOTAL_MOVES=9

#!Resetting Game Board By Initilizing Array With Default Value
function resetBoard() {
	gameBoard=(1 2 3 4 5 6 7 8 9)
	displayBoard
}

#!Displaying GameBoard
function displayBoard() {
	echo "-------------"
	for((i=0;i<9;i+=3))
	do
		echo "| ${gameBoard[$i]} | ${gameBoard[$((i+1))]} | ${gameBoard[$((i+2))]} |"
		echo "-------------"
	done
}

#!Assigning Letter X or O To Player and decide who Play First 
function tossForPlay() {
	if [ $((RANDOM % 2)) -eq 0 ]
	then
		playerSign='X'
	else
		playerSign='O'
	fi
	echo "Player1 Sign $playerSign"
}

#!User play Function
function  userPlay() {
	read -p "Enter Position Between 1 to 9 : " position
	if [[ $position -ge 1 && $position -le 9 ]]
	then
		positionIsOccupy $position
	else
		echo "Invalid Position out Of Board"
		userPlay
	fi
}

#!Run Game Untill Game Ends
function playTillGameEnd() {
	while [ $playerMoves -lt $TOTAL_MOVES ]
	do
		userPlay
		displayBoard
	done
}

#!checking Position is already filled or blank
function positionIsOccupy() {
	local position=$1-1
	if((${gameBoard[position]}!=$playerSign))
	then
		gameBoard[$position]=$playerSign
		((playerMoves++))
	else
		echo "Position is Occupied"
	fi
}

#!Starting Game
resetBoard
tossForPlay
playTillGameEnd
