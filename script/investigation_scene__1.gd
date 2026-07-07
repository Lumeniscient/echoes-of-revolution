extends Control

@onready var clue_popup = $UI/CluePopup
@onready var artifact_popup = $UI/ArtifactPopup
@onready var witness_button = $"UI/Witness Button"
@onready var clue_count = $"UI/TopRight Panel/Clue Count"

func _ready():
	MusicManager.play_game()
	GameState.investigation_scene = self
	
	clue_popup.visible = false
	artifact_popup.visible = false
	witness_button.disabled = true
	clue_popup.visible = false
	artifact_popup.visible = false
	witness_button.disabled = true
	
	if GameState.clues_collected["document"]:
		$Items/Document.visible = false
	
	if GameState.clues_collected["bolo_sword"]:
		$"Items/Bolo sword".visible = false
	
	if GameState.clues_collected["letter"]:
		$Items/Letter.visible = false
	
	if GameState.clues_collected["artifact"]:
		$"Items/Anting-anting".visible = false
		
	_start_pulse_animations()
	
func _start_pulse_animations():
	if not GameState.clues_collected["document"]:
		$Items/Document/PulseAnim.play("pulse")
		
	if not GameState.clues_collected["bolo_sword"]:
		$"Items/Bolo sword/PulseAnim".play("pulse")
	
	if not GameState.clues_collected["letter"]:
		$Items/Letter/PulseAnim.play("pulse")
	
	if not GameState.clues_collected["artifact"]:
		$"Items/Anting-anting/PulseAnim".play("pulse")
	# Restore UI
	update_ui()
	check_all_clues()

@onready var doc_tex = $UI/CluePopup/DocumentTex
@onready var bolo_tex = $UI/CluePopup/BoloTex
@onready var letter_tex = $UI/CluePopup/LetterTex

func show_clue_popup(clue_key: String):
	doc_tex.visible = false
	bolo_tex.visible = false
	letter_tex.visible = false
	
	match clue_key:
		"document":
			doc_tex.visible = true
		"bolo_sword":
			bolo_tex.visible = true
		"letter":
			letter_tex.visible = true
	
	clue_popup.visible = true
	update_ui()
	check_all_clues()

func show_artifact_popup():
	artifact_popup.visible = true
	check_all_clues()

func update_ui():
	clue_count.text = "Clues Found: " + \
	str(GameState.clues_found_count) + " / 3"

func check_all_clues():
	if GameState.clues_found_count >= 3 \
	and GameState.artifact_found:
		witness_button.disabled = false

func _on_close_button_pressed():
	$"button click".play()
	clue_popup.visible = false

func _on_close_artifact_pressed():
	$"button click".play()
	artifact_popup.visible = false

func _on_witness_button_pressed():
	$"button click".play()
	get_tree().change_scene_to_file(
		"res://scenes/witness_interview.tscn")
