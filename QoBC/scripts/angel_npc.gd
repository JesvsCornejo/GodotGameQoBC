extends Node2D

var dialogue_manager
var quest_manager

class Quest:
	var id: String
	var title: String
	var description: String
	var objectives: Array
	var rewards: Dictionary
	var status: String = "not_started"

	func _init(_id: String, _title: String, _description: String, _objectives: Array, _rewards: Dictionary):
		id = _id
		title = _title
		description = _description
		objectives = _objectives
		rewards = _rewards

func _ready():
	dialogue_manager = get_node("../DialogueManager")  # Adjust path as needed
	quest_manager = get_node("../QuestManager")       # Adjust path as needed

# Handle interaction with the player
func _on_area_2d_body_entered(body: Node2D):
	dialogue_manager.start_dialogue("angel_npc")

func on_dialogue_option_selected(option: String):
	match option:
		"give_quests":
			# Add a specific quest
			var objectives = [
				{ "id": "find_feather", "description": "Find the holy feather in the forest.", "status": "not_started" },
				{ "id": "defeat_guardian", "description": "Defeat the dungeon guardian.", "status": "not_started" }
			]
			var rewards = { "gold": 50, "exp": 100 }
			var quest = Quest.new(
				"angel_quest_1",
				"Retrieve the Holy Feather",
				"Find the holy feather to proceed in your journey.",
				objectives,
				rewards
			)
			quest_manager.add_quest(quest)
		"exit":
			print("Angel says goodbye!")
