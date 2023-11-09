extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

#git test!
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func exit():
	$ScreenCamera/ColorRect/AnimationPlayer.play("fadeOut")
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://scenes/menus/mainMenu.tscn")
