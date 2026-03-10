extends RigidBody2D
var final_velocity = Vector2.ZERO

func _ready():
	gravity_scale = 0
	linear_damp = 0
	set_as_top_level(true)

func _physics_process(delta):
	position += final_velocity * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	await get_tree().create_timer(1).timeout
	queue_free()
