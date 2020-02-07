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
		playerSign=X
	else
		playerSign=O
	fi
	echo "Player1 Sign $playerSign"
}

#!User play Function
function  userPlay() {
	read -p "Enter Position Between 1 to 9 : " position
	if [[ $position -ge 1 && $position -le 9 ]]
	then
		isPositionOccupy $position
	else
		echo "Invalid Position out Of Board"
		userPlay
	fi
}

#!checking Position is already filled or blank
function isPositionOccupy() {
	local position=$1-1
	if((${gameBoard[position]}!=X && ${gameBoard[position]}!=O))
	then
		gameBoard[$position]=$playerSign
		((playerMoves++))
	else
		echo "Position is Occupied"
		userPlay
	fi
}

#!Run Game Untill Game Ends And Switching PlayerSign After Winning Check Using Ternary Operator
function playTillGameEnd() {
	while [ $playerMoves -lt $TOTAL_MOVES ]
	do
		userPlay
		displayBoard
		checkWinningCells
		[ $playerSign == X ] && playerSign=O || playerSign=X
	done
	echo "Game Tie...."
}

#!checking Column,Rows and Diagonals
function checkWinningCells() {
	col=0
	for((row=0;row<9;row+=3))
	do
		checkWinner ${gameBoard[$row]} ${gameBoard[$((row+1))]} ${gameBoard[$((row+2))]}
		checkWinner ${gameBoard[$col]} ${gameBoard[$((col+3))]} ${gameBoard[$((col+6))]}
		((col+=2))
	done
		checkWinner ${gameBoard[0]} ${gameBoard[4]} ${gameBoard[8]}
		checkWinner ${gameBoard[2]} ${gameBoard[4]} ${gameBoard[6]}
}

#!checking Winner
function checkWinner() {
	local cell1=$1 cell2=$2 cell3=$3
	if [ $cell1 == $cell2 ] && [ $cell2 == $cell3 ]
	then
		echo "Player Win and Have Sign $playerSign"
		exit
	fi
}

#!Starting Game
resetBoard
tossForPlay
playTillGameEnd

