extends Node

const SAVE_FILE = "user://game.save"
const SCORE_LABEL_FORMAT = "%05d"
const PRE_AD_PLAYTIME = 120
const AD_FREE_PLAYTIME = 30
const AD_BANNER_FREE_PLAYTIME = 7

var playtimeSinceLastFullScreenAd = 0.0
var playtimeSinceLastBannerAd = 0.0

var savedGlobals = {
		"highscore" : 0,
		"playtime" : 0.0
	}

func _ready():
	loadGame()

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
	
	saveGame()

func resetPlaytimeSinceLastFullScreenAd():
	playtimeSinceLastFullScreenAd = 0.0

func resetPlaytimeSinceLastBannerAd():
	playtimeSinceLastBannerAd = 0.0

func getPlaytime():
	return savedGlobals["playtime"]


func isTimeForBannerAd():
	if getPlaytime() > PRE_AD_PLAYTIME and playtimeSinceLastBannerAd > AD_BANNER_FREE_PLAYTIME:
		return true
	
	return false

func isTimeForFullScreenAd():
	if getPlaytime() > PRE_AD_PLAYTIME and playtimeSinceLastFullScreenAd > AD_FREE_PLAYTIME:
		return true
	
	return false