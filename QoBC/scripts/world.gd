extends Node2D

var hell_music = preload("res://assets/sound/The Hive.mp3")
var boss_music = preload("res://assets/sound/8-Bit Boss Battle [Royalty Free].mp3")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var container = preload("res://scenes/container.tscn").instantiate()
	var UI = preload("res://scenes/canvas_layer.tscn").instantiate()
	if !has_node("../Canvas Layer") and !has_node("../container"):
		get_tree().root.add_child.call_deferred(container)
		get_tree().root.add_child.call_deferred(UI)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_teacher_boss_area_body_entered(body: Node2D) -> void:
	
	var container = get_node("../container")
	container.player_spawn = Vector2(602,543)
	$teacherBossArea/CollisionShape2D.disabled = true
	$"../CanvasLayer".visible = false
	get_tree().change_scene_to_file("res://scenes/TeacherBossCutscene.tscn")
	print(container.player_spawn)
	print("teacher boss area entered") 
	#if container.teacher_boss_dead == false:
		#$TeacherBoss/CanvasLayer.visible = true
	#else:
		#print("Teacher Boss Dead = :", container.teacher_boss_dead)
	
	#$PlayerCharacter.set_position(Vector2(0,1250))
	pass # Replace with function body.


func _on_portal_body_entered(body: Node2D) -> void:
	print("portal area entered")
	if body.is_in_group("player") or body.is_in_group("player character"):
		$"../container/backgroundMusic".set_stream(hell_music)
		$"../container/backgroundMusic".play()
		$PlayerCharacter.set_position(Vector2(184,-1548))
		$PlayerCharacter/Camera2D.zoom = Vector2(2,2)
	pass # Replace with function body.


func _on_level_2_teleport_body_entered(body: Node2D) -> void:
	print("level 2 portal area entered")
	if body.is_in_group("player") or body.is_in_group("player character"):
		$PlayerCharacter.set_position(Vector2(82,930))
		$PlayerCharacter/Camera2D.zoom = Vector2(2,2)
	pass # Replace with function body.


func _on_level_3_bossteleport_body_entered(body: Node2D) -> void:
	print("level 3 portal area entered")
	if body.is_in_group("player") or body.is_in_group("player character"):
		$"../container".player_spawn = Vector2(82,930)
		$"../container/backgroundMusic".set_stream(boss_music)
		$"../container/backgroundMusic".play()
		$PlayerCharacter.set_position(Vector2(608,1265))
		$PlayerCharacter/Camera2D.zoom = Vector2(2,2)
	pass # Replace with function body.


func _on_level_3_teleportback_body_entered(body: Node2D) -> void:
	print("level 3 portal back area entered")
	if body.is_in_group("player") or body.is_in_group("player character"):
		$PlayerCharacter.set_position(Vector2(1885,-913))
		$PlayerCharacter/Camera2D.zoom = Vector2(2,2)
	pass # Replace with function body.


func _on_level_2_door_1_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") or body.is_in_group("player character"):
		$PlayerCharacter.set_position(Vector2(2893,-1423))
		$PlayerCharacter/Camera2D.zoom = Vector2(2,2)
	pass # Replace with function body.


func _on_level_2_door_2_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") or body.is_in_group("player character"):
		$PlayerCharacter.set_position(Vector2(590,-1089))
		$PlayerCharacter/Camera2D.zoom = Vector2(2,2)
	pass # Replace with function body.
