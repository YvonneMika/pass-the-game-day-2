extends Item
class_name Card

@export var sprite : Sprite2D

@onready var animation_player := $AnimationPlayer

func _ready() -> void:
	animation_player.play("idle")
	var idle_length = animation_player.current_animation_length
	animation_player.advance(randf_range(0, idle_length))
