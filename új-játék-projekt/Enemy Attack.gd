extends Area2D

@export var attack_cooldown = 0.4
@export var attack_damage = 10
var can_attack = true
var in_range = false

func attack_player():
	pass


func _on_default_range_area_entered(_area: Area2D) -> void:
	in_range = true
	_hitting()
	
	
func _on_default_range_area_exited(area: Area2D) -> void:
	in_range = false
	
	
func _hitting():
	while in_range == true:
		if not can_attack:
			return
		can_attack = false
		show()
		$CollisionShape2D.disabled = false

		await get_tree().create_timer(0.1).timeout
		hide()
		$CollisionShape2D.disabled = true

		await get_tree().create_timer(attack_cooldown).timeout
		can_attack = true
	
	
