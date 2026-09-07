extends Node3D

const SPEED =80
@onready var mesh =$MeshInstance3D
@onready var ray = $RayCast3D
var velocity = Vector3.ZERO
func _ready() -> void:
	pass # Replace with function body. 



func _process(delta: float) -> void:
	global_position += velocity * delta
	if ray.is_colliding():
		mesh.visible = false 
		ray.enabled = false
		if ray.get_collider().is_in_group("skeleton"):
			ray.get_collider().hit(2)
