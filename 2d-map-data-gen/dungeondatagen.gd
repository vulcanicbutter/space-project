extends Node

# ============================================================
#  DungeonGenerator.gd
#  Attach this script to any Node in your scene.
#  Call generate() to build a new dungeon and print it.
# ============================================================

# --- Tile types ---
const WALL  = 0
const FLOOR = 1

# --- Tuneable settings ---
@export var map_width   : int = 100
@export var map_height  : int = 100
@export var max_rooms   : int = 15
@export var room_min    : int = 10    # minimum room side length
@export var room_max    : int = 10   # maximum room side length

# The grid: grid[y][x] = WALL or FLOOR
var grid : Array = []

# List of Rect2i, one per placed room  (handy for spawning enemies, loot, etc.)
var rooms : Array[Rect2i] = []


# ============================================================
#  Public API
# ============================================================

func generate() -> void:
	_init_grid()
	_place_rooms()
	_print_grid()   # remove this line once you hook up a TileMap


# ============================================================
#  Step 1 – fill everything with walls
# ============================================================

func _init_grid() -> void:
	grid = []
	rooms = []
	for y in map_height:
		var row : Array = []
		for x in map_width:
			row.append(WALL)
		grid.append(row)


# ============================================================
#  Step 2 – randomly place rooms, carve corridors between them
# ============================================================

func _place_rooms() -> void:
	for _attempt in max_rooms:
		# Pick a random size and position
		var w  : int = randi_range(room_min, room_max)
		var h  : int = randi_range(room_min, room_max)
		var rx : int = randi_range(1, map_width  - w - 1)
		var ry : int = randi_range(1, map_height - h - 1)
		var new_room := Rect2i(rx, ry, w, h)

		# Reject if it overlaps an existing room (1-tile padding)
		var overlaps := false
		for existing in rooms:
			if existing.grow(1).intersects(new_room):
				overlaps = true
				break

		if overlaps:
			continue

		# Carve the room into the grid
		_carve_room(new_room)

		# Connect to the previous room with an L-shaped corridor
		if rooms.size() > 0:
			var prev_center : Vector2i = _center(rooms.back())
			var new_center  : Vector2i = _center(new_room)
			# 50 % chance: horizontal-first or vertical-first
			if randi() % 2 == 0:
				_carve_h_corridor(prev_center.x, new_center.x, prev_center.y)
				_carve_v_corridor(prev_center.y, new_center.y, new_center.x)
			else:
				_carve_v_corridor(prev_center.y, new_center.y, prev_center.x)
				_carve_h_corridor(prev_center.x, new_center.x, new_center.y)

		rooms.append(new_room)


# ============================================================
#  Carving helpers
# ============================================================

func _carve_room(room: Rect2i) -> void:
	for y in range(room.position.y, room.position.y + room.size.y):
		for x in range(room.position.x, room.position.x + room.size.x):
			grid[y][x] = FLOOR

func _carve_h_corridor(x1: int, x2: int, y: int) -> void:
	for x in range(min(x1, x2), max(x1, x2) + 1):
		grid[y][x] = FLOOR

func _carve_v_corridor(y1: int, y2: int, x: int) -> void:
	for y in range(min(y1, y2), max(y1, y2) + 1):
		grid[y][x] = FLOOR

func _center(room: Rect2i) -> Vector2i:
	return room.position + room.size / 2


# ============================================================
#  Debug: print ASCII map to Output panel
# ============================================================

func _print_grid() -> void:
	var lines := ""
	for y in map_height:
		var row_str := ""
		for x in map_width:
			row_str += "." if grid[y][x] == FLOOR else "#"
		lines += row_str + "\n"
	print(lines)
	print("Rooms placed: ", rooms.size())


# ============================================================
#  Useful helpers you can call from other scripts
# ============================================================

# Returns true if the tile is walkable
func is_floor(x: int, y: int) -> bool:
	if x < 0 or y < 0 or x >= map_width or y >= map_height:
		return false
	return grid[y][x] == FLOOR

# Returns the center of the first room – good player spawn point
func get_start_position() -> Vector2i:
	if rooms.is_empty():
		return Vector2i.ZERO
	return _center(rooms[0])

# Returns the center of the last room – good exit/boss location
func get_end_position() -> Vector2i:
	if rooms.is_empty():
		return Vector2i.ZERO
	return _center(rooms.back())

# Called automatically when the node enters the scene tree
func _ready() -> void:
	generate()
