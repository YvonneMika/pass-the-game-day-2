extends CharacterBody2D
class_name Character
## This is the base class for all characters in this game
## 
## How characters interact with the world are defined here

signal on_die() ## Called when this character's health reaches 0

@export var stat_sheet : StatSheet
@export var invuln_time := 1
@export_group("Physics")
@export var SPEED := 300.0
@export var IS_MOVING_THRESHOLD := .2 ## Used to determine how much velocity the character needs to be considered "moving"
@export_group("Dependencies")
@export var animation_player: AnimationPlayer
@export var particles: GPUParticles2D ## Right now used for movement
@export var character_root: Node2D = self ## The root of the character, used to determine what to delete on death
@export var movement: Movement ## Needed to move the character

var invuln_timer : float = invuln_time
var invulnerable := false

func _ready() -> void:
	animation_player.play("idle")

func _physics_process(delta: float) -> void:
	invuln_timer += delta
	if invuln_timer >= invuln_time:
		invulnerable = false
	if movement:
		# Get direction from movement node (usually input or ai)
		var direction = movement.direction
		
		if direction:
			velocity = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.y = move_toward(velocity.y, 0, SPEED)
	
	move_and_slide()
	
	# Particles
	particles.emitting = velocity.length() > IS_MOVING_THRESHOLD
	
	# Animations
	if velocity.length() > IS_MOVING_THRESHOLD: # Super basic animations TODO: State machine?
		animation_player.play("walk")
	elif animation_player.current_animation != "idle":
		animation_player.stop()
		animation_player.play("idle")

## Applies [amount] damage to this character
## Returns the remaining health of the character
func take_damage(amount: int):
	if invulnerable:
		return
	print("take_damage")
	stat_sheet.health -= amount
	if stat_sheet.health <= 0:
		die()
	invuln_timer = 0
	invulnerable = true


func die() -> void:
	emit_signal("on_die")
	character_root.queue_free()
