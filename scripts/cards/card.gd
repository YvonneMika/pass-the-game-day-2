extends Panel
class_name Card
## Base card all cards inherit from

@onready var anim_player := $AnimationPlayer

func _on_mouse_entered() -> void:
	anim_player.play("focus")
	z_index = 2

func _on_mouse_exited() -> void:
	anim_player.play("focus_exit")
	z_index = 1

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "focus_exit":
		z_index = 0
