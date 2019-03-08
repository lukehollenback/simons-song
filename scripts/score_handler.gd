extends Node

const CORRECT_BUTTON_SCORE = 9
const CORRECT_PATTERN_SCORE = 39

var score = 0
var multiplier = 1

func resetScore():
	score = 0;

func checkForHighscore():
	if score > GlobalHandler.getSavedGlobal("highscore"):
		GlobalHandler.setSavedGlobal("highscore", score)
		GlobalHandler.saveGame()
		
		return true
		
	return false

func countCorrectButtonPress():
	recalculateMultiplier()
	score += (CORRECT_BUTTON_SCORE * multiplier)

func countCorrectPattern():
	recalculateMultiplier()
	score += (CORRECT_PATTERN_SCORE * multiplier)

func recalculateMultiplier():
	if GlobalHandler.isDoublePointsEnabled():
		multiplier = 2
	else:
		multiplier = 1