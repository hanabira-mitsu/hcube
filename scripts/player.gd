extends CharacterBody2D

# mess with these 4 consts till it feels right
var gravity = 850
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

func onWall():
	if ($RayCast2DL.is_colliding() 
	or $RayCast2DL2.is_colliding()
	or $RayCast2DL3.is_colliding()):
		return "left"
	elif ($RayCast2DR.is_colliding()
	or $RayCast2DR2.is_colliding()
	or $RayCast2DR3.is_colliding()):
		return "right"
	else:
		return "none"

func _ready():
	$"../ScreenCamera/ColorRect/AnimationPlayer".play("fadeIn")
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

func _input(event):
	if dead:
		return
	if event.is_action_pressed("jump") == true and (onWall() != "none") and not is_on_floor():
		xMovement = false
		velocity.y = -wallJumpHeight / get_physics_process_delta_time()
		if onWall() == "left":
			velocity.x = xspeed / get_physics_process_delta_time()
			$AnimationPlayer.play("wall_jump_right")
		else: 
			velocity.x = -xspeed / get_physics_process_delta_time()
			$AnimationPlayer.play("wall_jump_left")
		await get_tree().create_timer(0.18).timeout
		xMovement = true
	
	if event.is_action_pressed("jump") and is_on_floor() == true:
		#while Input.is_action_pressed("jump") and justJumped == false:
		velocity.y = -jumpHeight / get_physics_process_delta_time()
		$AnimationPlayer.play("jump")
		justJumped = true
	#if Input.is_action_just_released("jump") and is_on_floor() == false and velocity.y < -150:
		#velocity.y = -150

	if (event.is_action_pressed("action") and is_on_floor() == false
	and diving == false and velocity.x != 0):
		if onWall() == "none":
			diving = true
			velocity.y = 0
			velocity.y = -diveHeight
			if playerSprite.direction == "right":
				velocity.x += diveSpeed
			else:
				velocity.x += -diveSpeed
			$AnimationPlayer.play("dive")
			xMovement = false
			await get_tree().create_timer(0.25).timeout
			xMovement = true
			
		else:
			xMovement = false
			velocity.y = -diveHeight
			if onWall() == "left":
				velocity.x = diveSpeed
			else: 
				velocity.x = -diveSpeed
			await get_tree().create_timer(0.18).timeout
			xMovement = true

func _physics_process(delta):
	if dead:
		return
	if is_on_floor() or onWall() != "none":
		diving = false
	if xMovement == true:
		if Input.is_action_pressed("ui_left"):
			if velocity.x > 0:
				velocity.x = 0
			velocity.x = -xspeed / delta
		elif Input.is_action_pressed("ui_right"):
			if velocity.x < 0:
				velocity.x = 0
			velocity.x = xspeed / delta
		elif diving == false:
			velocity.x = 0
	velocity.y += delta * gravity
	if velocity.y > 600:
		velocity.y = gravity
	move_and_slide()


