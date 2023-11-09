extends Button

var selectedLevel = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	self.pressed.connect(self._button_pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	selectedLevel = get_parent().selected

func _button_pressed():
	get_tree().change_scene_to_file("res://scenes/levels/"+str(selectedLevel)+".tscn")
