extends Button

@onready var evidence_popup = $"../../Evidence Popup"

func _on_pressed() -> void:
	$"../../button click".play()
	evidence_popup.visible = true
