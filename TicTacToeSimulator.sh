#!/bin/bash 
echo "Welcome To TicTacToe Simulator "

#!Initializing variable 
declare -a gameBoard
playerMoves=0
playerTurn=0

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
		computer=X
		player=O
	else
		player=X
		computer=O
	fi
	[ $player == X ] && echo "Player play First with X sign" ||  echo "Computer play First With X Sign"
	[ $player == X ] && playerTurn || computerTurn
}

#!switching players
function switchPlayer() {
	[ $playerTurn == 1 ] && computerTurn || playerTurn
}

#!User play Function
function  playerTurn() {
	[ ${FUNCNAME[1]} == switchPlayer ] && echo "Player Turn Sign is $player" 
	playerTurn=1
	read -p "Enter Position Between 1 to 9 : " position
	if [[ $position -ge 1 && $position -le 9  && $position != ' ' ]]
	then
		isCellEmpty $position $player
	else
		echo "Please Enter Value "
		playerTurn
	fi
}

#!User play Function
function  computerTurn() {
	[ ${FUNCNAME[1]} == switchPlayer ] && echo "Computer Turn Sign $computer" 
	playerTurn=0
	position=$((RANDOM % 9))
	isCellEmpty $position $computer
}

#!checking Position is already filled or blank
function isCellEmpty() {
	local position=$1-1
	local sign=$2
	if((${gameBoard[position]}!=X && ${gameBoard[position]}!=O))
	then
		gameBoard[$position]=$sign
		((playerMoves++))
	else
		[ ${FUNCNAME[1]} == "playerTurn" ] &&  echo "Position is Occupied"
		${FUNCNAME[1]}
	fi
}

#!checking Rows,Rows and Diagonals
function checkWinningCells() {
	col=0
	for((row=0;row<7;row+=3))
	do
		checkWinner ${gameBoard[$row]} ${gameBoard[$((row+1))]} ${gameBoard[$((row+2))]}
		checkWinner ${gameBoard[$col]} ${gameBoard[$((col+3))]} ${gameBoard[$((col+6))]}
		((col++))
	done
		checkWinner ${gameBoard[0]} ${gameBoard[4]} ${gameBoard[8]}
		checkWinner ${gameBoard[2]} ${gameBoard[4]} ${gameBoard[6]}
}

#!checking Winner
function checkWinner() {
	local cell1=$1 cell2=$2 cell3=$3
	if [ $cell1 == $cell2 ] && [ $cell2 == $cell3 ]
	then
		[ $cell1 == $player ] && winner=player || winner=computer
		echo "$winner Win and Have Sign $cell1"
		exit
	fi
}

#!Run Game By Reseting Board and Run Untill Game Ends And Switching PlayerSign After Winning Check Using Ternary Operator
function playTillGameEnd() {
	resetBoard
	tossForPlay
	while [ $playerMoves -lt $TOTAL_MOVES ]
	do
		clear
		displayBoard
		checkWinningCells
		switchPlayer
	done
	displayBoard
	echo "Game Tie...."
}

#!Starting Game
playTillGameEnd

