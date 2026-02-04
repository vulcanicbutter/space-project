extends CharacterBody2D

#region Movement constants
@export var MAX_SPEED = 200.0
@export var ACCELERATION = 800.0
@export var DECELERATION = 800.0
@export var dash_can = true
@export var dash_amount = 1
@export var dash_coldown = 1
@export var dash_lenght = 0.105
@export var dash_max_amount = 4
@export var dash_regen = true
@export var dash_regen_coldown = 2
const gun_inst = preload("res://items/gun/gun.tscn")
var close_enough = false
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
	
	if Lobby.pickup == false:
		var gun_node = get_node("../gun")
		
		if gun_node:
			var pickupdistance: Vector2 = gun_node.global_position - self.global_position
			
			# region pickup (Move your pickup logic inside this 'if' block)
			if pickupdistance.length() <= 20:
				close_enough = true
			else:
				close_enough = false
				
			if Input.is_action_just_pressed("pickup") and close_enough:
				gun_node.reparent(self)
				Lobby.pickup = true
			# endregion
	
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

#region Dash
	
	
	if Input.is_action_just_pressed("Dash") and dash_can == true and dash_amount >= 1 :
	#dash
		dash_can = false
		dash_amount = dash_amount - 1
		MAX_SPEED = MAX_SPEED * 5
		ACCELERATION = ACCELERATION * 6.3
		await get_tree().create_timer(dash_lenght).timeout
		MAX_SPEED = MAX_SPEED / 5
		ACCELERATION = ACCELERATION / 6.3
		await get_tree().create_timer(dash_coldown).timeout
		dash_can = true
		
		
#region Dash regen
	if dash_max_amount > dash_amount and dash_regen:
		dash_regen = false
		dash_amount = dash_amount + 1
		await get_tree().create_timer(dash_regen_coldown).timeout
		dash_regen = true
	
	
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
#region pickup
	
	#if  pickupdistance.length() <= 20 :
		#close_enough = true
	#else:
		#close_enough = false
	
	#if Input.is_action_just_pressed("pickup") and close_enough:
		#$"../gun".reparent(self)
		#Lobby.pickup = true
	#
		#
