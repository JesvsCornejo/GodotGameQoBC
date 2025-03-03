extends TextureProgressBar

@onready var player: CharacterBody2D = null
@onready var container: Node2D = null
@onready var world_node_path: NodePath = "../../world"

func _ready():
	# Connect to the root node signals
	get_tree().connect("node_added", Callable(self, "_on_node_added"))
	get_tree().connect("node_removed", Callable(self, "_on_node_removed"))

	# Call the function to attempt to connect signals.
	attempt_to_connect()

func attempt_to_connect():
	var world_node = get_node_or_null(world_node_path)
	if world_node:
		player = world_node.get_node_or_null("PlayerCharacter")
		container = get_node_or_null("../../container")

		if player and container:
			# Connect the signals and update the health bar
			player.healthChanged.connect(Callable(self, "update"))
			update()

func _on_node_removed(node):
	if node == get_node(world_node_path):
		# This is triggered when the world node is removed.
		# Cleanup the signals if necessary
		if player:
			player.healthChanged.disconnect(Callable(self, "update"))

func _on_node_added(node):
	if node == get_node(world_node_path):
		# This is triggered when the world node is re-added.
		attempt_to_connect()

func update():
	if player and container:
		value = player.currentHealth * 100 / container.playerMaxHealth
	else:
		value = 0
