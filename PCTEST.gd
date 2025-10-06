extends CharacterBody3D

var deltaUNIV
const WALKSPEED = 15
const SPRINTSPEED = 1.75
const CROUCHSPEED = 0.67
var currSpeed
const DASH_VELOCITY = Vector3(2, 0, 2)
signal dashCD()
var dashAvailable : bool = true
var dashENABLED : bool = false

const ACCEL = 2.5
const DECCEL = 5

const AIRBORNEMOD = Vector3(0.65, 1, 0.65)
const JUMP_VELOCITY = 18
const BOOST_VELOCITY : Vector3 = Vector3(3.3, 0.3, 3.3)
signal jumpBoostCD()
var jumpBoostAvailable : bool = true


const RESPAWNANCHOR = Vector3(0, 5, 0)

var GRAPPLE_VELOCITY : Vector3 = Vector3(0.2, 0.75, 0.2) #DONT FUCK WITH THE VECTOR
var grappleAvailable : bool = false
#signal grappleFind 
var grappleVector : Vector3

var mouseInput : Vector2

@onready var initial_position := position
@onready var resGravity: Vector3 = ProjectSettings.get_setting("physics/3d/default_gravity") * ProjectSettings.get_setting("physics/3d/default_gravity_vector")
var resGravVec = ProjectSettings.get_setting("physics/3d/default_gravity_vector")
var resGrav = ProjectSettings.get_setting("physics/3d/default_gravity")
var gravity = resGravity

#resGravVec = resets gravity direc after a grapple, gravity is erratic without
#resGrav = resets gravity strength after a grapple
#gravity = used once just to make sure player returns to ground

@onready var camera = get_node("Camera3D")
const OFFSETDEF = 2


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	jumpBoostAvailable = true
	dashAvailable = true


func _physics_process(delta: float) -> void:
	deltaUNIV = delta
	
	if Input.is_action_just_released("QUIT") :
		get_tree().quit()
	if Input.is_action_just_pressed("RESET") :
		#print(get_tree().current_scene)
		#get_tree().change_scene_to_file("res://Lucidity.tscn")
		set_position(RESPAWNANCHOR)
	
	
	var buttonInput := Input.get_vector("A_PRESS", "D_PRESS", "W_PRESS", "S_PRESS")
	#var inputConvert := transform.basis * Vector3(buttonInput.x, buttonInput.y, 0)
	var direction := (transform.basis * Vector3(buttonInput.x, 0, buttonInput.y)).normalized()
	
	
	if direction or Input.is_action_pressed("JUMP") or Input.is_action_pressed("CROUCH") :
		velocity.x = direction.x * WALKSPEED
		velocity.z = direction.z * WALKSPEED
		
		if (Input.is_action_pressed("SPRINT")) :
			camera.set_fov(move_toward(camera.get_fov(), 90, 3))
			velocity.x *= SPRINTSPEED
			velocity.z *= SPRINTSPEED
		elif not (Input.is_action_pressed("SPRINT")) :
			camera.set_fov(move_toward(camera.get_fov(), 75, 3))
			#velocity.x /= SPRINTSPEED
			#velocity.z /= SPRINTSPEED
		# Handle jump.
		if Input.is_action_just_pressed("JUMP") and is_on_floor() :
			velocity.y += JUMP_VELOCITY
		elif Input.is_action_just_pressed("JUMP") and not is_on_floor() and jumpBoostAvailable :
			velocity *= BOOST_VELOCITY 
			velocity.y += 30
			jumpBoostCD.emit()
			jumpBoostAvailable = false
			#print("JUMP BOOST USED")
	
		if Input.is_action_pressed("DASH") and dashAvailable :
			dashAvailable = false
			dashENABLED = true
			#print("DASHED")
			dashCD.emit()
		
		if dashENABLED :
			velocity.x *= DASH_VELOCITY.x
			velocity.z *= DASH_VELOCITY.z
			#print("ENABLED NOW")
		
		if Input.is_action_pressed("CROUCH") and is_on_floor() :
			velocity.x *= CROUCHSPEED
			velocity.z *= CROUCHSPEED
			camera.set_v_offset(1)
	
	if not is_on_floor() : # and not (grappleAvailable and Input.is_action_pressed("GRAPPLE")):
		velocity.y -= delta * 45
	
	
	if !Input.is_action_pressed("SPRINT") and is_on_floor() and not direction:
		#velocity.x = direction.x * WALKSPEED
		#velocity.z = direction.z * WALKSPEED
		camera.set_fov(move_toward(camera.get_fov(), 75, 3))
		
	if !Input.is_action_pressed("CROUCH"):
		camera.set_v_offset(OFFSETDEF)
	
	
	if (grappleAvailable) and (Input.is_action_pressed("GRAPPLE")):
		#Maybe add animation code here?
		pass
	
	if is_on_floor():
		velocity.x = move_toward(velocity.x, 0, DECCEL)
		velocity.z = move_toward(velocity.z, 0, DECCEL)
	
	#if (abs(velocity.x) > 45):
	#	velocity.x = 44.5
		
	#if (abs(velocity.y) > 90):
	#	velocity.y = 89.5
		
	#if (abs(velocity.z) > 45):
	#	velocity.z = 44.5
	
	_DEBUG_PRINTOUTS()
	move_and_slide()


func _unhandled_input(event) -> void:
	if event is InputEventMouseMotion:
		
		#GETTING STUCK? PROBABLY CAUSED BY UP/DOWN ROTATION APPLYING TO COLLISION PILL AND NOT CAMERA NODE
		
		mouseInput = event.screen_relative
		#print(mouseInput)
		camera.rotation.x = rotation.x
		rotation.y -= mouseInput.x * 0.004
		#print(rotation.x, rotation.y)
		if (rotation.x > -0.65 && rotation.x < 0.65):
			rotation.x -= mouseInput.y * 0.004
		elif (rotation.x > 0.65):
			rotation.x = 0.65
		elif (rotation.x < -0.65):
			rotation.x = -0.64


func _DEBUG_PRINTOUTS() -> void:
	#print("VELOCITY:")
	#print(velocity)
	pass
	
func _on_oob_playeroob() -> void:
	set_position(RESPAWNANCHOR)


func _on_area_3d_area_entered(area: Area3D) -> void: #Player entered domain of grapple mote, grapple is available
	grappleAvailable = true
	#print("GRAPPLED")


func _on_area_3d_area_exited(area: Area3D) -> void: #Player left range of mote, reset gravity and deactivate grapple
	grappleAvailable = false
	_GRAV_RESET()


func _GRAV_RESET() -> void:
	ProjectSettings.set_setting("physics/3d/default_gravity_vector", Vector3(0,-1,0))
	ProjectSettings.set_setting("physics/3d/default_gravity", 9.8)


func _on_grapple_mote_mote_pos(moteData: Vector3) -> void:
	if (grappleAvailable && Input.is_action_pressed("GRAPPLE")):
		grappleVector = (moteData - position)
		velocity.x += grappleVector.x * GRAPPLE_VELOCITY.x
		velocity.y = (grappleVector.y * GRAPPLE_VELOCITY.y) - (deltaUNIV * 45)
		velocity.z += grappleVector.z * GRAPPLE_VELOCITY.z
		#DONT FUCK WITH THE MATH
		print(grappleVector)
	else:
		_GRAV_RESET()


func _on_jbcld_timeout() -> void:
	jumpBoostAvailable = true
	#print("JUMP IS BACK")

func _on_dashcld_timeout() -> void:
	dashAvailable = true
	#print("DASH IS BACK")

func _on_dashenbld_timeout() -> void:
	dashENABLED = false
	#print("DISABLED")

func _on_oob_area_entered(area: Area3D) -> void:
	await get_tree().create_timer(1).timeout
	set_position(RESPAWNANCHOR)
