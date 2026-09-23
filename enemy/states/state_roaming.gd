extends EnemyState

@export var _roaming_speed := 400.0

var _map_synchronized := false
var _target_position: Vector3
var _nav_map: RID


func _ready() -> void:
	_nav_map = _enemy.get_world_3d().get_navigation_map()

	print("NAV MAP: ", _nav_map)

	while NavigationServer3D.map_get_iteration_id(_nav_map) == 0:
		await get_tree().physics_frame
		print("WAITING FOR NAVIGATION...")

	print("NAVIGATION READY")
	print("NAV ITERATION: ", NavigationServer3D.map_get_iteration_id(_nav_map))

	_map_synchronized = true
	_travel_to_random_position()

func enter(previous_state_name: String, data := {}) -> void:
	if not _map_synchronized:
		return
	
	if data.has("do_not_reset_path") and data["do_not_reset_path"]:
		_enemy.travel_to_position(_enemy.navigation_agent.target_position, _roaming_speed)
		return
	
	_travel_to_random_position()


func physics_update(_delta: float) -> void:
	if not _map_synchronized:
		print("MAP FUCKED GANG: ", _map_synchronized)
		return
	
	if _enemy.navigation_agent.is_navigation_finished():
		_travel_to_random_position()
	
	if _enemy.is_player_in_view():
		requested_transition_to_other_state.emit("Chasing")


func _travel_to_random_position() -> void:
	print("NAV MAP: ", _nav_map)
	print("NAV ITERATION: ", NavigationServer3D.map_get_iteration_id(_nav_map))

	var rand_pos := NavigationServer3D.map_get_random_point(_nav_map, 1, true)

	print("RANDOM NAV POSITION: ", rand_pos)

	_enemy.travel_to_position(rand_pos, _roaming_speed, true)
