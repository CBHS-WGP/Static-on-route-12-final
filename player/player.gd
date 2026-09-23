extends CharacterBody3D
class_name Player


const BASE_SPEED = 20
const SPRINT_SPEED_MULTIPLIER = 2.0
const JUMP_VELOCITY = 9

const SPRINT_DURATION = 7.0
const SPRINT_COOLDOWN = 5.0

var has_picked_up := false
var instance
var _gravity: float = 25.0
var _last_step_location := Vector3.ZERO

var sprint_timer := 0.0
var sprint_cooldown_timer := 0.0
var can_sprint := true

@onready var gun_holder = $hand
@onready var _mouse_sensitivity := 0.15 / (get_viewport().get_visible_rect().size.x/1152.0)
@onready var _cam := $head/Camera3D
@onready var _step_sound: AudioStreamPlayer = $StepSound
@onready var flashlight = $head/Camera3D/SpotLight3D


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	_last_step_location = Vector3(global_position.x, 0.0, global_position.z)
	flashlight.light_energy = 0


func _physics_process(delta):

	# Footstep sound
	var xz_position := Vector3(global_position.x, 0.0, global_position.z)
	if _last_step_location.distance_to(xz_position) > 10:
		_last_step_location = xz_position
		_step_sound.play()

	# Gravity
	if not is_on_floor():
		velocity.y -= _gravity * delta

	# Jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Sprint cooldown
	if not can_sprint:
		sprint_cooldown_timer -= delta

		if sprint_cooldown_timer <= 0:
			can_sprint = true
			sprint_timer = 0

	# Sprint
	var is_sprinting := false

	if Input.is_action_pressed("sprint") and can_sprint:
		is_sprinting = true
		sprint_timer += delta

		# Sprint has lasted 7 seconds
		if sprint_timer >= SPRINT_DURATION:
			can_sprint = false
			sprint_cooldown_timer = SPRINT_COOLDOWN
			is_sprinting = false

	var speed_multiplier := SPRINT_SPEED_MULTIPLIER if is_sprinting else 1.0

	# Movement
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		velocity.x = direction.x * BASE_SPEED * speed_multiplier
		velocity.z = direction.z * BASE_SPEED * speed_multiplier
	else:
		velocity.x = move_toward(velocity.x, 0, BASE_SPEED)
		velocity.z = move_toward(velocity.z, 0, BASE_SPEED)

	move_and_slide()


func _input(event):
	if event is InputEventMouseMotion:
		rotation_degrees.y += event.relative.x * -_mouse_sensitivity
		_cam.rotation_degrees.x += event.relative.y * -_mouse_sensitivity
		_cam.rotation_degrees.x = clamp(_cam.rotation_degrees.x, -90, 90)

	if event.is_action_pressed("flashlight"):
		flashlight.light_energy = 0 if flashlight.light_energy > 0 else 4.0
