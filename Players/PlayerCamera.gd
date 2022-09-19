extends Camera2D


@export var max_zoom: float = 2.5

func _input(event):
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN and zoom.length() > 1:
			zoom -= Vector2(0.2 , 0.2)
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and zoom.length() < max_zoom:
			zoom += Vector2(0.2 , 0.2)
