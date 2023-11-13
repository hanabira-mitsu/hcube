extends CharacterBody2D

# mess with these 4 consts till it feels right
var xspeed = 5
var jumpHeight = 6
var diveSpeed = 170
var diveHeight = 200
var diveFallSpeed = 2
var wallJumpHeight = jumpHeight
var xMovement = true
var yMovement = true
var diving = false
var justJumped = false
var dead = false
@onready var playerSprite = $Sprite

func _ready():
	#$"../ScreenCamera/ColorRect/AnimationPlayer".play("fadeIn")
	set_process_input(true)


func killPlayer(): #rip harper
	dead = true
	#if not $SoundPlayers/dead.playing:
		#$SoundPlayers/dead.play() ive lost the sound file
	$"../ScreenCamera/ColorRect/AnimationPlayer".play("flash")
	if playerSprite.direction == "right":
		$Sprite.play("dead")
	else:
		$Sprite.flip_h = true
		$Sprite.play("dead")
	await get_tree().create_timer(1).timeout
	$"../ScreenCamera/ColorRect/AnimationPlayer".play("fadeOut")
	await get_tree().create_timer(0.5).timeout
	get_tree().reload_current_scene()


func _physics_process(delta):
	if dead:
		return
	if xMovement == true:
		if Input.is_action_pressed("ui_left"):
			if velocity.x > 0:
				velocity.x = 0
			velocity.x += -2 * delta
		elif Input.is_action_pressed("ui_right"):
			if velocity.x < 0:
				velocity.x = 0
			velocity.x = 2 / delta
		elif diving == false:
			velocity.x = 0
	#if velocity.y > 600:
		#velocity.y = gravity
	move_and_slide()


