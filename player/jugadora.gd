extends CharacterBody2D

@export var gravity_scale = 2
@export var speed = 500
@export var acceleration = 6000
@export var friction = 2000
@export var jump_force = -900
@export var air_acceleration = 2000

@onready var ani_player =$ani_jugadora
@onready var contador: Control = $Cnv_contador_gorras/nd_contador_gorras
@onready var control_vidas: Node = $Cnv_contador_vidas/ContadorVidas

var is_gravity_inverted = false
var gorras: int = 0
var vidas: int = 3
var muerto = false

func _ready() -> void:
	add_to_group("jugadores")
	contador.actualizar(0)
	ReproductorMusica.play_music()


func _physics_process(delta: float) -> void:
	var input_axis = Input.get_axis("mover_izquierda","mover_derecha")
	set_orientation()
	apply_gravity(delta)
	handle_acceleration(input_axis, delta)
	apply_friction(input_axis, delta)
	handle_jump()
	handle_air_acceleration(input_axis, delta)
	update_animation(input_axis)
	move_and_slide()
	
	
	
func set_orientation():
	if global_position.y > 32:
		is_gravity_inverted = true 
	elif global_position.y <= 32:
		is_gravity_inverted = false
		
# Add the gravity.
func apply_gravity(delta):
	if not is_resting():
		var gravity_direction = 1
		if is_gravity_inverted:
			gravity_direction = -1  # Cambia el sentido de la gravedad
		velocity += gravity_direction * get_gravity() * delta * gravity_scale

func is_resting():
	if not is_gravity_inverted:
		return is_on_floor()
	else:
		return is_on_ceiling()

func handle_acceleration(input_axis, delta):
	if is_resting():
		if input_axis != 0:
			velocity.x = move_toward(velocity.x, speed*input_axis, acceleration*delta)
			if is_gravity_inverted and input_axis < 0:
				velocity.x -= 100
			#print("Tocando:", is_resting(), " | velocity.x:", velocity.x)
			#print(speed," input", input_axis,"acel", acceleration,"del ", delta)
		
func apply_friction(input_axis, delta):
	if input_axis==0 and is_resting():
		velocity.x = move_toward(velocity.x, 0, friction*delta)
		
func handle_jump():
	if Input.is_action_pressed("saltar"):
		if is_resting():
			if not is_gravity_inverted:
				velocity.y = jump_force
			else:
				velocity.y = -jump_force
		
			
func handle_air_acceleration(input_axis, delta):
	if not is_resting():
		if input_axis != 0:
			velocity.x = move_toward(velocity.x, speed*input_axis, air_acceleration *delta)
		
func update_animation(input_axis):
	if input_axis !=0:
		ani_player.speed_scale = velocity.length()/100
		ani_player.flip_h = (input_axis<0)
		ani_player.play("run")
	elif not is_resting():
		ani_player.play("jump")
	else:
		ani_player.speed_scale=1
		ani_player.play("idle")
		
	if is_gravity_inverted:
		ani_player.flip_v = true
	else:
		ani_player.flip_v = false 
		
func add_gorra():
		gorras += 1
		contador.actualizar(gorras)
		
func perder_vida():
	vidas -=1
	control_vidas.actualizar_vidas()
	if vidas == 0:
		morir()
	else:
		$audio_golpe.play()
		
		
	
func morir():
	muerto = true
	set_physics_process(false)
	$ani_jugadora.play("die")
	ReproductorMusica.musica_fondo.stop()
	$audio_die.play()
	$tiempo.start()
	await $tiempo.timeout
	get_tree().change_scene_to_file("res://menu/menu.tscn")
