extends Node2D

@onready var container = get_node("../container")
@onready var background_music = get_node("../container/backgroundMusic")

var boss_music = load("res://assets/sound/647908__sonically_sound__short-loop-made-in-a-few-minutes-with-qws-and-goldwave.wav")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void: 
	container.teacher_boss_cutscene_completed = true
	background_music.set_stream(boss_music)
	background_music.play()
	$"../CanvasLayer".visible = true
	get_tree().change_scene_to_file("res://scenes/world.tscn")
	pass # Replace with function body.
