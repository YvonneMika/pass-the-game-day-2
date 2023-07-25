extends Area2D
class_name Item
## Base item all items inherit from

func _enter_tree() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: PhysicsBody2D) -> void:
	if body is Player:
		body.on_item_pickup(self)
		# TODO: collect sound and animation
		queue_free()
