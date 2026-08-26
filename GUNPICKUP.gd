extends Area3D


var player_nearby = false
var player = null

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_nearby = true
		player = body

func _on_body_exited(body):
	if body == player:
		player_nearby = false
		player = null

func _process(_delta):
	if player_nearby and Input.is_action_just_pressed("pickup"):
		pickup_gun()


func pickup_gun():
	if player == null:
		return

	player.pick_up_gun()

	queue_free()
