extends Node

const CORRECT_BUTTON_SCORE = 9
const CORRECT_PATTERN_SCORE = 39

var score = 0

func resetScore():
	score = 0;

func checkForHighscore():
	if score > GlobalHandler.getSavedGlobal("highscore"):
		GlobalHandler.setSavedGlobal("highscore", score)
		GlobalHandler.saveGame()
		
		return true
		
	return false

func countCorrectButtonPress():
	score += CORRECT_BUTTON_SCORE

func countCorrectPattern():
	score += CORRECT_PATTERN_SCORE