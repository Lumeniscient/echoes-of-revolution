extends Button

@onready var MemoryConflickClose = $".."

func _on_pressed() -> void:
	MemoryConflickClose.visible = false
