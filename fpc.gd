extends Node3D



@onready var cam = $"player/Camera3D"
@onready var ch3d = $"player"
@onready var raycast = $Camera3D/RayCast3D
@onready var hand = $Camera3D/gunholder
var v = Vector3()
var sens = 0.12


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _process(delta):
	cam.rotation_degrees.x = v.x
	ch3d.rotation_degrees.y = v.y
	
	var object = raycast.get_collider()
	if raycast.is_colliding():
		if object.is_in_group("pickable"):
			if Input.is_action_pressed("pickup"):
				object.global_position = hand.global_position
				object.global_position = hand.global_rotation
func _input(event):
	if event is InputEventMouseMotion:
		v.y -= (event.relative.x * sens)
		v.x -= (event.relative.y * sens)
		v.x = clamp(v.x, -80, 90)
