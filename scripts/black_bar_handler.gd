extends Node

var blackBarImage = preload("res://sprites/white.png")

func _ready():
	var blackBarImageRID = blackBarImage.get_rid()
	
	VisualServer.black_bars_set_images(blackBarImageRID, blackBarImageRID, blackBarImageRID, blackBarImageRID)
