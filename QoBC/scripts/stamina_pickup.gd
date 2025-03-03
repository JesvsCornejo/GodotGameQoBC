extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") or body.is_in_group("player character"):
		$"../../../container".playerMaxStamina += 10
		queue_free()
	pass # Replace with function body.


func _on_timer_timeout() -> void:
	$CollisionShape2D.disabled = false
	pass # Replace with function body.
