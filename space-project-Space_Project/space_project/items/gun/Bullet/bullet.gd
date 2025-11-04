extends Node2D
@export var Bulletspeed = 300

func _process(delta: float) -> void:
	position += transform.x * Bulletspeed * delta
