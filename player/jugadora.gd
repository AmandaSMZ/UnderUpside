extends CharacterBody2D

@export var gravity_scale = 2
@export var speed = 500
@export var acceleration = 600
@export var friction = 1500
@export var jump_force = -700
@export var air_acceleration = 2000

@onready var ani_player =$ani_jugadora

var is_gravity_inverted = false



func _physics_process(delta: float) -> void:
	var input_axis = Input.get_axis("mover_izquierda","mover_derecha")
	orientation()
	apply_gravity(delta)
	handle_acceleration(input_axis, delta)
	apply_friction(input_axis, delta)
	handle_jump()
	handle_air_acceleration(input_axis, delta)
	update_animation(input_axis)
	move_and_slide()
	end_game()
	
	
func orientation():
	if global_position.y > 200 and not is_gravity_inverted:
		is_gravity_inverted = true  # Invertimos la gravedad
	elif global_position.y <= 200 and is_gravity_inverted:
		is_gravity_inverted = false  # Restauramos la gravedad normal
# Add the gravity.
func apply_gravity(delta):
	#if not is_on_floor():
	#	velocity+=get_gravity() * delta * gravity_scale
	if not is_on_floor():
		var gravity_direction = 1
		# Si la gravedad está invertida, invertimos la dirección de la gravedad
		if is_gravity_inverted:
			gravity_direction = -1  # Invertimos la gravedad hacia arriba
		var gravity = 980
		velocity += Vector2(0, gravity_direction * gravity) * delta * gravity_scale

func is_resting():
	if is_on_floor() and not is_gravity_inverted:
		return true
	elif is_on_ceiling() and is_gravity_inverted:
		return true
	else:
		return false

func handle_acceleration(input_axis, delta):
	if not is_on_floor(): return
	if input_axis != 0:
		velocity.x = move_toward(velocity.x, speed*input_axis, acceleration*delta)
		
func apply_friction(input_axis, delta):
	if input_axis==0 and (is_on_floor() or is_on_ceiling()):
		velocity.x = move_toward(velocity.x, 0, friction*delta)
		
func handle_jump():
	if Input.is_action_pressed("saltar"):
		if is_on_floor() and not is_gravity_inverted:
			velocity.y = jump_force
		elif is_on_ceiling() and is_gravity_inverted:
			velocity.y = -jump_force
		
			
func handle_air_acceleration(input_axis, delta):
	if is_on_floor() or is_on_ceiling(): return
	if input_axis != 0:
		velocity.x = move_toward(velocity.x, speed*input_axis, air_acceleration *delta)
		
func update_animation(input_axis):
	if input_axis !=0:
		# velocidad de la animación será dependiente de la velocidad
		ani_player.speed_scale = velocity.length()/100
		ani_player.flip_h = (input_axis<0)
		ani_player.play("run")
	elif not is_on_floor():
		ani_player.play("jump")
	else:
		ani_player.speed_scale=1
		ani_player.play("idle")
		
	# Verificamos si la gravedad está invertida y volteamos el personaje
	if is_gravity_inverted:
		ani_player.flip_v = true  # Volteamos el personaje verticalmente para simular el "upside down"
	else:
		ani_player.flip_v = false  # Aseguramos que no esté volteado si la gravedad no está invertida
		
func end_game():
	if global_position.y > 800:
		call_deferred("reload_scene")
		
		
func reload_scene():
	get_tree().reload_current_scene()
