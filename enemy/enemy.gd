extends CharacterBody3D
class_name Enemy
@export var gravity := 20.0
@export var speed := 25
@export var catching_distance := 1.5
@export var max_health := 6
@export var damage := 1

@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D
@onready var animation_player: AnimationPlayer = $EnemyModel/AnimationPlayer
@onready var player: Player = get_tree().get_first_node_in_group("player")

var health := max_health

func _ready() -> void:
	await get_tree().physics_frame
	await get_tree().physics_frame

	navigation_agent.path_desired_distance = 0.5
	navigation_agent.target_desired_distance = 1.0

	if player:
		navigation_agent.target_position = player.global_position


func _physics_process(_delta: float) -> void:
	if player == null:
		return

	navigation_agent.target_position = player.global_position

	var next_position := navigation_agent.get_next_path_position()

	var direction := next_position - global_position
	direction.y = 0.0

	if direction.length() < 0.5:
		direction = player.global_position - global_position
		direction.y = 0.0

	if direction.length() < 0.1:
		velocity = Vector3.ZERO
		return

	direction = direction.normalized()

	velocity = direction * speed

	look_at(global_position + direction, Vector3.UP)

	move_and_slide()

	animation_player.play("mixamo_com", 0.1)


func take_damage(amount: int) -> void:
	health -= amount
	print("ENEMY HEALTH: ", health)

	if health <= 0:
		die()


func hit(amount: int) -> void:
	take_damage(amount)


func die() -> void:
	var timer = get_tree().get_first_node_in_group("timer")

	if timer:
		timer.stop_timer()

	queue_free()


func travel_to_position(
	wanted_position: Vector3,
	new_speed: float,
	play_run_anim := false
) -> void:
	navigation_agent.target_position = wanted_position
	speed = new_speed


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		$Scream.play()
		await get_tree().create_timer(1).timeout
		get_tree().change_scene_to_file("res://game_over/game_over.tscn")
