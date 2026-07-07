extends Control

const API_KEY = "AQ.Ab8RN6KDnV7L1aRanz-CsrqtQWBEtNbbpATEtiRWXJ2NNSTGhQ"
const API_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-3.1-flash-lite:generateContent?key=" + API_KEY

@onready var portrait = $Portrait
@onready var witness_name = $UI/"Witness name"
@onready var witness_intro = $UI/"Witness Intro"
@onready var rich_text = $UI/RichTextLabel
@onready var line_edit = $UI/LineEdit
@onready var q1_btn = $UI/Q1
@onready var q2_btn = $UI/Q2
@onready var don_aurelio_icon = $"Don Aurelio Icon"
@onready var carding_icon = $"Carding Icon"
@onready var back_btn = $HBoxContainer/Back
@onready var case_reconstruction_btn = $HBoxContainer/"Case reconstruction"
@onready var memory_conflict_popup = $MemoryConflictPopup

const AURELIO_SYSTEM_PROMPT = """You are Don Aurelio Santos, a wealthy 
Filipino hacendero landowner in Negros Island Philippines 1898. 
Your family has owned haciendas for three generations.
You believe Papa Isio was a dangerous criminal and bandit 
who used revolution as an excuse to raid honest landowners.
You are stern, formal, and defensive.
You speak with authority and contempt toward Papa Isio.
Only discuss events in Negros 1898.
Do not discuss modern topics.
Keep responses under 4 sentences.
If asked unrelated questions politely decline."""

const CARDING_SYSTEM_PROMPT = """You are Carding Malinao, a poor Filipino 
tenant farmer from Negros Island Philippines 1898. 
You joined Papa Isio's Babaylanes movement and witnessed 
his leadership firsthand.
You believe Papa Isio was a protector of the poor 
and a freedom fighter against colonial oppression.
You are humble, sincere, and passionate.
You speak simply but with deep conviction.
Only discuss events in Negros 1898.
Do not discuss modern topics.
Keep responses under 4 sentences.
If asked unrelated questions politely decline."""

const AURELIO_INTRO = "I am Don Aurelio Santos. My family has owned haciendas in Negros for three generations. I know exactly what happened here and I know exactly what Papa Isio really was. Ask your questions. But do not expect me to sugarcoat the truth."

const CARDING_INTRO = "I am Carding Malinao. I worked the fields of Negros my whole life until Papa Isio showed us another way. They call him a bandit. I call him the only man who ever spoke for us."

const AURELIO_FALLBACKS = [
	"Papa Isio was nothing more than a common criminal hiding behind the revolution.",
	"His men burned our estates and destroyed everything we built.",
	"I was part of the landed gentry of Negros. I know exactly who Papa Isio was."
]

const CARDING_FALLBACKS = [
	"Papa Isio spoke for those of us who had no voice.",
	"We took back what was stolen from us. That is not banditry.",
	"I saw what he did for people like me. He was our protector."
]

var is_waiting = false
var http_request: HTTPRequest
var fallback_index_aurelio = 0
var fallback_index_carding = 0


func _ready():
	http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(_on_request_completed)
	memory_conflict_popup.visible = false
	
	don_aurelio_icon.pressed.connect(_on_aurelio_selected)
	carding_icon.pressed.connect(_on_carding_selected)
	q1_btn.pressed.connect(_on_q1_pressed)
	q2_btn.pressed.connect(_on_q2_pressed)
	line_edit.text_submitted.connect(_on_custom_question)
	back_btn.pressed.connect(_on_back_pressed)
	case_reconstruction_btn.pressed.connect(
		_on_case_reconstruction_pressed)
	
	_on_aurelio_selected()

func _on_aurelio_selected():
	GameState.current_witness = "aurelio"
	portrait.texture = preload(
		"res://assets/case 001/Don Aurelio.png")
	witness_name.text = "Don Aurelio Santos"
	witness_intro.text = AURELIO_INTRO
	rich_text.text = "Select a question above to hear the witness respond..."
	
	GameState.witnesses_interviewed["aurelio"] = true

func _on_carding_selected():
	GameState.current_witness = "carding"
	portrait.texture = preload(
		"res://assets/case 001/Carding.png")
	witness_name.text = "Carding Malinao"
	witness_intro.text = CARDING_INTRO
	rich_text.text = "Select a question above to hear the witness respond..."
	
	GameState.witnesses_interviewed["carding"] = true

func _on_q1_pressed():
	$"button click".play()
	if is_waiting:
		return
	var question = "What do you know about Papa Isio?"
	
	if GameState.current_witness == "aurelio":
		GameState.questions_asked["q1_aurelio"] = true
	else:
		GameState.questions_asked["q1_carding"] = true
	
	send_to_gemini(question)

func _on_q2_pressed():
	$"button click".play()
	if is_waiting:
		return
	var question = "Who do you think Papa Isio really was?"
	
	if GameState.current_witness == "aurelio":
		GameState.questions_asked["q2_aurelio"] = true
	else:
		GameState.questions_asked["q2_carding"] = true
	
	send_to_gemini(question)

func _on_custom_question(text: String):
	if is_waiting or text.strip_edges() == "":
		return
	line_edit.clear()
	send_to_gemini(text)

func send_to_gemini(question: String):
	is_waiting = true
	rich_text.text = "Thinking..."
	
	var system_prompt = AURELIO_SYSTEM_PROMPT
	if GameState.current_witness == "carding":
		system_prompt = CARDING_SYSTEM_PROMPT
	
	var clue_context = "\n\nThe investigator has found these clues:"
	
	if GameState.clues_collected["document"]:
		clue_context += """
    - A Hacienda Land Contract (1890s):
      Shows farmers gave 50% of harvest,
      families evicted if they couldn't pay,
	  signed by Spanish colonial authorities"""

	if GameState.clues_collected["bolo_sword"]:
		clue_context += """
    - A Babaylan Bolo sword:
      Worn and battle-used,
      believed to be blessed with
	  anting-anting protection"""

	if GameState.clues_collected["letter"]:
		clue_context += """
    - A Farmer's Testimony letter:
      Written by tenant farmer from
      Himamaylan, calls Papa Isio
	  a protector and spiritual leader"""

	if GameState.clues_collected["artifact"]: 
		clue_context += """
    - A Babaylan Anting-anting amulet:
      Sacred amulet from Papa Isio's
      Babaylanes movement,
	  used in indigenous spiritual rituals"""
	clue_context += "\n\nRespond naturally referencing these clues if relevant to the question."

	system_prompt += clue_context
	
	var body = JSON.stringify({
		"system_instruction": {
			"parts": [{"text": system_prompt}]
		},
		"contents": [
			{
				"role": "user",
				"parts": [{"text": question}]
			}
		],
		"generationConfig": {
			"maxOutputTokens": 200
		}
	})
	
	var headers = ["Content-Type: application/json"]
	var error = http_request.request(
		API_URL, headers,
		HTTPClient.METHOD_POST, body)
	
	if error != OK:
		use_fallback()
	
	http_request.request(
	API_URL, 
	["Content-Type: application/json"],
	HTTPClient.METHOD_POST, 
	body)
	
	if error != OK:
		use_fallback()

func _on_request_completed(result, response_code, _headers, body):
	is_waiting = false
	
	if result != HTTPRequest.RESULT_SUCCESS \
	or response_code != 200:
		use_fallback()
		return
	
	var json = JSON.parse_string(
		body.get_string_from_utf8())
	
	if json == null or not json.has("candidates"):
		use_fallback()
		return
	
	var reply = json["candidates"][0]["content"]["parts"][0]["text"]
	
	typewriter(reply)

func typewriter(text: String):
	rich_text.text = ""
	for i in text.length():
		rich_text.text += text[i]
		await get_tree().create_timer(0.03).timeout
	
	check_memory_conflict()

func use_fallback():
	var fallbacks = AURELIO_FALLBACKS
	var index = fallback_index_aurelio
	
	if GameState.current_witness == "carding":
		fallbacks = CARDING_FALLBACKS
		index = fallback_index_carding
	
	var reply = fallbacks[index % fallbacks.size()]
	
	if GameState.current_witness == "aurelio":
		fallback_index_aurelio += 1
	else:
		fallback_index_carding += 1
	
	typewriter(reply)

func _on_back_pressed():
	$"button click".play()
	get_tree().change_scene_to_file("res://scenes/investigation_scene_ 1.tscn")

func _on_case_reconstruction_pressed():
	$"button click".play()
	get_tree().change_scene_to_file("res://scenes/case_reconstruction.tscn")

func check_memory_conflict():
	if GameState.questions_asked["q1_aurelio"] and \
	GameState.questions_asked["q1_carding"]:
		if not "q1" in GameState.conflicts_detected:
			GameState.conflicts_detected.append("q1")
			memory_conflict_popup.visible = true
			return
	
	if GameState.questions_asked["q2_aurelio"] and \
	GameState.questions_asked["q2_carding"]:
		if not "q2" in GameState.conflicts_detected:
			GameState.conflicts_detected.append("q2")
			memory_conflict_popup.visible = true
			return
