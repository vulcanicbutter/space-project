extends CharacterBody2D

@export var health = 3
@export var detection_range: float = 200
@export var move_speed: float = 100
@onready var player = get_node("/root/Node2D/Player")
var is_chasing = false

#var can_attack = true

func _ready() -> void:
	set_process(true)
	
	
func _process(_delta):
	if player != null:
		var distance_to_player = global_position.distance_to(player.global_position)
		
		if distance_to_player < detection_range:
			is_chasing = true
		else:
			is_chasing = false
	if is_chasing:
		follow_player()
	else:
		idle_state()
	
	
func follow_player():
	#print("Megvagy!")
	var direction = (player.global_position - global_position).normalized()
	velocity = direction * move_speed
	move_and_slide()
	
func idle_state():
	velocity = Vector2.ZERO
	
func _on_enemy_hurt_box_area_entered(area: Area2D) -> void:
	#print("ütközött", area)
	if area.has_method("start_attack"):
		take_damage(area.attack_damage)
	#else:
		#print("Not a Player: ", area.name)

func take_damage(amount):
	print("hit  ", health, ": remaining")
	health -= amount
	if health <= 0:
		print("Enemy Down!")
		queue_free()
		
