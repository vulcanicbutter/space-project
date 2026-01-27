extends Node2D

@onready var fire_timer = $FireTimer
@export var fire_rate: float = 0.2
var Timeout = 1.5
var ammo = 30
var max_ammo = 30
var reloadtime = 2


const bullet = preload("res://items/gun/Bullet/bullet.tscn")
@onready var muzzle: Marker2D = $Marker2D



func _physics_process(delta):
	look_at(get_global_mouse_position())
	
	if Input.is_action_just_pressed("reload") and ammo != max_ammo :
		await get_tree().create_timer(reloadtime).timeout
		ammo = max_ammo
	
	rotation_degrees = wrapf(rotation_degrees, 0.0, 360.0)
	
	if rotation_degrees > 90 and rotation_degrees < 270:
		scale.y = -1
	else:
		scale.y = 1
		
	if Input.is_action_just_pressed("attack") and ammo > 0 and fire_timer.is_stopped():
		var bullet_instance = load("res://items/gun/Bullet/bullet.tscn").instantiate()
		add_child(bullet_instance)
		ammo = ammo-1
		bullet_instance.global_position = muzzle.global_position
		bullet_instance.rotation = rotation
		fire_timer.start(fire_rate)
		
		#pistol_cooldown = true
