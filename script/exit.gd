extends Button


func _on_pressed() -> void:
	$"../../button click".play()
	get_tree().quit()
