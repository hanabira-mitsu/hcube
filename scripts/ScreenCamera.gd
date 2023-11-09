extends Camera2D

# Camera script follwing a target (usually the player)
# This camera is snapped to a grid, therefore only moves when the character exits a screen.

@export var target : NodePath
@export var align_time : float = 0.2
@export var screen_size := Vector2(1920, 1080)
@onready var Target = get_node_or_null(target)

func _ready():
	var limits = Rect2($"../TileMap".get_used_rect())
	var cell_size = Vector2(16, 16)
	self.limit_top = limits.position.y * cell_size.y
	self.limit_bottom = limits.end.y * cell_size.y
	self.limit_left = limits.position.x * cell_size.x
	self.limit_right = limits.end.x * cell_size.x

func _physics_process(_delta: float) -> void:
	if not is_instance_valid(Target):
		var targets: Array = get_tree().get_nodes_in_group("Player")
		if targets: Target = targets[0]
	if not is_instance_valid(Target):
		return
	
	# Actual movement
	#var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	#tween.tween_property(self, "global_position", Vector2i(Target.position.x, Target.position.y), align_time)
	if floor(self.position.distance_to(Vector2(Target.position.x, self.position.y))) > 40:
		self.position.x = move_toward(self.position.x, Target.position.x, 5)
	if floor(self.position.distance_to(Vector2(Target.position.y, self.position.y))) > 0:
		self.position.y = move_toward(self.position.y, Target.position.y, 5)

# Calculating the gridnapped position
#func desired_position() -> Vector2:
	#return (Target.global_position / screen_size).floor() * screen_size + screen_size/2
