extends Control


func _ready():
	position = get_viewport_rect().size / 2

func _draw():
	draw_circle(Vector2.ZERO, 4, Color.RED)
