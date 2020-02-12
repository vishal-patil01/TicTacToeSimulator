#!/bin/bash 
echo "Welcome To TicTacToe Simulator"

#!Initializing variable 
declare -a gameBoard

#!Initializing Constants
BOARD_SIZE=3
TOTAL_MOVES=$((BOARD_SIZE * BOARD_SIZE))

#!Resetting Game Board By Initilizing Array With Default Value
function resetBoard() {
	gameBoard=(1 2 3 4 5 6 7 8 9)
	displayBoard
}
#!Displaying GameBoard
function displayBoard() {
	clear
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
	[ $currentPlayer == $player ] && computerTurn || playerTurn
}
#!User play Function
function  playerTurn() {
	currentPlayer=$player
	[ ${FUNCNAME[1]} == switchPlayer ] && echo "Player Turn Sign is $player" 
	read -p "Enter Position Between 1 to 9 : " position
	if [[ $position -ge 1 && $position -le 9 && $position != ' ' ]]
	then
		isCellEmpty $position $player
		checkWinningCells
	else
		echo "Please Enter Value "
		playerTurn
	fi
}
#!Computer play Function
function  computerTurn() {
	currentPlayer=$computer
	checkWinningCells $computer
	[ $? == 0 ] && checkWinningCells $player
	[ $? == 0 ] && takeProperPosition 0
	[ $? == 0 ] && takeProperPosition 1
	displayBoard
}
#!checking Position is already filled or blank
function isCellEmpty() {
	local position=$1-1 sign=$2
	if [[ $position != X && $position != O ]]
	then
		gameBoard[$position]=$sign
		((playerMoves++))
	else
		[ ${FUNCNAME[1]} == "playerTurn" ] &&  echo "Position is Occupied"
		${FUNCNAME[1]}
	fi
}
#!checking Rows,Columns and Diagonals for Winning & blocking
function checkWinningCells() {
	[ ${FUNCNAME[1]} == "playerTurn" ] &&  command=checkWinner || command=computerMoves; sign=$1;
	col=0
	for((row=0;row<7;row+=3))
	do
		[ $?==0 ] && $command $row $((row+1)) $((row+2)) || return 1
		[ $?==0 ] && $command $col $((col+3)) $((col+6)) || return 1
		((col++))
	done
		[ $?==0 ] && $command 0 $((BOARD_SIZE+1)) $((TOTAL_MOVES-1)) || return 1 
		[ $?==0 ] && $command $((BOARD_SIZE-1)) $((BOARD_SIZE+1))  $((TOTAL_MOVES - BOARD_SIZE))  || return 1
}
#!checking Winner
function checkWinner() {
	local cell1=$1 cell2=$2 cell3=$3
	if [ ${gameBoard[$cell1]} == ${gameBoard[$cell2]} ] && [ ${gameBoard[$cell2]} == ${gameBoard[$cell3]} ]
	then
		[ ${gameBoard[$cell1]} == $player ] && winner=player || winner=computer
		displayBoard
		echo "$winner Win and Have Sign ${gameBoard[$cell1]}"
		exit
	fi
}
#!Computer Logic For Self Winning And Blocking Opponent
function computerMoves() {
	local cell1=$1 cell2=$2 cell3=$3 
	for((i=0;i<3;i++))
	do
		if [ ${gameBoard[$cell1]} == ${gameBoard[$cell2]} ] && [ ${gameBoard[$cell1]} == $sign ] && [[ ${gameBoard[$cell3]} == *[[:digit:]]* ]] 
		then
			gameBoard[$cell3]=$computer
			checkWinner $cell1 $cell2 $cell3
			((playerMoves++))
			return 1
		else
			eval $(echo cell1=$cell2\;cell2=$cell3\;cell3=$cell1)
		fi
	done
}
#!set Mark On Corner or Center or Side if position is vacant
function takeProperPosition() {
	local startValue=$1
	for((i=$startValue;i<9;i+=2))
	do
		if [[ ${gameBoard[$i]} == [[:digit:]] && $i != 4 ]] 
		then
			gameBoard[$i]=$computer
			((playerMoves++))
			return 1
		fi
	done
	if [[ ${gameBoard[((TOTAL_Moves / 2 + 1))]} == [[:digit:]]  ]]
		then
			gameBoard[$i]=$computer
			((playerMoves++))
			return 1
		fi
}
#!Run Game By Reseting Board and Run Untill Game Ends And Switching PlayerSign After Winning Check Using Ternary Operator
function playTillGameEnd() {
	resetBoard
	tossForPlay
	while [ $playerMoves -lt $TOTAL_MOVES ]
	do
		switchPlayer
	done
	displayBoard
	echo "Game Tie...."
}
#!Starting Game
playTillGameEnd

