extends Node2D
@export var Bulletspeed = 300
var final_velocity = Vector2.ZERO

func _ready():
	set_as_top_level(true)

func _process(delta: float) -> void:
	position += transform.x * Bulletspeed * delta


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	await get_tree().create_timer(1).timeout
	queue_free()
