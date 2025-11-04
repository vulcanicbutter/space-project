extends CharacterBody2D

@export var speed = 200
@export var attack_cooldown = 0.4
@export var attack_damage = 1

var can_attack = true

func _physics_process(delta):
	var dir = Vector2.ZERO
	dir.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	dir.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	velocity = dir.normalized() * speed
	move_and_slide()

	if Input.is_action_just_pressed("attack") and can_attack:
		attack()

func attack():
	can_attack = false
	$AttackHitbox.show()  # előhozzuk a hitboxot
	$AttackHitbox/CollisionShape2D.disabled = false
	await get_tree().create_timer(0.1).timeout   # kb. 0.1 mp-ig aktív
	$AttackHitbox.hide()
	$AttackHitbox/CollisionShape2D.disabled = true
	await get_tree().create_timer(attack_cooldown).timeout
	can_attack = true
