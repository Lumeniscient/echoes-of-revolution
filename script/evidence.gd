extends Button

@onready var evidence_popup = $"../../Evidence Popup"

func _on_pressed() -> void:
	evidence_popup.visible = true
