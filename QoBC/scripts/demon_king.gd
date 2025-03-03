extends CharacterBody2D

signal healthChanged

var speed = 30
var maxHealth = 150
var health = maxHealth
var player_chase = false
var player = null
var attack_range = false
var is_dead = false

var attack_id = 0
var is_attacking = false  # Track if an attack is in progress

@onready var collision_right = $hitBoxDefault/hitBoxDefault

func _physics_process(delta):
	if !is_dead:
		if health <= 0:
			$AnimatedSprite2D.play("death")
			is_dead = true
		elif attack_range and player != null and !is_attacking:
			# Stop movement during attack
			velocity = Vector2.ZERO
			is_attacking = true  # Set attacking state
			attack_id = randi() % 3 + 1
			print("Playing attack animation: attack", attack_id)  # Debug
			$AnimatedSprite2D.play("attack" + str(attack_id))
			_update_attack_collision()  # Enable collision during attack
		elif player_chase and player != null and !is_attacking:  # Only chase if not attacking
			# Chase the player if in chase range and no attack animation is playing
			var direction = (player.position - position).normalized()
			velocity = direction * speed
		else:
			# Default to idle if no other actions are happening
			velocity = Vector2.ZERO

		# Prevent enemy from standing on the player
		if is_on_floor() and player != null and global_position.y < player.global_position.y:
			velocity.y = 0

		# Apply movement and update animations
		move_and_slide()
		if player_chase and !is_attacking:
			$AnimatedSprite2D.flip_h = (player.position.x - position.x) < 0
			if not $AnimatedSprite2D.is_playing():
				if not $AnimatedSprite2D.animation.begins_with("walk"):
					$AnimatedSprite2D.play("walk")
		elif not player_chase and !is_attacking:
			if not $AnimatedSprite2D.is_playing():
				$AnimatedSprite2D.play("idle")

		# Health bar visibility
		$TextureProgressBar.visible = health < maxHealth





func _on_area_2d_body_entered(body: Node2D):
	if body.is_in_group("player"):
		player = body
		player_chase = true
		print("Player entered chase range.")  # Debug


func _on_area_2d_body_exited(body: Node2D):
	if body.is_in_group("player"):
		player = null
		player_chase = false
		print("Player exited chase range.")  # Debug


func _on_attack_range_body_entered(body: Node2D):
	if body.is_in_group("player"):
		attack_range = true
		print("Player entered attack range.")  # Debug
		_update_attack_collision()  # Enable collision when in attack range


func _on_attack_range_body_exited(body: Node2D):
	if body.is_in_group("player"):
		attack_range = false
		print("Player exited attack range.")  # Debug
		_disable_attack_collisions()  # Disable collision when out of attack range
		is_attacking = false  # Reset attack state when leaving attack range

		# Stop the attack animation if the player leaves the attack range
		if $AnimatedSprite2D.is_playing() and $AnimatedSprite2D.animation.begins_with("attack"):
			$AnimatedSprite2D.stop()  # Stop the current attack animation
			print("Stopped attack animation.")  # Debug

		# Return to idle or walking state after stopping the attack
		if player_chase:
			$AnimatedSprite2D.play("walk")
		else:
			$AnimatedSprite2D.play("idle")



func _on_hurt_box_area_entered(area: Area2D) -> void:
	if area.is_in_group("player weapon") and attack_range:  # Only apply damage if in attack range
		health -= 10
		healthChanged.emit()
		print("Demon King: ", health)


func _on_animated_sprite_2d_animation_finished() -> void:
	if $AnimatedSprite2D.animation.begins_with("attack"):
		print("Attack animation finished.")  # Debug
		_disable_attack_collisions()  # Disable collisions after attack
		is_attacking = false  # Reset attacking state after animation finishes

		# If the player is still within attack range, allow for a new attack
		if attack_range:
			is_attacking = false  # Reset the attack state, allowing the next attack animation to trigger
			print("Ready for next attack.")  # Debug
	elif $AnimatedSprite2D.animation == "death":
		print("Dead skeleton.")
		queue_free()


func _update_attack_collision():
	# Enable both attack collisions
	collision_right.disabled = false
	print("Enabled both collision polygons.")  # Debug


func _disable_attack_collisions():
	# Disable both attack collisions
	collision_right.disabled = true
	print("Disabled both collision polygons.")  # Debug


func _ready():
	# Ensure the random seed is initialized
	randomize()

	# Connect the animation finished signal
	$AnimatedSprite2D.animation_finished.connect(_on_animated_sprite_2d_animation_finished)


func _on_animated_sprite_2d_animation_looped() -> void:
	if $AnimatedSprite2D.animation == "death":
		queue_free()
	pass # Replace with function body.
