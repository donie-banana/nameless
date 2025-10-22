extends Node

var bg_range: int = 4

var x: float = 0.0
var time: float = 1.0

var just_played: int = -1

func play_random() -> void:
	var next: int = just_played
	
	while next == just_played:
		next = hlpr.rng.randi_range(1, bg_range)

	print("next: " + str(next))
	
	MusicPlayer.play_music("res://sfx/music/bg/" + str(next) + ".mp3")
	just_played = next


func _ready() -> void:
	play_random()


func _process(delta: float) -> void:
	x += delta

	if x >= 1:
		print("is playing bg music?: " + str(MusicPlayer.is_playing()))
		print("just_played: " + str(just_played))
		x -= 1

	if !MusicPlayer.is_playing():
		play_random()
