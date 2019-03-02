extends Node

const PRESSED_BUTTON_OFFSET = 10

onready var playButton = get_node("Play Button")
onready var moreButton = get_node("More Button")
onready var subscribeButton = get_node("Subscribe Button")
onready var infoButton = get_node("Info Button")

func _ready():
	# Register the necessary signal handlers
	playButton.connect("pressed", self, "_on_play_button_pressed")
	playButton.connect("released", self, "_on_play_button_released")
	moreButton.connect("pressed", self, "_on_more_button_pressed")
	moreButton.connect("released", self, "_on_more_button_released")
	subscribeButton.connect("pressed", self, "_on_subscribe_button_pressed")
	subscribeButton.connect("released", self, "_on_subscribe_button_released")
	infoButton.connect("pressed", self, "_on_info_button_pressed")
	infoButton.connect("released", self, "_on_info_button_released")

func _on_play_button_pressed():
	# "Press" the button
	playButton.position.y += PRESSED_BUTTON_OFFSET

func _on_play_button_released():
	# "Un-Press" the button
	playButton.position.y -= PRESSED_BUTTON_OFFSET
	
	# Go to the game scene
	get_tree().change_scene("res://Scenes/game_scene.tscn")

func _on_more_button_pressed():
	# "Press" the button
	moreButton.position.y += PRESSED_BUTTON_OFFSET

func _on_more_button_released():
	# "Un-Press" the button
	moreButton.position.y -= PRESSED_BUTTON_OFFSET
	
	# Open the developer page to show more apps to download
	OS.shell_open(GlobalHandler.DEVELOPER_URL)
	
func _on_subscribe_button_pressed():
	# "Press" the button
	subscribeButton.position.y += PRESSED_BUTTON_OFFSET

func _on_subscribe_button_released():
	# "Un-Press" the button
	subscribeButton.position.y -= PRESSED_BUTTON_OFFSET
	
	# Trigger the in-app-purchase dialog if necessary
	GlobalHandler.showSubscriptionOffer()

func _on_info_button_pressed():
	# "Press" the button
	infoButton.position.y += PRESSED_BUTTON_OFFSET

func _on_info_button_released():
	# "Un-Press" the button
	infoButton.position.y -= PRESSED_BUTTON_OFFSET