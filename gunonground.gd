extends Area3D

var player = null

func _on_body_entered(body):
	if body.is_in_group("player"):
		player = body

func _on_body_exited(body):
	if body == player:
		player = null

func _process(_delta):
	if player and Input.is_action_just_pressed("pickup"):
		player.pickup_gun(self)
