extends Node2D

@onready var carboard_box = preload("res://Enviorment/cardboard_box.tscn")




func _on_timer_timeout() -> void:
	var rand_x = randf_range(500,-500)
	var rand_y = randf_range(500,-500)
	var box = carboard_box.instantiate()
	box.position = position + Vector2(rand_x,rand_y)
	get_parent().get_node("BoxHandler").add_child(box)
