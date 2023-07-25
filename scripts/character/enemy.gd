extends Character
class_name Enemy

@export var player_sightline_check_interval := 0.25
@export var patrol_interval := 2.0

var is_player_near
var time := 0.0

func _physics_process(delta: float) -> void:
	for i in get_slide_collision_count():
		var collider = get_slide_collision(i).get_collider()
		if collider is Character:
			collider.take_damage(stat_sheet.damage)
	time += delta
	if is_player_near:
		if time >= player_sightline_check_interval:
			time = 0
			movement.MOVE_WEIGHT = 0.7
			check_los_to_player()
	else:
		if time > patrol_interval:
			time = 0
			movement.MOVE_WEIGHT = 0.3
			movement.random_direction()
	super._physics_process(delta)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		is_player_near = body


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		is_player_near = null

func check_los_to_player() -> void:
	var raycast: RayCast2D = $RayCast2D
	raycast.target_position = (is_player_near.get_node("CollisionShape2D").global_position - global_position) * 2
	raycast.force_raycast_update()
	
	if raycast.is_colliding():
		var collider = raycast.get_collider()
		if collider is Player:
			move_towards(collider.position)

func move_towards(pos: Vector2) -> void:
	movement.set_direction(pos - global_position)
