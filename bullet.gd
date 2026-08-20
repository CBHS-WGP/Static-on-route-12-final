extends Node3D

const SPEED =80
@onready var mesh =$MeshInstance3D
@onready var ray = $RayCast3D

func _ready() -> void:
	pass # Replace with function body.



func _process(delta: float) -> void:
	position += transform.basis * Vector3(0, 0, -SPEED) * delta
