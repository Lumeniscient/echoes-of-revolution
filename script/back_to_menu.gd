extends Button

func _ready():
	self.pressed.connect(_on_pressed)

func _on_pressed():
	$"../button click".play()
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
