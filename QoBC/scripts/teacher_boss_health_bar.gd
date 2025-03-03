extends TextureProgressBar


@onready var teacher: Node2D = $"../.."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	teacher.healthChanged.connect(update)
	update()
	pass # Replace with function body.

func update():
	value = teacher.health * 100 / teacher.maxHealth
