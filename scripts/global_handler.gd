extends Node

const DEVELOPER_URL = "https://appstore.com/LukeHollenback"
const APP_URL = ""
const SAVE_FILE = "user://game.save"
const SCORE_LABEL_FORMAT = "%05d"
const PRE_AD_PLAYTIME = 120
const AD_FREE_PLAYTIME = 30
const AD_BANNER_FREE_PLAYTIME = 7
const TIME_BETWEEN_SUBSCRIPTION_OFFERS = 120

var playtimeSinceLastFullScreenAd = 0.0
var playtimeSinceLastBannerAd = 0.0
var playtimeSinceLastSubscriptionOffer = 0.0
var hasSubscribed = false

var savedGlobals = {
		"highscore" : 0,
		"playtime" : 0.0
	}

func _ready():
	# Load saved game details
	loadGame()
	
	# (TODO: Load in-app purchases from Apple.)

func saveGame():
	var file = File.new()
	
	file.open(SAVE_FILE, File.WRITE)
	file.store_line(to_json(savedGlobals))
	file.close()

func loadGame():
	var file = File.new()
	
	if not file.file_exists(SAVE_FILE):
		return
	
	file.open(SAVE_FILE, File.READ)
	
	var loadedSavedGlobals = parse_json(file.get_line())
	
	for k in savedGlobals.keys():
		if not loadedSavedGlobals.has(k):
			loadedSavedGlobals[k] = savedGlobals[k]
	
	savedGlobals = loadedSavedGlobals
	
	file.close()

func setSavedGlobal(key, value):
	savedGlobals[key] = value

func getSavedGlobal(key):
	return savedGlobals[key]
	
func incrementPlaytime(amount):
	savedGlobals["playtime"] += amount
	playtimeSinceLastFullScreenAd += amount
	playtimeSinceLastBannerAd += amount
	playtimeSinceLastSubscriptionOffer += amount
	
	saveGame()

func resetPlaytimeSinceLastFullScreenAd():
	playtimeSinceLastFullScreenAd = 0.0

func resetPlaytimeSinceLastBannerAd():
	playtimeSinceLastBannerAd = 0.0

func resetPlaytimeSinceLastSubscriptionOffer():
	playtimeSinceLastSubscriptionOffer = 0.0

func getPlaytime():
	return savedGlobals["playtime"]


func isTimeForBannerAd():
	if getPlaytime() > PRE_AD_PLAYTIME and playtimeSinceLastBannerAd > AD_BANNER_FREE_PLAYTIME:
		return true
	
	return false

func isTimeForFullScreenAd():
	if getPlaytime() > PRE_AD_PLAYTIME and playtimeSinceLastFullScreenAd > AD_FREE_PLAYTIME:
		return true
	
func isTimeForSubscriptionOffer():
	if getPlaytime() > PRE_AD_PLAYTIME and not hasSubscribed and playtimeSinceLastSubscriptionOffer > TIME_BETWEEN_SUBSCRIPTION_OFFERS:
		return true
	
	return false

func showSubscriptionOffer():
	# (TODO: Show the in-app-purchase offer for a subscription to an ad-free
	#  experience if the user has not yet subscribed.)