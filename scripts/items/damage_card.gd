extends Item
class_name ItemDamageCard

@onready var animation_player := $AnimationPlayer

@export var stat_sheet : StatSheet

func _ready() -> void:
	animation_player.play("idle")
	var idle_length = animation_player.current_animation_length
	animation_player.advance(randf_range(0, idle_length))
