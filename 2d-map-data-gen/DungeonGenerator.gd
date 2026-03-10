extends Node

# ============================================================
#  DungeonGenerator.gd
#  Attach this script to any Node in your scene.
#  Call generate() to build a new dungeon and print it.
# ============================================================

# --- Tile types ---
const EMPTY = 0   # open void outside the dungeon
const WALL  = 1   # border tile enclosing every room and corridor
const FLOOR = 2   # walkable interior

# --- Tuneable settings ---
@export var map_width   : int = 100
@export var map_height  : int = 100
@export var max_rooms   : int = 15
@export var room_min    : int = 10
@export var room_max    : int = 15

# The grid: grid[y][x] = EMPTY, WALL, or FLOOR
var grid : Array = []

# List of Rect2i, one per placed room
var rooms : Array[Rect2i] = []


# ============================================================
#  Public API
# ============================================================

func generate() -> void:
	_init_grid()
	_place_rooms()
	_build_walls()   # border every floor tile with walls
	_print_grid()    # remove once you hook up a TileMap


# ============================================================
#  Step 1 - fill everything with EMPTY void
# ============================================================

func _init_grid() -> void:
	grid = []
	rooms = []
	for y in map_height:
		var row : Array = []
		for x in map_width:
			row.append(EMPTY)
		grid.append(row)


# ============================================================
#  Step 2 - place rooms and corridors (floor tiles only)
# ============================================================

func _place_rooms() -> void:
	for _attempt in max_rooms:
		var safe_max_w : int = min(room_max, map_width  - 4)
		var safe_max_h : int = min(room_max, map_height - 4)
		var safe_min_w : int = min(room_min, safe_max_w)
		var safe_min_h : int = min(room_min, safe_max_h)

		var w  : int = randi_range(safe_min_w, safe_max_w)
		var h  : int = randi_range(safe_min_h, safe_max_h)
		var rx : int = randi_range(2, map_width  - w - 2)
		var ry : int = randi_range(2, map_height - h - 2)
		var new_room := Rect2i(rx, ry, w, h)

		# Reject if overlaps existing room (2-tile padding so walls never merge)
		var overlaps := false
		for existing in rooms:
			if existing.grow(2).intersects(new_room):
				overlaps = true
				break

		if overlaps:
			continue

		_carve_room(new_room)

		if rooms.size() > 0:
			var prev_center : Vector2i = _center(rooms.back())
			var new_center  : Vector2i = _center(new_room)
			if randi() % 2 == 0:
				_carve_h_corridor(prev_center.x, new_center.x, prev_center.y)
				_carve_v_corridor(prev_center.y, new_center.y, new_center.x)
			else:
				_carve_v_corridor(prev_center.y, new_center.y, prev_center.x)
				_carve_h_corridor(prev_center.x, new_center.x, new_center.y)

		rooms.append(new_room)


# ============================================================
#  Step 3 - border every FLOOR tile with WALL (checks 8 neighbours)
# ============================================================

func _build_walls() -> void:
	var to_wall : Array[Vector2i] = []

	for y in map_height:
		for x in map_width:
			if grid[y][x] == EMPTY:
				if _has_floor_neighbour(x, y):
					to_wall.append(Vector2i(x, y))

	for pos in to_wall:
		grid[pos.y][pos.x] = WALL


func _has_floor_neighbour(x: int, y: int) -> bool:
	for dy in [-1, 0, 1]:
		for dx in [-1, 0, 1]:
			if dx == 0 and dy == 0:
				continue
			var nx : int = x + dx
			var ny : int = y + dy
			if nx < 0 or ny < 0 or nx >= map_width or ny >= map_height:
				continue
			if grid[ny][nx] == FLOOR:
				return true
	return false


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
#  ' ' = empty void   '+' = wall   '.' = floor
# ============================================================

func _print_grid() -> void:
	var lines := ""
	for y in map_height:
		var row_str := ""
		for x in map_width:
			match grid[y][x]:
				EMPTY: row_str += " "
				WALL:  row_str += "+"
				FLOOR: row_str += "."
		lines += row_str + "\n"
	print(lines)
	print("Rooms placed: ", rooms.size())


# ============================================================
#  Useful helpers
# ============================================================

func is_floor(x: int, y: int) -> bool:
	if x < 0 or y < 0 or x >= map_width or y >= map_height:
		return false
	return grid[y][x] == FLOOR

func is_wall(x: int, y: int) -> bool:
	if x < 0 or y < 0 or x >= map_width or y >= map_height:
		return false
	return grid[y][x] == WALL

func is_empty(x: int, y: int) -> bool:
	if x < 0 or y < 0 or x >= map_width or y >= map_height:
		return true
	return grid[y][x] == EMPTY

func get_start_position() -> Vector2i:
	if rooms.is_empty():
		return Vector2i.ZERO
	return _center(rooms[0])

func get_end_position() -> Vector2i:
	if rooms.is_empty():
		return Vector2i.ZERO
	return _center(rooms.back())

func _ready() -> void:
	generate()
