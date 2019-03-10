extends Node

const PRESSED_BUTTON_OFFSET = 10

onready var audioButton = get_node("Audio Button")
onready var audioOnIcon = get_node("Audio Button/Audio On Icon")
onready var audioOffIcon = get_node("Audio Button/Audio Off Icon")
onready var homeButton = get_node("Home Button")

func _ready():
	# Register the necessary signal handlers
	audioButton.connect("pressed", self, "_on_audio_button_pressed")
	audioButton.connect("released", self, "_on_audio_button_released")
	homeButton.connect("pressed", self, "_on_home_button_pressed")
	homeButton.connect("released", self, "_on_home_button_released")

	# Initialize the UI
	refreshUI()
	
func _on_audio_button_pressed():
	GlobalHandler.pressButton(audioButton, PRESSED_BUTTON_OFFSET)

func _on_audio_button_released():
	GlobalHandler.releaseButton(audioButton, PRESSED_BUTTON_OFFSET)
	GlobalHandler.setAudioEnabled(!GlobalHandler.isAudioEnabled())
	
	refreshUI()

func _on_home_button_pressed():
	GlobalHandler.pressButton(homeButton, PRESSED_BUTTON_OFFSET)

func _on_home_button_released():
	GlobalHandler.releaseButton(homeButton, PRESSED_BUTTON_OFFSET)
	get_tree().change_scene("res://scenes/menu_scene.tscn")

func refreshUI():
	# Toggle which icon is shown on the audio button
	if GlobalHandler.isAudioEnabled():
		audioOnIcon.set_visible(true)
		audioOffIcon.set_visible(false)
	else:
		audioOnIcon.set_visible(false)
		audioOffIcon.set_visible(true)