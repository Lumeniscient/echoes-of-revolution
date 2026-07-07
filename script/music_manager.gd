extends Node

@onready var menu_music = $MenuMusic
@onready var game_music = $GameMusic

func play_menu():
	if game_music.playing:
		game_music.stop()

	if !menu_music.playing:
		menu_music.play()

func play_game():
	if menu_music.playing:
		menu_music.stop()

	if !game_music.playing:
		game_music.play()
