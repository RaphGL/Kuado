extends Camera2D

export(float) var max_zoom := 2.5

func _input(event):
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == BUTTON_WHEEL_UP and zoom.length() > 1:
			zoom -= Vector2(0.2 , 0.2)
		if event.button_index == BUTTON_WHEEL_DOWN and zoom.length() < max_zoom:
			zoom += Vector2(0.2 , 0.2)