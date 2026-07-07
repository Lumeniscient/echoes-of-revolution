extends Sprite2D

func _ready():
	var btn = $ClickArea
	btn.pressed.connect(_on_clicked)

func _on_clicked():
	$"clue sound".play()
	if not GameState.clues_collected["letter"]:
		GameState.clues_collected["letter"] = true
		GameState.clues_found_count += 1
		self.visible = false
		GameState.investigation_scene.show_clue_popup("letter")
