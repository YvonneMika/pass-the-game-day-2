extends Node
class_name Movement

## A logic node to determine a characters movement

@export var direction := Vector2() ## The direction to move the character in
@export_range(0, 1.0, 0.01) var MOVE_WEIGHT := .3 ## How much the character will move (1.0 is max speed)

func set_direction(pos: Vector2):
	direction = pos.normalized() * MOVE_WEIGHT

## Randomly change direction
func random_direction() -> void:
	direction = Vector2(randi_range(-1, 1), randi_range(-1, 1)).normalized() * MOVE_WEIGHT
