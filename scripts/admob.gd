extends Node2D

var admob = null
var isReal = false
var isTop = false
var adBannerId = "ca-app-pub-3940256099942544/6300978111" # [Replace with your Ad Unit ID and delete this message.]

func _ready():
	if(Globals.has_singleton("AdMob")):
		admob = Globals.get_singleton("AdMob")
		admob.init(isReal, get_instance_ID())
		admob.loadBanner(adBannerId, isTop)
	
	get_tree().connect("screen_resized", self, "on_resize")

func _on_admob_network_error():
	print("Network Error")

func _on_admob_ad_loaded():
	print("Ad loaded success")

# resize
func on_resize():
	if admob != null:
		admob.resize()
