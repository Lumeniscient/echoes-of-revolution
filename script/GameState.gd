extends Node
var investigation_scene = null
var clues_collected = {
	"document": false,
	"bolo_sword": false,
	"letter": false,
	"artifact": false
}
var clues_found_count = 0
var artifact_found = false

var current_witness = "aurelio"
var witnesses_interviewed = {
	"aurelio": false,
	"carding": false
}
var questions_asked = {
	"q1_aurelio": false,
	"q1_carding": false,
	"q2_aurelio": false,
	"q2_carding": false
}
var aurelio_chat_history = []
var carding_chat_history = []

var conflicts_detected = []

var player_answer = ""
var case_solved = false
var accuracy = 0

func reset():
	clues_collected = {
		"document": false,
		"bolo_sword": false,
		"letter": false,
		"artifact": false
	}
	clues_found_count = 0
	artifact_found = false
	current_witness = "aurelio"
	witnesses_interviewed = {
		"aurelio": false,
		"carding": false
	}
	questions_asked = {
		"q1_aurelio": false,
		"q1_carding": false,
		"q2_aurelio": false,
		"q2_carding": false
	}
	aurelio_chat_history = []
	carding_chat_history = []
	conflicts_detected = []
	player_answer = ""
	case_solved = false
	accuracy = 0
