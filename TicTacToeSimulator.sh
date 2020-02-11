#!/bin/bash 
echo "Welcome To TicTacToe Simulator "

#!Initializing variable 
declare -a gameBoard

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
	playerTurn=1
	[ ${FUNCNAME[1]} == switchPlayer ] && echo "Player Turn Sign is $player" 
	read -p "Enter Position Between 1 to 9 : " position
	if [[ $position -ge 1 && $position -le 9  && $position != ' ' ]]
	then
		isCellEmpty $position $player
		checkWinningCells
	else
		echo "Please Enter Value "
		playerTurn
	fi
}

#!User play Function
function  computerTurn() {
	playerTurn=0
	flag=0
	checkWinningCells $computer
	[ $flag == 0  ] && isCellEmpty $((RANDOM % 9)) $computer
}

#!checking Position is already filled or blank
function isCellEmpty() {
	local position=$1-1 sign=$2
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
	[ ${FUNCNAME[1]} == "playerTurn" ] &&  command=checkWinner || command=aI; sign=$1;
	col=0
	for((row=0;row<7;row+=3))
	do
		[ $flag==0 ] && $command $row $((row+1)) $((row+2)) 
		[ $flag==0 ] && $command $col $((col+3)) $((col+6)) 
		((col++))
	done
		[ $flag==0 ] && $command 0 4 8 
		[ $flag==0 ] && $command 2 4 6 
}

#!checking Winner
function checkWinner() {
	local cell1=$1 cell2=$2 cell3=$3
	if [ ${gameBoard[$cell1]} == ${gameBoard[$cell2]} ] && [ ${gameBoard[$cell2]} == ${gameBoard[$cell3]} ]
	then
		[ ${gameBoard[$cell1]} == $player ] && winner=player || winner=computer
		echo "$winner Win and Have Sign ${gameBoard[$cell1]}"
		displayBoard
		exit
	fi
}

#!Computer Logic Trying To Win
function aI() {
	local cell1=$1 cell2=$2 cell3=$3 
	for((i=0;i<3;i++))
	do
		if [ ${gameBoard[$cell1]} == ${gameBoard[$cell2]} ] && [ ${gameBoard[$cell1]} == $sign ] && [[ ${gameBoard[$cell3]} == *[[:digit:]]* ]] 
		then
			gameBoard[$cell3]=$computer
			checkWinner $cell1 $cell2 $cell3
			flag=1
			((playerMoves++))
			break
		else
			eval $(echo cell1=$cell2\;cell2=$cell3\;cell3=$cell1)
		fi
	done
}

#!Run Game By Reseting Board and Run Untill Game Ends And Switching PlayerSign After Winning Check Using Ternary Operator
function playTillGameEnd() {
	resetBoard
	tossForPlay
	while [ $playerMoves -lt $TOTAL_MOVES ]
	do
		clear
		displayBoard
		switchPlayer
	done
	displayBoard
	echo "Game Tie...."
}

#!Starting Game
playTillGameEnd

