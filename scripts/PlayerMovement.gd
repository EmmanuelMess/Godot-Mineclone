extends KinematicBody

const SPEED = 150
const SPEED_JUMP = 15
const FALL_ACCELERATION = -50

const mouseSensitivity = 0.3

var cameraAngle = 0

var deltaPosition = Vector3.ZERO
var deltaVelocity = Vector3.ZERO

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(deltaTime: float) -> void:
	var direction = Vector3.ZERO

	if Input.is_action_pressed("move_right"):
		direction.z += 1
	if Input.is_action_pressed("move_left"):
		direction.z -= 1
	if Input.is_action_pressed("move_back"):
		direction.x -= 1
	if Input.is_action_pressed("move_forward"):
		direction.x += 1
	if Input.is_action_pressed("move_jump"):
		direction.y += 1

	if is_on_floor():
		deltaVelocity.y = 0
		deltaVelocity.y += direction.y * SPEED_JUMP
	else:
		deltaVelocity.y += FALL_ACCELERATION * deltaTime

	deltaPosition += deltaVelocity * deltaTime

	deltaPosition.x = direction.x * SPEED * deltaTime
	deltaPosition.z = direction.z * SPEED * deltaTime
	#TODO clamp
	
	deltaPosition = deltaPosition.rotated(Vector3.UP, rotation.y)
	
	deltaPosition = move_and_slide(deltaPosition, Vector3.UP)

func _input(event):         
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * mouseSensitivity))
		
		var changev = -event.relative.y * mouseSensitivity
		if cameraAngle + changev > -50 and cameraAngle + changev < 50:
			cameraAngle += changev
			$Pivot.rotate_z(deg2rad(changev))
