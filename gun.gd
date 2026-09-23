extends Node3D

@export var damage: int = 2
@export var fire_rate: float = 0.75
@export var range: float = 100.0

@onready var camera: Camera3D = get_viewport().get_camera_3d()
@onready var gun_anim: AnimationPlayer = $AnimationPlayer
@onready var gunshot: AudioStreamPlayer3D = $Gunshot

var can_shoot := true


func _process(_delta):
	var fpc = get_tree().get_first_node_in_group("player")
	
	if fpc and fpc.has_picked_up:
		if Input.is_action_pressed("shoot") and can_shoot:
			shoot()

func shoot():
	can_shoot = false


	if gunshot:
		gunshot.play()

	if gun_anim and gun_anim.has_animation("shoot"):
		gun_anim.play("shoot")

	
	var screen_center = get_viewport().get_visible_rect().size / 2.0

	var ray_origin = camera.project_ray_origin(screen_center)
	var ray_direction = camera.project_ray_normal(screen_center)

	var ray_end = ray_origin + ray_direction * range

	var query = PhysicsRayQueryParameters3D.create(
		ray_origin,
		ray_end
	)

	
	query.exclude = [get_tree().get_first_node_in_group("player")]

	var result = get_world_3d().direct_space_state.intersect_ray(query)

	if result:
		var hit_object = result.collider

		print("Hit: ", hit_object.name)

		if hit_object.is_in_group("skeleton"):
			if hit_object.has_method("hit"):
				hit_object.hit(damage)

	await get_tree().create_timer(fire_rate).timeout
	can_shoot = true
