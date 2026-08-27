extends Node3D
var instance
var current_gun = null
var bullet = load("res://bullet.tscn")
var gun = load("res://gun.tscn")
@onready var gun_anim = $AnimationPlayer
@onready var gun_barrel = $RayCast3D
@onready var Gunshot: AudioStreamPlayer3D = $Gunshot
@onready var Shootcooldown: Timer = $Shootcooldown
@onready var gun_holder = $gunholder


func _physics_process(delta):
	if Input.is_action_pressed("shoot") and Shootcooldown.is_stopped():
		Shootcooldown.start()
		Gunshot.play()
		if !gun_anim.is_playing():
			gun_anim.play("shoot")
			instance = bullet.instantiate()
			instance.position = gun_barrel.global_position
			instance.transform.basis = gun_barrel.global_transform.basis
			get_parent().add_child(instance)
