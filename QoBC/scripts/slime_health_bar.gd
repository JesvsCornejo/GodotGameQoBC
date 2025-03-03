extends TextureProgressBar

@onready var slime: Node2D = $".."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	slime.healthChanged.connect(update)
	update()
	pass # Replace with function body.

func update():
	value = slime.health * 100 / slime.maxHealth
