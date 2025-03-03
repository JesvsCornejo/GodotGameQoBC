extends CharacterBody2D

signal healthChanged

var container

@export var maxHealth = 100
var health = maxHealth
var speed = 30
var player_chase = false
var player = null
var death = false

func _physics_process(delta):
	if player_chase and player != null:
		var direction = (player.position - position).normalized()
		velocity = direction * speed
		move_and_slide()
		if (player.position.x - position.x) < 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
		# Flip the sprite depending on direction
		$AnimatedSprite2D.play("walking")
	else:
		velocity = Vector2.ZERO
		move_and_slide()
		$AnimatedSprite2D.play("idle")
	
	if health == 0:
		speed = 0
		container.teacher_boss_dead = true
		if !death:
			death = true
			print(death)
			$deathSound.play()
	
func _ready() -> void:
	call_deferred("_get_container")

func _get_container():
	if has_node("../../container"):
		container = get_node("../../container")
	else:
		call_deferred("_get_container")

func _on_detection_area_body_entered(body: Node2D):
	if body.name == "PlayerCharacter":  # Ensure the body is the player
		player = body
		player_chase = true
		print("Player entered detection area")

func _on_detection_area_body_exited(body: Node2D) -> void:
	if body == player:  # Ensure the body exiting is the player
		player = null
		player_chase = false
		print("Player exited detection area")

func _on_hurt_box_area_entered(area: Area2D) -> void:
	if area.is_in_group("player weapon"):
		$hitSound.play()
		health -= 10
		healthChanged.emit()
		print("Boss health: ", health)
	pass # Replace with function body.


func _on_death_sound_finished() -> void:
	$"../portal/StaticBody2D/CollisionPolygon2D".disabled = true
	$"../portal/StaticBody2D".visible = false
	$"../../container/backgroundMusic".stop()
	queue_free()
	pass # Replace with function body.
