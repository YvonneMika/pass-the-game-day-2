extends Movement

@export var CHANGE_DIR_INTERVAL := 1.0 ## How often the AI changes directions

var time := 0.0

func _process(delta: float) -> void:
	time += delta
	if time > CHANGE_DIR_INTERVAL: 
		time = 0
		if randi_range(0,1) == 0: ## 50% change to move in a random direction or stop
			random_direction()
		else:
			direction = Vector2.ZERO
