extends Node3D
var instance
var current_gun = null
var bullet = load("res://bullet.tscn")

@onready var gun_anim = $AnimationPlayer
@onready var gun_barrel = $RayCast3D
@onready var Gunshot: AudioStreamPlayer3D = $Gunshot
@onready var Shootcooldown: Timer = $Shootcooldown
@onready var gun_holder = $hand
const SPEED = 80

func _physics_process(delta): 

	if Input.is_action_pressed("shoot") and Shootcooldown.is_stopped(): 

		Shootcooldown.start() 

		Gunshot.play() 

		if !gun_anim.is_playing(): 

			gun_anim.play("shoot") 

			instance = bullet.instantiate() 

			instance.global_position = gun_barrel.global_position 

			instance.global_transform.basis = gun_barrel.global_transform.basis 
			var direction_vector = -gun_barrel.global_transform.basis.z.normalized()
			instance.velocity = direction_vector * SPEED 

			get_parent().add_child(instance) 
