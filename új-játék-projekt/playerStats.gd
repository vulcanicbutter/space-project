extends Node

@export var Health = 100

func _on_player_hurt_box_area_entered(area: Area2D) -> void:
	#print("ütközött", area)
	if area.has_method("attack_player"):
		take_damage(area.attack_damage)
		print("damage taken")
	#else:
		#print("Not an Enemy: ", area.name)

func take_damage(amount):
	print("HP:", Health)
	Health -= amount
	if Health <= 0:
		print("You Died!")
		queue_free()
		
