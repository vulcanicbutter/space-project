extends Control

@onready var play_button = $Play
@onready var options_button = $Options
@onready var exit_button = $Quit

# Játék indítása
func _on_play_pressed():
	print("Játék elindítva...")
	var scene = load("res://Lobby.tscn")
	get_tree().change_scene_to_packed(scene)  # A játék fő scene-je

# Beállítások menü
func _on_options_pressed():
	print("Beállítások menü...")
	var scene = load("res://Main Menu.tscn")
	# Ha van beállítások scene
	get_tree().change_scene_to_packed(scene)

# Kilépés
func _on_quit_pressed():
	print("Kilépés...")
	get_tree().quit()  # Kilép a játékból
