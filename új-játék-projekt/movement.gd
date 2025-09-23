extends CharacterBody2D

#region Movement constants
@export var MAX_SPEED = 200.0
@export var ACCELERATION = 800.0
@export var DECELERATION = 800.0
#endregion

#region Attack variables
var attack_component
#endregion

#region Texture variables
@export var character_front: Texture2D
@export var character_left: Texture2D
@export var character_right: Texture2D
@onready var sprite: Sprite2D = $Sprite2D2
#endregion

func _ready():
	
	attack_component = $PlayerAttackHitbox

func _physics_process(delta):
	
#region Movement function
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward")
	input_vector =  input_vector.normalized()

	if input_vector != Vector2.ZERO:
		#gyorsulás
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else: 
		#lassulás
		velocity = velocity.move_toward(Vector2.ZERO, DECELERATION * delta)
	move_and_slide()
#endregion
	
#region Attack function
	if Input.is_action_just_pressed("meele_attack"):
		attack_component.start_attack()
#endregion
	
#region Texture changer function
	if input_vector.x > 0:
		sprite.texture = character_right
	elif input_vector.x < 0:
		sprite.texture = character_left
	elif input_vector.y > 0:
		sprite.texture = character_front
	elif input_vector.y < 0:
		sprite.texture = character_front
#endregion
