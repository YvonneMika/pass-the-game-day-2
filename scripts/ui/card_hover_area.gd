extends MarginContainer

@export var card_container : HBoxContainer
@export var animation_player : AnimationPlayer

var mouse_is_inside := false
var mouse_is_inside_last := mouse_is_inside

func _on_mouse_entered() -> void: 
	animation_player.play("focus")

func _on_mouse_exited() -> void:
	animation_player.play_backwards("focus")

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion: # Manual events, couldn't figure out how to count hovering children as still hovering
		mouse_is_inside = self.get_global_rect().has_point(event.position)
		
		if !mouse_is_inside:
			for child in card_container.get_children():
				if child.get_global_rect().has_point(event.position):
					mouse_is_inside = true
					break
		
		if mouse_is_inside != mouse_is_inside_last:
			if mouse_is_inside:
				_on_mouse_entered()
			else:
				_on_mouse_exited()
		mouse_is_inside_last = mouse_is_inside
