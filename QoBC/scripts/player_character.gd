extends CharacterBody2D

#imports the Node2D container that keeps all the variables
@onready var container: Node2D  

#player signals
signal healthChanged
signal staminaChanged
signal running

#dynamic variables
@export var speed = 60
var maxHealth: int = 100
var maxStamina: int = 100
var currentHealth: int = maxHealth
var currentStamina: float = maxStamina

#constants
var sprintSpeed 

#player states
var player_state
var weapon_attacking = false
var health_regenerating = false
var stamina_regenerating = false
var is_running = false

#ability costs
var slashStaminaCost: int

func _ready() -> void:

	call_deferred("_setup_timers")
	call_deferred("_get_container")
	

func _physics_process(delta):
	var direction = Input.get_vector("left", "right", "up", "down")
	
	#when dead makes the player not able to move
	if player_state == "dead":
		speed = 0
	#print(get_angle_to(get_global_mouse_position()))
	
	#changes of player states
	if currentHealth <= 0:
		player_state = "dead"
	elif direction.x == 0 and direction.y == 0:
		player_state = "idle"
	elif direction.x != 0 or direction.y != 0:
		player_state = "walking"
	
	var is_player_running = true
	if velocity.length() > 0:
		is_player_running = true
		
	else:
		is_player_running = false
		$footsteps_sound.stop()
	
	# Check if running and scurry is not playing
	if is_player_running && !$footsteps_sound.playing:
		$footsteps_sound.play()
	
		
	velocity = direction * speed
	move_and_slide()
	
	#if velocity.length() > 0:
		#is_running = true
		
	#else:
		#is_running = false
		#$player_walking.stop()
	
	# Check if running and scurry is not playing
	#if is_running && !$player_walking.playing:
		#$player_walking.play()
	
	play_anim(direction)
	#checks if the player needs to regenerate health and !health_regenerating prevents the timer function to be called continuously
	if currentHealth < maxHealth and !health_regenerating:
		$"../../CanvasLayer/TextureHealthBar/healthRegenTimer".start()
		health_regenerating = true

	#checks if the player needs to regenerate stamina
	if currentStamina < maxStamina and !stamina_regenerating:
		$"../../CanvasLayer/TextureStaminaBar/staminaRegenTimer".start()
		stamina_regenerating = true
		
		#emits the running function while "sprint" is pressed
	if Input.is_action_pressed("sprint"):
		running.emit()
		#print("sprinting")
		
		#when the player stops sprinting, speed returns to base and the timer stops for stamina drain
	if Input.is_action_just_released("sprint"):
		speed = container.playerBaseSpeed
		is_running = false
		$"../../CanvasLayer/TextureStaminaBar/runningDepleteTimer".stop()

func _get_container():
	if has_node("../../container"):
		container = get_node("../../container")
		maxHealth = container.playerMaxHealth
		maxStamina = container.playerMaxStamina
		currentHealth = maxHealth
		healthChanged.emit()
		currentStamina = maxStamina
		staminaChanged.emit()
		slashStaminaCost = container.playerSlashStaminaCost
		sprintSpeed = container.playerBaseSpeed + 40
		if container.player_spawn == Vector2(82,930):
			$Camera2D.zoom = Vector2(2,2)
		set_position(container.player_spawn)
		if container.teacher_boss_cutscene_completed == true:
			$"../teacherBossArea/CollisionShape2D".disabled = true
			$"../Level1/bossAreaGate".visible = true
			$"../Level1/bossAreaGate/CollisionShape2D".disabled = false
		if container.teacher_boss_dead:
			$"../TeacherBoss".queue_free()
			$"../Level1/portal/StaticBody2D/CollisionPolygon2D".disabled = true
			$"../Level1/portal/StaticBody2D".visible = false
		if container.teacher_boss_cutscene_completed and !container.teacher_boss_dead:
			$"../TeacherBoss/CanvasLayer".visible = true
	else:
		call_deferred("_get_container")


func play_anim(dir):
	if weapon_attacking and currentStamina > slashStaminaCost:
		#sets the speed to 0 while attacking and attacks in the direction that the cursor is pointing
		speed = 0
		$weapon/swordSwingSound.play()
		if get_angle_to(get_global_mouse_position()) > -PI + PI/4 and get_angle_to(get_global_mouse_position()) < 0 - PI/4:
			$AnimatedSprite2D.play("n-slash")
		elif get_angle_to(get_global_mouse_position()) < PI - (PI/4) and get_angle_to(get_global_mouse_position()) > 0 + PI/4:
			$AnimatedSprite2D.play("s-slash")
		elif (get_angle_to(get_global_mouse_position()) > 0 - PI/4) and (get_angle_to(get_global_mouse_position()) < 0 + PI/4):
			$AnimatedSprite2D.play("e-slash")
		elif (get_angle_to(get_global_mouse_position()) < (-PI + (PI/4))) or (get_angle_to(get_global_mouse_position()) > (PI - (PI/4))):
			$AnimatedSprite2D.play("w-slash")
	else:
		if player_state == "dead":
			$AnimatedSprite2D.play("death")
		elif player_state == "idle":
			$AnimatedSprite2D.play("idle")
		elif player_state == "walking":
			if dir.y == -1:
				$AnimatedSprite2D.play("n-walk")
			elif dir.x == 1:
				$AnimatedSprite2D.play("e-walk")
			elif dir.y == 1:
				$AnimatedSprite2D.play("s-walk")
			elif dir.x == -1:
				$AnimatedSprite2D.play("w-walk")
		


func _on_weapon_attacking() -> void:
	#print("yes attacking")
	weapon_attacking = true
	if currentStamina > slashStaminaCost:
		currentStamina -= slashStaminaCost
		staminaChanged.emit()
	print("Current Stamina: ", currentStamina)
	pass # Replace with function body.


func _on_cooldown_timer_timeout() -> void:
	weapon_attacking = false
	speed = container.playerBaseSpeed
	pass # Replace with function body.
			
func _on_hurt_box_area_entered(area):
	if area.is_in_group("enemy"):
		$hurtBox/hitSound.play()
		currentHealth -= 10
		healthChanged.emit()
		print("Player got hit by enemy! Current Health: ", currentHealth)
	
	if area.is_in_group("teacher boss"):
		$hurtBox/hitSound.play()
		currentHealth -= 30
		healthChanged.emit()

func _setup_timers() -> void:
	#imports the timer nodes from CanvasLayer so the signals can be used
	if has_node("../../CanvasLayer/TextureHealthBar/healthRegenTimer") and has_node("../../CanvasLayer/TextureStaminaBar/staminaRegenTimer") and has_node("../../CanvasLayer/TextureStaminaBar/runningDepleteTimer"):
		var healthRegenTimer = get_node("../../CanvasLayer/TextureHealthBar/healthRegenTimer")
		var staminaRegenTimer = get_node("../../CanvasLayer/TextureStaminaBar/staminaRegenTimer")
		var runningDepleteTimer = get_node("../../CanvasLayer/TextureStaminaBar/runningDepleteTimer")
		healthRegenTimer.timeout.connect(_on_health_regen_timer_timeout)
		staminaRegenTimer.timeout.connect(_on_stamina_regen_timer_timeout)
		runningDepleteTimer.timeout.connect(_on_running_deplete_timer_timeout)
	else:
		call_deferred("_setup_timers")

func _on_health_regen_timer_timeout() -> void:
	#player health regen over time every second
	if currentHealth < container.playerMaxHealth:
		currentHealth += 2 
		healthChanged.emit()
		$"../../CanvasLayer/TextureHealthBar/healthRegenTimer".start()
		print("Current Health: ", currentHealth)
	elif currentHealth == container.playerMaxHealth:
		health_regenerating = false
	pass # Replace with function body.


func _on_stamina_regen_timer_timeout() -> void:
	#similar to health regen, every .2 seceonds, regen 1 point of stamina
	if currentStamina < container.playerMaxStamina:
		currentStamina += 1
		staminaChanged.emit()
		$"../../CanvasLayer/TextureStaminaBar/staminaRegenTimer".start()
		print("Current Stamina: ", currentStamina)
	elif currentStamina == container.playerMaxStamina:
		stamina_regenerating = false
	pass # Replace with function body.


func _on_running() -> void:
	if currentStamina > 0:
		speed = sprintSpeed
		if !is_running:
			is_running = true
			$"../../CanvasLayer/TextureStaminaBar/runningDepleteTimer".start()
	elif currentStamina == 0:
		speed = container.playerBaseSpeed
	pass # Replace with functio body.
	

func _on_running_deplete_timer_timeout() -> void:
	if currentStamina > 0:
		currentStamina -= 3
		is_running = false
	pass # Replace with function body.


func _on_animated_sprite_2d_animation_finished() -> void:
	if $AnimatedSprite2D.animation == "death":
		$"../../CanvasLayer".visible = false
		get_tree().change_scene_to_file("res://scenes/death_screen.tscn")
	pass # Replace with function body.

func _on_east_attack() -> void:
	$weapon/east_hitbox/CollisionShape2D.disabled = false
	$weapon/east_hitbox/eastAttackTimer.start()
	pass # Replace with function body.
	
func _on_east_attack_timer_timeout() -> void:
	$weapon/east_hitbox/CollisionShape2D.disabled = true
	pass # Replace with function body.

func _on_weapon_north_attack() -> void:
	$weapon/north_hitbox/CollisionShape2D.disabled = false
	$weapon/north_hitbox/northAttackTimer.start()
	pass # Replace with function body.
	
func _on_north_attack_timer_timeout() -> void:
	$weapon/north_hitbox/CollisionShape2D.disabled = true
	pass # Replace with function body.

func _on_weapon_south_attack() -> void:
	$weapon/south_hitbox/CollisionShape2D.disabled = false
	$weapon/south_hitbox/southAttackTimer.start()
	pass # Replace with function body.

func _on_south_attack_timer_timeout() -> void:
	$weapon/south_hitbox/CollisionShape2D.disabled = true
	pass # Replace with function body.

func _on_weapon_west_attack() -> void:
	$weapon/west_hitbox/CollisionShape2D.disabled = false
	$weapon/west_hitbox/westAttackTimer.start()
	pass # Replace with function body.

func _on_west_attack_timer_timeout() -> void:
	$weapon/west_hitbox/CollisionShape2D.disabled = true
	pass # Replace with function body.
