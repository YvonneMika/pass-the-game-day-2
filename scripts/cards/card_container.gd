@tool
extends HBoxContainer

@export_range(0, 180, 1) var fan_angle_degrees = 20
@export var separation := 0:
	set(p_separation):
		if p_separation != separation:
			separation = p_separation
			add_theme_constant_override("separation", separation)
			adjust_separation() # Just so I can update in editor

func _on_sort_children() -> void:
	for i in range(get_child_count()):
		var child = get_child(i)
		
		# Angle
		var card_x = (child.position.x + (child.size.x * 0.5)) - (size.x * 0.5)
		var rotation_ratio = card_x / size.x
		var rot_deg = rotation_ratio * fan_angle_degrees
		child.rotation_degrees = rot_deg
#		child.position.y += abs(rot_deg) * 30
		set_y_based_on_angle(child, rot_deg)

func _on_child_entered_tree(node: Node) -> void:
	adjust_separation()

func adjust_separation():
	var children_total_width := 0
	for child in get_children():
		children_total_width += child.size.x
	
	var children_width_ratio = size.x / children_total_width # What percent of the container the children take up
	print(children_width_ratio)
	
	# If cards take up most of this containers size
	# overlap them based on by how much
	if children_width_ratio > .9: 
		separation = -children_width_ratio*50

func set_y_based_on_angle(node: Control, theta_degrees: int):
	var point_x = (position.x + (node.position.x - node.size.x * .5)) - (size.x * 0.5)
	
	# Avoid divide by 0
	if theta_degrees == 0: # If it's position is 0 it shouldn't move on the y anyways
		return
	
	var center_height = 0 / tan(theta_degrees)
	var height = (point_x / tan(theta_degrees))
	var height_diff = center_height - height
	
	# Set y position
	node.position.y += abs(height_diff)
	
	print("Height: ", height)
	print("Height diff: ", height_diff)
