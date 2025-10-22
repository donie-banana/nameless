extends Node

var music_player: AudioStreamPlayer

func _ready():
	music_player = $AudioStreamPlayer
	music_player.volume_db = -10

func play_music(music_file: String, volume: float = -10):
	if music_player.playing and music_player.stream.get_path() == music_file:
		return
	
	var new_stream = load(music_file)
	if new_stream:
		music_player.stream = new_stream
		music_player.volume_db = volume
		#music_player.pitch_scale = 100 # ONLY FOR TESTING
		music_player.play()
		print("playing: ", music_file)
		print("length: ", new_stream.get_length(), " seconds")
	else:
		print("Error: Could not load music file: ", music_file)

func stop_music():
	if music_player.playing:
		music_player.stop()

func pause_music():
	if music_player.playing:
		music_player.pause()

func resume_music():
	if not music_player.playing and music_player.stream:
		music_player.play()
		
func is_playing():
	if music_player.playing:
		return true
	return false

func set_volume(volume: float):
	music_player.volume_db = volume
