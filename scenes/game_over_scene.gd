extends Node

const PRESSED_BUTTON_OFFSET = 10

onready var retryButton = get_node("Retry Button")
onready var homeButton = get_node("Home Button")
onready var subscribeButton = get_node("Subscribe Button")
onready var infoButton = get_node("Info Button")
onready var scoreAlertLabel = get_node("Score Alert Label")
onready var scoreLabel = get_node("Score Label")
onready var highScoreAlertLabel = get_node("High Score Alert Label")
onready var highScoreLabel = get_node("High Score Label")

func _ready():
	# Calculate whether or not a new high score was achieved, persist it if
	# necessary, and update the UI to reflect it appropriately
	if ScoreHandler.checkForHighscore():
		scoreAlertLabel.text = "New High Score!"
		
		highScoreAlertLabel.visible = false
		highScoreLabel.visible = false
	else:
		scoreAlertLabel.text = "Good Game!"
		
		highScoreAlertLabel.visible = true
		highScoreLabel.visible = true
		highScoreLabel.text = (GlobalHandler.SCORE_LABEL_FORMAT % GlobalHandler.getSavedGlobal("highscore"))
		
	scoreLabel.text = (GlobalHandler.SCORE_LABEL_FORMAT % ScoreHandler.score)
	
	# Register the necessary signal handlers
	retryButton.connect("pressed", self, "_on_retry_button_pressed")
	retryButton.connect("released", self, "_on_retry_button_released")
	homeButton.connect("pressed", self, "_on_home_button_pressed")
	homeButton.connect("released", self, "_on_home_button_released")
	subscribeButton.connect("pressed", self, "_on_subscribe_button_pressed")
	subscribeButton.connect("released", self, "_on_subscribe_button_released")
	infoButton.connect("pressed", self, "_on_info_button_pressed")
	infoButton.connect("released", self, "_on_info_button_released")

func _on_retry_button_pressed():
	GlobalHandler.pressButton(retryButton, PRESSED_BUTTON_OFFSET)

func _on_retry_button_released():
	GlobalHandler.releaseButton(retryButton, PRESSED_BUTTON_OFFSET)
	
	# If it is time to show a full screen ad, do so and reset the time counter
	# between now and the next one; Otherwise, go back to the game scene for a
	# retry
	if GlobalHandler.isTimeForFullScreenAd():
		print("Displaying full screen ad...")
		
		# (TODO: Show a full screen ad.)
		
		GlobalHandler.resetPlaytimeSinceLastFullScreenAd()
	elif GlobalHandler.isTimeForSubscriptionOffer():
		print("Displaying subscription offer...")
		
		GlobalHandler.showSubscriptionOffer()
		GlobalHandler.resetPlaytimeSinceLastSubscriptionOffer()
	else:
		get_tree().change_scene("res://Scenes/game_scene.tscn")

func _on_home_button_pressed():
	GlobalHandler.pressButton(homeButton, PRESSED_BUTTON_OFFSET)

func _on_home_button_released():
	GlobalHandler.releaseButton(homeButton, PRESSED_BUTTON_OFFSET)
	get_tree().change_scene("res://Scenes/menu_scene.tscn")
	
func _on_subscribe_button_pressed():
	GlobalHandler.pressButton(subscribeButton, PRESSED_BUTTON_OFFSET)

func _on_subscribe_button_released():
	GlobalHandler.releaseButton(subscribeButton, PRESSED_BUTTON_OFFSET)
	GlobalHandler.showSubscriptionOffer()

func _on_info_button_pressed():
	GlobalHandler.pressButton(infoButton, PRESSED_BUTTON_OFFSET)

func _on_info_button_released():
	GlobalHandler.releaseButton(infoButton, PRESSED_BUTTON_OFFSET)