extends Panel
class_name CardUI
## Base card all cards inherit from

signal on_card_used(card: CardUI) ## Emitted when card is played

@onready var anim_player := $AnimationPlayer
@onready var hover_parent := get_node("../../..")
@onready var container := get_node("..")

var mouse_is_inside := false
var hovering := false

func _on_mouse_entered() -> void:
	mouse_is_inside = true
	if hovering: return
	anim_player.play("focus")
	z_index = 2

func _on_mouse_exited() -> void:
	mouse_is_inside = false
	if hovering: return
	anim_player.play("focus_exit")
	z_index = 1

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if hovering: return
	if anim_name == "focus_exit":
		z_index = 0

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_action_pressed("primary_action") and mouse_is_inside:
			hovering = true
			reparent(hover_parent)
			rotation_degrees = 0
		if event.is_action_released("primary_action") and hovering:
			hovering = false
			_on_mouse_exited()
			if container.get_parent().get_global_rect().has_point(Vector2(position.x, position.y + size.y * 0.5)):
				reparent(container)
			else:
				emit_signal("on_card_used", self)
				queue_free()
	
	if event is InputEventMouseMotion:
		if hovering:
			position += event.relative
