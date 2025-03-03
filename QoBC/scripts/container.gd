extends Node2D

#player attributes
@export var playerMaxHealth: int = 100
@export var playerMaxStamina: float = 100
@export var playerBaseSpeed: int = 60
@export var playerSlashStaminaCost: int = 10

#player situations
var teacher_boss_cutscene_completed = false
var teacher_boss_dead = false
var player_spawn: Vector2 = Vector2(35,35)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_background_music_finished() -> void:
	$backgroundMusic.play()
	pass # Replace with function body.
