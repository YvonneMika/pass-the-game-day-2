@tool
extends HBoxContainer

signal on_card_used(card: CardUI) ## Emitted when card is used

@export_range(0, 180, 1) var fan_angle_degrees := 20:
	set(p_fan_angle_degrees):
		if p_fan_angle_degrees != fan_angle_degrees:
			fan_angle_degrees = p_fan_angle_degrees
			queue_sort()
@export var separation := 0:
	set(p_separation):
		if p_separation != separation:
			separation = p_separation
			add_theme_constant_override("separation", separation)
@export var max_width := size.x

func _on_sort_children() -> void:
	adjust_separation()
	for i in range(get_child_count()):
		var child = get_child(i)
		
		child.rotation_degrees = get_angle_from_x(child)
		set_y_based_on_angle(child, child.rotation_degrees)

func _on_child_entered_tree(node: Node) -> void:
	if node is CardUI:
		print("card")
		node.visibility_changed.connect(_on_child_visibility_change)
		node.on_card_used.connect(_on_card_used)

func _on_child_exiting_tree(node: Node) -> void:
	if node is CardUI:
		node.visibility_changed.disconnect(_on_child_visibility_change)
		node.on_card_used.disconnect(_on_card_used)

func adjust_separation():
	var children_total_width := 0
	var visible_children_count := 0
	for child in get_children():
		if !child.visible: continue
		children_total_width += child.size.x
		visible_children_count += 1
	
	if visible_children_count <= 0: # Avoid divide by 0
		return
	
	var children_width_ratio = float(children_total_width) / max_width if children_total_width != 0 else 0.0 # What percent of the container the children take up
	
	# If cards take up most of this containers size
	# overlap them based on by how much
	if children_width_ratio > .9: 
		separation = int((max_width - children_total_width) / visible_children_count)
	elif separation != 0:
		separation = 0

func get_angle_from_x(node: Control) -> int:
	# Angle
	var node_x =  (node.position.x + node.size.x * 0.5) - (size.x * 0.5)
	var rotation_ratio = node_x / (size.x * 0.5)
	var rot_deg = rotation_ratio * fan_angle_degrees
	
	return rot_deg

func set_y_based_on_angle(node: Control, theta_degrees: int):
	var point_x = (node.position.x + node.size.x * 0.5) - (size.x * 0.5)
	
	if abs(theta_degrees) < 4: # If the angle is too small the float imprecision gets out of hand (literally)
		return 
	
	var theta_rad = deg_to_rad(90 - theta_degrees)
	
	var center_height = point_x / cos(theta_rad)
	var height = abs(point_x * tan(theta_rad))
	var height_diff = abs(center_height - height)
	
	# Set y position
	node.position.y = abs(height_diff)

func _on_child_visibility_change() -> void:
	adjust_separation()
	_on_sort_children()

func _on_card_used(card: CardUI):
	print("container _on_card_used")
	emit_signal("on_card_used", card)

