extends Area2D

@export var attack_cooldown = 0.4
@export var attack_damage = 1

var can_attack = true


func start_attack():
	
	if not can_attack:
		return
	can_attack = false
	show()
	$CollisionShape2D.disabled = false

	# rövid ideig aktív
	await get_tree().create_timer(0.1).timeout
	hide()
	$CollisionShape2D.disabled = true

	# cooldown
	await get_tree().create_timer(attack_cooldown).timeout
	can_attack = true
