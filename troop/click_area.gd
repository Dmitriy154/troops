extends Control

func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		print("Left mouse button was pressed!")
		if($"..".selected):		
			$"..".selected = false
			$"../fon".hide()
		else:
			$"..".selected = true
			$"../fon".show()
		$"..".update_troop()



#https://docs.godotengine.org/en/stable/tutorials/ui/custom_gui_controls.html  -  УВЕДОМЛЕНИЯ
func _notification(what):
	match what:
		NOTIFICATION_MOUSE_ENTER:
			pass # Mouse entered the area of this control.
		NOTIFICATION_MOUSE_EXIT:
			#print("MOUSE_EXIT")
			pass # Mouse exited the area of this control.
		NOTIFICATION_FOCUS_ENTER:
			pass # Control gained focus.
		NOTIFICATION_FOCUS_EXIT:
			pass # Control lost focus.
		NOTIFICATION_THEME_CHANGED:
			pass # Theme used to draw the control changed;
		# update and redraw is recommended if using a theme.
		NOTIFICATION_VISIBILITY_CHANGED:
			pass # Control became visible/invisible;
		# check new status with is_visible().
		NOTIFICATION_RESIZED:
			pass # Control changed size; check new size
		# with get_size().
