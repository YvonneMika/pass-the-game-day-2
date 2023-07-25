extends CharacterBody2D
class_name Character
## This is the base class for all characters in this game
## 
## How characters interact with the world are defined here

signal on_die() ## Called when this character's health reaches 0

@export_group("Stats")
@export var health := 3
@export_group("Physics")
@export var SPEED := 300.0
@export var IS_MOVING_THRESHOLD := .2 ## Used to determine how much velocity the character needs to be considered "moving"
@export_group("Dependencies")
@export var animation_player: AnimationPlayer
@export var particles: GPUParticles2D ## Right now used for movement
@export var character_root: Node2D = self ## The root of the character, used to determine what to delete on death
@export var movement: Movement ## Needed to move the character
@export var character_texture: Texture2D

@onready var sprite = $Sprite2D

func _ready() -> void:
	sprite.texture = character_texture
	animation_player.play("idle")

func _physics_process(_delta: float) -> void:
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
func take_damage(amount: int) -> int:
	health -= amount
	if health <= 0:
		die()
	return health


func die() -> void:
	emit_signal("on_die")
	character_root.queue_free()
