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
	GlobalHandler.pressButton(playButton, PRESSED_BUTTON_OFFSET)

func _on_play_button_released():
	GlobalHandler.releaseButton(playButton, PRESSED_BUTTON_OFFSET)
	get_tree().change_scene("res://scenes/game_scene.tscn")

func _on_more_button_pressed():
	GlobalHandler.pressButton(moreButton, PRESSED_BUTTON_OFFSET)

func _on_more_button_released():
	GlobalHandler.releaseButton(moreButton, PRESSED_BUTTON_OFFSET)
	OS.shell_open(GlobalHandler.DEVELOPER_URL)
	
func _on_subscribe_button_pressed():
	GlobalHandler.pressButton(subscribeButton, PRESSED_BUTTON_OFFSET)

func _on_subscribe_button_released():
	GlobalHandler.releaseButton(subscribeButton, PRESSED_BUTTON_OFFSET)
	GlobalHandler.showPurchaseOffer()

func _on_info_button_pressed():
	GlobalHandler.pressButton(infoButton, PRESSED_BUTTON_OFFSET)

func _on_info_button_released():
	GlobalHandler.releaseButton(infoButton, PRESSED_BUTTON_OFFSET)
	get_tree().change_scene("res://scenes/about_scene.tscn")