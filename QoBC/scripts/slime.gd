extends CharacterBody2D

signal healthChanged

var speed = 30
var maxHealth = 30
var health = maxHealth
var player_chase = false
var player = null

var healthPickup = preload("res://scenes/health_pickup.tscn")
var staminaPickup = preload("res://scenes/stamina_pickup.tscn")

func _physics_process(delta):
	if health <= 0:
		$AnimatedSprite2D.play("death")
	elif player_chase and player != null:
		var direction = (player.position - position).normalized()
		velocity = direction * speed
		move_and_slide()
		if (player.position.x - position.x) < 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
		# Flip the sprite depending on direction
		$AnimatedSprite2D.play("walk")
	else:
		velocity = Vector2.ZERO
		move_and_slide()
		$AnimatedSprite2D.play("idle")
	
	if health == maxHealth:
		$TextureProgressBar.visible = false
	else:
		$TextureProgressBar.visible = true


func _on_area_2d_body_entered(body: Node2D):
	player = body
	player_chase = true

func _on_area_2d_body_exited(body: Node2D):
	player = null
	player_chase = false


func _on_hurt_box_area_entered(area: Area2D) -> void:
	if area.is_in_group("player weapon"):
		$hitSound.play()
		health -= 10
		healthChanged.emit()
		print("Slime health: ", health)
	pass # Replace with function body.


func _on_animated_sprite_2d_animation_looped() -> void:
	if $AnimatedSprite2D.animation == "death":
		var health_drop = healthPickup.instantiate()
		var stamina_drop = staminaPickup.instantiate()
		var random_num = randi_range(1,100)
		if random_num > 50:
			health_drop.position = position
			get_parent().add_child(health_drop)
		else:
			stamina_drop.position = position
			get_parent().add_child(stamina_drop)
		print("dead slime")
		queue_free()
	pass # Replace with function body.


func _on_animated_sprite_2d_animation_changed() -> void:
	if $AnimatedSprite2D.animation == "death":
		$deathSound.play()
	pass # Replace with function body.
