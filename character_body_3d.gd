extends CharacterBody3D


const SPEED = 6
const SPRINTSPEED = 12
var currSpeed = 0

const JUMP_VELOCITY = 8.75
signal jumpBoostCD
var jumpBoostAvailable : bool = true

const ACCEL = 2.87
const DECCEL = -2.87

var vertVel = 0
var horzVel : Vector3
const RESPAWNANCHOR = Vector3(0, 5, 0)

var mouseInput : Vector2

@onready var initial_position := position
@onready var gravity: Vector3 = ProjectSettings.get_setting("physics/3d/default_gravity") * ProjectSettings.get_setting("physics/3d/default_gravity_vector")
		
@onready var camera = get_node("Camera3D")

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	jumpBoostAvailable = true


func _physics_process(delta: float) -> void:
	currSpeed = SPEED
	if Input.is_action_just_released("QUIT"):
		get_tree().quit()
	
	if Input.is_action_pressed("SPRINT"):
		currSpeed = SPRINTSPEED
		camera.set_fov(move_toward(camera.get_fov(), 90, 3))
		
	elif !Input.is_action_pressed("SPRINT"):
		currSpeed = SPEED
		camera.set_fov(move_toward(camera.get_fov(), 75, 3))
	
	#print(is_on_floor())
	
	horzVel = Vector3(velocity.x, 0, velocity.z)
	vertVel = velocity.y
	
	if not is_on_floor() and velocity.y > -55:
		velocity.y = velocity.y - 0.5


	# Handle jump.
	if Input.is_action_pressed("JUMP") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	elif Input.is_action_pressed("JUMP") and not is_on_floor() and jumpBoostAvailable:
		velocity.y = JUMP_VELOCITY * 2.5
		jumpBoostCD.emit()
		jumpBoostAvailable = false
	
	
	if Input.is_action_pressed("CROUCH"):
		currSpeed = SPEED / 2
		scale = Vector3(0.75, 1, 1)
		velocity.y = JUMP_VELOCITY * -1

	if !Input.is_action_pressed("CROUCH") and !Input.is_action_pressed("JUMP"):
		currSpeed = SPEED
		scale = Vector3(1, 1, 1)
	
	var buttonInput := Input.get_vector("A_PRESS", "D_PRESS", "W_PRESS", "S_PRESS")
	var inputConvert := transform.basis * Vector3(buttonInput.x, buttonInput.y, 0)
	var direction := (transform.basis * Vector3(buttonInput.x, 0, buttonInput.y)).normalized()
	
	if direction:
		velocity.x = direction.x * currSpeed
		velocity.z = direction.z * currSpeed
		if (Input.is_action_pressed("SPRINT")):
			camera.set_fov(move_toward(camera.get_fov(), 90, 3))
			velocity.x *= 2
			velocity.z *= 2
		#	velocity.y *= 2
	else:
		velocity.x = move_toward(velocity.x, 0, currSpeed)
		velocity.z = move_toward(velocity.z, 0, currSpeed)
		#velocity.y = move_toward(velocity.y, 0, currSpeed)
		
		
	move_and_slide()

func _unhandled_input(event) -> void:
	if event is InputEventMouseMotion:
		
		#GETTING STUCK? PROBABLY CAUSED BY UP/DOWN ROTATION APPLYING TO COLLISION PILL AND NOT CAMERA NODE
		
		mouseInput = event.screen_relative
		#print(mouseInput)
		#print(rotation.x, rotation.y)
		if (rotation.x > -0.65 && rotation.x < 0.65):
			rotation.x -= mouseInput.y * 0.004
		elif (rotation.x > 0.65):
			rotation.x = 0.65
		elif (rotation.x < -0.65):
			rotation.x = -0.64
			
		camera.rotation.x = rotation.x
		rotation.y -= mouseInput.x * 0.004


func _on_jump_boost_cd_timeout() -> void:
	jumpBoostAvailable = true


func _on_oob_area_entered(area: Area3D) -> void:
	await get_tree().create_timer(1).timeout
	set_position(RESPAWNANCHOR)
