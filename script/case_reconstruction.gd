extends Control

var my_button_group = ButtonGroup.new()
var selected_answer = ""

@onready var submit_btn = $SubmitAnswer
@onready var back_btn = $BacktoWitness


func _ready():
	var button_a = $"Button A"
	var button_b = $"Button B"
	var button_c = $"Button C"
	
	button_a.toggle_mode = true
	button_b.toggle_mode = true
	button_c.toggle_mode = true
	
	button_a.button_group = my_button_group
	button_b.button_group = my_button_group
	button_c.button_group = my_button_group
	
	button_a.toggled.connect(
		func(pressed): if pressed: _on_answer_selected("A"))
	button_b.toggled.connect(
		func(pressed): if pressed: _on_answer_selected("B"))
	button_c.toggled.connect(
		func(pressed): if pressed: _on_answer_selected("C"))
		
	back_btn.pressed.connect(func():
		$"button click".play()
		get_tree().change_scene_to_file("res://scenes/witness_interview.tscn"))
	
	submit_btn.pressed.connect(_on_submit_pressed)
	
	submit_btn.disabled = true

func _on_answer_selected(answer: String):
	selected_answer = answer
	submit_btn.disabled = false
	print("Selected: " + answer)

func _on_submit_pressed():
	$"button click".play()
	if selected_answer == "":
		return
	
	GameState.player_answer = selected_answer
	
	match selected_answer:
		"A":
			GameState.case_solved = false
			GameState.accuracy = 25
		"B":
			GameState.case_solved = false
			GameState.accuracy = 75
		"C":
			GameState.case_solved = true
			GameState.accuracy = 100
			
	get_tree().change_scene_to_file(
		"res://scenes/case_closed.tscn"
	)
