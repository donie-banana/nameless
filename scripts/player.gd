extends CharacterBody3D

@export var walk_speed: float = 7.0
@export var sprint_speed: float = 14.0
@export var jump_force: float = 15.0
@export var mouse_sensitivity: float = 0.002
@export var gravity: float = 30.0

@onready var camera_pivot: Node3D = $CameraPivot
@onready var pause_menu: CanvasLayer = null  # Wordt veilig opgezocht in _ready()

@export var health: float = 10

var velocity_y: float = 0.0
var rotation_y: float = 0.0
var rotation_x: float = 0.0
#var menutoggle: bool = false

func _ready() -> void:
	add_to_group("player")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and not get_tree().paused:
		rotation_y -= event.relative.x * mouse_sensitivity
		rotation_x -= event.relative.y * mouse_sensitivity
		rotation_x = clamp(rotation_x, -1.2, 1.2)

		rotation.y = rotation_y
		camera_pivot.rotation.x = rotation_x
		
	#if event.is_action_pressed("ui_cancel") and pause_menu:
		#if not menutoggle:
			#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			#_pause_game()
		#else:
			#_resume_game()

func _physics_process(delta: float) -> void:
	if get_tree().paused:
		return 

	var input_dir = Vector2.ZERO

	if Input.is_action_pressed("move_forward"):
		input_dir.y -= 1
	if Input.is_action_pressed("move_backward"):
		input_dir.y += 1
	if Input.is_action_pressed("move_left"):
		input_dir.x -= 1
	if Input.is_action_pressed("move_right"):
		input_dir.x += 1
	
	input_dir = input_dir.normalized()

	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	var current_speed = walk_speed
	if Input.is_action_pressed("sprint"):
		current_speed = sprint_speed

	if not is_on_floor():
		velocity_y -= gravity * delta
	else:
		if Input.is_action_just_pressed("jump"):
			velocity_y = jump_force
		else:
			velocity_y = 0.0

	velocity = direction * current_speed
	velocity.y = velocity_y

	move_and_slide()

func _pause_game() -> void:
	get_tree().paused = true
	if pause_menu:
		pause_menu.visible = true
	#menutoggle = true

func _resume_game() -> void:
	get_tree().paused = false
	if pause_menu:
		pause_menu.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#menutoggle = false
