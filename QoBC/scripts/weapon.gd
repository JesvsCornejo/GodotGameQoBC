extends Node2D
@export var playerCharacter: CharacterBody2D

var is_ready: bool = true

signal northAttack
signal eastAttack
signal westAttack
signal southAttack
signal attacking
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("main attack") and is_ready:
		is_ready = false
		$CooldownTimer.start()
		if get_angle_to(get_global_mouse_position()) > -PI + PI/4 and get_angle_to(get_global_mouse_position()) < 0 - PI/4:
			northAttack.emit()
		elif get_angle_to(get_global_mouse_position()) < PI - (PI/4) and get_angle_to(get_global_mouse_position()) > 0 + PI/4:
			southAttack.emit()
		elif (get_angle_to(get_global_mouse_position()) > 0 - PI/4) and (get_angle_to(get_global_mouse_position()) < 0 + PI/4):
			eastAttack.emit()
		elif (get_angle_to(get_global_mouse_position()) < (-PI + (PI/4))) or (get_angle_to(get_global_mouse_position()) > (PI - (PI/4))):
			westAttack.emit()
		if Input.is_action_pressed("up") or Input.is_action_pressed("down") or Input.is_action_pressed("right") or Input.is_action_pressed("left"):
			emit_signal("attacking")
		#print("action pressed")
		


func _on_cooldown_timer_timeout() -> void:
	is_ready = true
	pass # Replace with function body.
