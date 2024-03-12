extends Node2D

@export var gameVersion: String = "HyperCube 0.0.8a"
# Called when the node enters the scene tree for the first time.
func _ready():
	loadMenu()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func loadMenu():
	var mainMenu = load("res://scenes/menus/mainMenu.tscn").instantiate()
	call_deferred("add_child", mainMenu)

func startLevel(level):
	loadScene(level)
	$"HUD".reset()
	if $mainMenu != null:
		$mainMenu.queue_free()
	$"HUD".show()

func loadScene(scene):
	var newScene = load(scene).instantiate()
	call_deferred("add_child", newScene)
	
func exit():
	$HUD/ColorRect/AnimationPlayer.play("fadeOut")
	await get_tree().create_timer(0.5).timeout
	if get_node("/root/Main/Level") != null: #the node always exists when exit() is called
											 #but theres a crash if i dont check first
		get_node("/root/Main/Level").free()
	elif get_node("/root/Main/EditorMain/Level") != null:
		get_node("/root/Main/EditorMain/Level").free()
	$HUD.hide()
	loadMenu()

func reload(node):
	var filename = get_node(node).get_scene_file_path()
	get_node(node).free()
	startLevel(filename)
