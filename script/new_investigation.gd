extends Button

func _on_pressed():
	$"../../button click".play()
	GameState.reset()
	get_tree().change_scene_to_file("res://scenes/case_selection.tscn")
	
