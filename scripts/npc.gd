extends Node2D

@export var npc_name: String = "Elder"

@onready var interactive_area: Area2D = $InteractiveArea
var player_nearby: bool = false

func _process(_delta: float) -> void:
	if player_nearby and Input.is_action_just_pressed("interact"):
		interact()

func interact() -> void:
	var dialogue_ui = get_tree().get_first_node_in_group("dialogue_ui")
	if dialogue_ui == null or dialogue_ui.is_open:
		return

	var dialogues: Array[String] = []
	match QuestManager.quest_state:
		QuestManager.QuestState.NOT_STARTED:
			dialogues = [
				"Greetings, traveler.",
				"The guards have scattered our sacred crystals across this place.",
				"Please, bring me %d crystals back." % QuestManager.required_crystals
			]
			QuestManager.start_quest()
		QuestManager.QuestState.ACTIVE:
			var missing := QuestManager.required_crystals - QuestManager.collected_crystals
			dialogues = [
				"You still need %d more crystals. Be careful with the guards!" % missing
			]
		QuestManager.QuestState.READY_TO_DELIVER:
			dialogues = [
				"You found all the crystals!",
				"Thank you, guardian. Our land is safe again."
			]
			QuestManager.complete_quest()
		QuestManager.QuestState.COMPLETED:
			dialogues = [
				"Thank you again, guardian."
			]

	dialogue_ui.show_dialogue(npc_name, dialogues)

func _on_interactive_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_nearby = true


func _on_interactive_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_nearby = false
		var dialogue_ui = get_tree().get_first_node_in_group("dialogue_ui")
		if dialogue_ui and dialogue_ui.is_open:
			dialogue_ui.close_dialogue()
