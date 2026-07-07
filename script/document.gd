extends Sprite2D

func _ready():
	var btn = $ClickArea
	btn.pressed.connect(_on_clicked)

func _on_clicked():
	$"clue sound".play()
	if not GameState.clues_collected["document"]:
		GameState.clues_collected["document"] = true
		GameState.clues_found_count += 1
		self.visible = false
		# Use GameState reference instead
		GameState.investigation_scene.show_clue_popup("document")
