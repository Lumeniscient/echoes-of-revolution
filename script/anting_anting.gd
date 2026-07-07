extends Sprite2D

func _ready():
	var btn = $ClickArea
	btn.pressed.connect(_on_clicked)

func _on_clicked():
	$"clue sound".play()
	if not GameState.clues_collected["artifact"]:
		GameState.clues_collected["artifact"] = true
		GameState.artifact_found = true
		self.visible = false
		GameState.investigation_scene.show_artifact_popup()
