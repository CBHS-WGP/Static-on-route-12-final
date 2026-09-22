extends Node3D

@onready var cam = $"."
@onready var ch3d = $".."
@onready var raycast = $Camera3D/RayCast3D
@onready var hand = $hand

var v = Vector3.ZERO
var sens = 0.12


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _process(delta):
	
	cam.rotation_degrees.x = v.x

	
	ch3d.rotation_degrees.y = v.y


	if raycast.is_colliding():
		var object = raycast.get_collider()

		if object.is_in_group("pickable"):
			if Input.is_action_just_pressed("pickup"):
				object.reparent(hand)
				object.position = Vector3.ZERO
				object.rotation = Vector3.ZERO
				object.scale = Vector3.ONE

func _input(event):
	if event is InputEventMouseMotion:

		
		v.y -= event.relative.x * sens

		
		v.x -= event.relative.y * sens

		
		v.x = clamp(v.x, -10, 10)
