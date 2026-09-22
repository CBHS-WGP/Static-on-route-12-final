extends Node3D

func _ready():
	var gun = get_tree().current_scene.get_node("Gunonground")
	var spawn_points = get_tree().current_scene.get_node("GunSpawnPoints").get_children()

	if spawn_points.size() == 0:
		print("No spawn points found!")
		return

	var random_marker = spawn_points.pick_random()

	gun.global_position = random_marker.global_position
	gun.global_rotation = random_marker.global_rotation

	print("Gun spawned at: ", random_marker.name)
