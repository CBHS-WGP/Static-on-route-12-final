extends Node3D



func _process(delta: float) -> void:
	pass

func _ready():
	print("map ready")
	print_tree()
	$Terrain3D.set_camera($player/Head/Camera3D)
