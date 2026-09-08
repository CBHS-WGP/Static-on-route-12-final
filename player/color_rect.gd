extends ColorRect


 
var gun = load("res://bullet.tscn")
var player = load("res://player/player.tscn")

@onready var camera = 

@onready var gun_barrel ="res://gun.gd"

func _process(delta):
	update_reticle()

func update_reticle():
   
	var start_point = gun_barrel.global_transform.origin
 
	var direction = -gun_barrel.global_transform.basis.z.normalized()
	
  
	var target_point = start_point + direction * 10  
	
 
	var start_screen_pos = camera.unproject_position(start_point)
	var target_screen_pos = camera.unproject_position(target_point)
	
  
	position = target_screen_pos - (size / 2)
