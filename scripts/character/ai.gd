extends Movement

@export var CHANGE_DIR_INTERVAL := 1.0 ## How often the AI changes directions
@export_range(0, 1.0, 0.01) var MOVE_WEIGHT := .3 ## How much the character will move (1.0 is max speed)

var time := 0.0

func _process(delta: float) -> void:
	time += delta
	if time > CHANGE_DIR_INTERVAL: 
		time = 0
		if randi_range(0,1) == 0: ## 50% change to move in a random direction or stop
			random_direction()
		else:
			set_direction(Vector2.ZERO)

## Randomly change direction
func random_direction() -> void:
	direction = Vector2(randi_range(-1, 1), randi_range(-1, 1)).normalized() * MOVE_WEIGHT

func set_direction(new_direction: Vector2) -> void:
	direction = new_direction
