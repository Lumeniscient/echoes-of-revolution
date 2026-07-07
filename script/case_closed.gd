extends Control

@onready var summary = $Summary
@onready var answer_title = $AnswerTitle
@onready var completion_rating = $CompletionRating

func _ready():
	completion_rating.text = str(GameState.accuracy) + "%"
	
	match GameState.player_answer:
		"A":
			_show_answer_a()
		"B":
			_show_answer_b()
		"C":
			_show_answer_c()

func _show_answer_a():
	answer_title.text = "INCORRECT"
	summary.text = """Your conclusion was historically inaccurate. Papa Isio was not simply a bandit. He held the official rank of Colonel and served as Politico-Military Governor of Negros under the Philippine Republic — a recognized legitimate leader, not a criminal. The "bandit" label was invented by wealthy landowners and American colonial authorities who feared his movement. Calling him a bandit ignores his official government rank, his role as a spiritual leader, and the genuine injustices that drove thousands of farmers to follow him. History is more complex than those in power would have us believe."""

func _show_answer_b():
	answer_title.text = "PARTIALLY CORRECT"
	summary.text = """You are close — but history tells a more complete story. Papa Isio was indeed a freedom fighter who defended the poor. He held the rank of Colonel under the Philippine Republic and led the Babaylanes movement against both Spanish and American colonial rule. The farmers who followed him experienced real injustice under the hacienda system. However, his methods were controversial even among his allies. He targeted not only colonial forces but also local landowners who cooperated with colonialism — actions that some Filipinos saw as necessary resistance and others saw as destructive raids. The full truth requires holding both realities at once."""

func _show_answer_c():
	answer_title.text = "THE TRUTH PRESERVED"
	summary.text = """Well done, Archivist. Your conclusion matches what historians have found. Papa Isio — Dionisio Magbuelas — was born in 1846 in Negros. He led the Babaylanes movement, blending old Filipino spiritual beliefs with the fight against colonial rule. To the landowners and authorities, he was a bandit and a criminal. To the farmers and the poor, he was a rebel and a protector. To history, he was all of these things at once. He was the last Filipino revolutionary leader to surrender — on August 6, 1907. He died in Bilibid Prison in Manila in 1911, largely forgotten. Until now."""
