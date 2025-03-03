extends Node

var dialogue_data = {}
var current_npc = null
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
	quest_manager = get_node("../QuestManager")  # Adjust path as needed
	load_dialogue_data()

func load_dialogue_data():
	var file = FileAccess.open("res://dialogue_data.json", FileAccess.READ)
	if file:
		var content = file.get_as_text()
		file.close()
		var json = JSON.new()
		var parse_result = json.parse(content)
		if typeof(parse_result) != TYPE_DICTIONARY:
			print("Unexpected result type from JSON.parse:", typeof(parse_result))
			return
			if parse_result.error != OK:
				print("Failed to parse JSON: Error code =", parse_result.error, ", Error string =", parse_result.error_string)
				return
				dialogue_data = parse_result.result
				print("Dialogue data loaded successfully:", dialogue_data)
			else:
				print("Failed to open dialogue_data.json. Ensure it exists at res://dialogue_data.json")

# Start dialogue with a specific NPC
func start_dialogue(npc_id: String):
	current_npc = npc_id
	if npc_id in dialogue_data:
		var dialogue = dialogue_data[npc_id]
		print("Dialogue started:", dialogue["intro"])
		display_options(dialogue["options"])
	else:
		print("No dialogue data for:", npc_id)

# Display dialogue options
func display_options(options: Array):
	for option in options:
		print("Option:", option["text"])

# Handle selected dialogue option
func handle_option_selection(option: String):
	if current_npc in dialogue_data:
		var npc_data = dialogue_data[current_npc]
		for opt in npc_data["options"]:
			if opt["id"] == option:
				print("Selected:", opt["text"])
				match opt["action"]:
					"give_quests":
						var objectives = opt.get("objectives", [])
						var rewards = opt.get("rewards", {})
						var quest = Quest.new(
							opt["quest_id"],
							opt["quest_title"],
							opt["quest_description"],
							objectives,
							rewards
						)
						quest_manager.add_quest(quest)
					"exit":
						print("Dialogue ended.")
