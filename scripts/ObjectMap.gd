extends TileMap

var obj = null
var levelFinish = preload("res://scenes/level bits/objects/level_finish.tscn")
var spike = preload("res://scenes/level bits/objects/Spike.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	var objects = get_used_cells(0)
	for i in objects:
		match(get_cell_atlas_coords(0, i)):
			Vector2i(0, 0): #level finish bit
				obj = levelFinish.instantiate()
			Vector2i(1, 0): #spikes
				obj = spike.instantiate()
		add_child(obj)
		obj.position = to_global(map_to_local(i))
		erase_cell(0, i)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
