extends Node

const DELTA_LIMIT = 0.5
const PRESSED_BUTTON_OFFSET = 20

var deltaTotal = 0
var isBannerAdDisplaying = false
var stage = 0
var currentPattern = [ ]
var playingPattern = false
var buttons
onready var blueButton = get_node("Blue Button")
onready var blueButtonParticles = get_node("Blue Button Particles")
onready var greenButton = get_node("Green Button")
onready var greenButtonParticles = get_node("Green Button Particles")
onready var redButton = get_node("Red Button")
onready var redButtonParticles = get_node("Red Button Particles")
onready var yellowButton = get_node("Yellow Button")
onready var yellowButtonParticles = get_node("Yellow Button Particles")
onready var scoreLabel = get_node("Score Label")
onready var stageLabel = get_node("Stage Label")
onready var timerLabel = get_node("Time Label")
onready var countdownTimer = Timer.new()


func _ready():
	# Seed the random number generator
	randomize()
	
	# Make sure that we are ready for a new game
	GlobalHandler.resetPlaytimeSinceLastBannerAd()
	ScoreHandler.resetScore()
	
	# Create an arbitrary list of the button objects
	# (NOTE: This will be used to randomly create patterns based on randomly
	#  selected indexes.)
	buttons = [blueButton, greenButton, redButton, yellowButton]
	
	# Connect signals for the button presses
	blueButton.connect("pressed", self, "_on_blue_button_pressed")
	blueButton.connect("released", self, "_on_blue_button_released")
	greenButton.connect("pressed", self, "_on_green_button_pressed")
	greenButton.connect("released", self, "_on_green_button_released")
	redButton.connect("pressed", self, "_on_red_button_pressed")
	redButton.connect("released", self, "_on_red_button_released")
	yellowButton.connect("pressed", self, "_on_yellow_button_pressed")
	yellowButton.connect("released", self, "_on_yellow_button_released")
	
	# Setup the timer
	# (NOTE: It will actually be started by the pattern refresh.)	
	countdownTimer.connect("timeout", self, "_on_timer_timeout")
	countdownTimer.set_one_shot(true)
	
	add_child(countdownTimer)
	
	# Build the initial pattern
	refreshPattern()
	
	# Initialize the UI
	refreshUI()

func _process(delta):
	# Add in the amount of time that has passed since the last process
	deltaTotal += delta
	
	# If it is time to process stuff...
	if deltaTotal >= DELTA_LIMIT:
		# Increment the known total playtime
		GlobalHandler.incrementPlaytime(deltaTotal)
		
		# Reset the count of time passed since last processing
		deltaTotal = 0
		
		# Refresh the UI
		refreshUI()
		
		# If it is time to display the banner ad, do so
		if not isBannerAdDisplaying and GlobalHandler.isTimeForBannerAd():
			print("Displaying banner ad...")
			
			# (TODO: Display the banner ad at the bottom of the screen.)
			
			isBannerAdDisplaying = true

func _on_blue_button_pressed():
	blueButtonParticles.restart()
	
	GlobalHandler.pressButton(blueButton, PRESSED_BUTTON_OFFSET)
	
	checkNextButtonInPattern(blueButton)

func _on_blue_button_released():
	GlobalHandler.releaseButton(blueButton, PRESSED_BUTTON_OFFSET)
	
func _on_green_button_pressed():
	greenButtonParticles.restart()
	
	GlobalHandler.pressButton(greenButton, PRESSED_BUTTON_OFFSET)
	
	checkNextButtonInPattern(greenButton)

func _on_green_button_released():
	GlobalHandler.releaseButton(greenButton, PRESSED_BUTTON_OFFSET)
	
func _on_red_button_pressed():
	redButtonParticles.restart()
	
	GlobalHandler.pressButton(redButton, PRESSED_BUTTON_OFFSET)
	
	checkNextButtonInPattern(redButton)

func _on_red_button_released():
	GlobalHandler.releaseButton(redButton, PRESSED_BUTTON_OFFSET)

func _on_yellow_button_pressed():
	yellowButtonParticles.restart()
	
	GlobalHandler.pressButton(yellowButton, PRESSED_BUTTON_OFFSET)
	
	checkNextButtonInPattern(yellowButton)

func _on_yellow_button_released():
	GlobalHandler.releaseButton(yellowButton, PRESSED_BUTTON_OFFSET)

func _on_timer_timeout():
	gameOver()
	
func playPattern():
	# Pause the timer and mark that the pattern is playing so that other calls
	# can know during yields
	countdownTimer.set_paused(true)
	playingPattern = true
	
	# Give the user time to look at the screen to watch the pattern
	yield(get_tree().create_timer(.5), "timeout")
	
	# Simulate pressing the buttons in the order prescribed by the current
	# pattern
	for button in currentPattern:
		var simulatedTouch = InputEventScreenTouch.new()
		
		simulatedTouch.set_index(0)
		simulatedTouch.set_position(button.position)
		simulatedTouch.set_pressed(true)
		
		yield(get_tree().create_timer(.5), "timeout")
		
		get_tree().input_event(simulatedTouch)
		
		yield(get_tree().create_timer(.5), "timeout")
		
		simulatedTouch.set_pressed(false)
		
		get_tree().input_event(simulatedTouch)
	
	# Unpause the timer and mark that the pattern is no longer is playing
	countdownTimer.set_paused(false)
	playingPattern = false

func refreshPattern():
	# Calculate the length of the pattern based on the current stage
	# (NOTE: This current calculation will increment the length of the pattern
	#  every three stages.)
	var length = (2 + floor(stage / 3))
	
	# Clear the currently-stored pattern
	currentPattern.clear()
	
	# Create a new pattern of the specified length
	for i in range(length):
		var buttonIndex = (randi() % buttons.size())
		currentPattern.append(buttons[buttonIndex])
	
	# Increment the stage number
	stage += 1
	
	# Play the pattern
	playPattern()
	
	# Reset the timer
	countdownTimer.set_wait_time(10)
	countdownTimer.start()

func refreshUI():
	# Refresh the Score label
	scoreLabel.text = (GlobalHandler.SCORE_LABEL_FORMAT % ScoreHandler.score)
	
	# Refresh the Stage label
	stageLabel.text = ("Stage " + str(stage))
	
	# Refresh the Timer label
	timerLabel.text = str(ceil(countdownTimer.time_left))

func checkNextButtonInPattern(button):
	# If the button press is from a human and not a simulation
	if playingPattern == false:
		# Check if the button was the correct one
		if currentPattern[0] == button:
			ScoreHandler.countCorrectButtonPress()
			currentPattern.remove(0)
		else:
			gameOver()
	
		# Check if the whole pattern has been pressed
		if currentPattern.size() == 0:
			ScoreHandler.countCorrectPattern()
			refreshPattern()

func gameOver():
	# Switch to the game over scene
	# (NOTE: High scores will be calculated and persisted if necessary in the
	#  game over scene.)
	get_tree().change_scene("res://Scenes/game_over_scene.tscn")