extends CharacterBody2D

@onready var gravity: int = ProjectSettings.get("physics/2d/default_gravity")
@onready var jugadora = $"../../Jugadora"
@export var SPEED = 100.0
var sentido = 1
@export var gravedad_invertida = false

func _physics_process(delta: float) -> void:
	if jugadora.muerto :
		return
	velocity.y += gravity * delta
	velocity.x = SPEED*sentido
	
	if is_on_wall():
		sentido *= -1
		
	if gravedad_invertida:
		moverse($detect_techo_derecha,$detect_techo_izquierda)
	else:
		moverse($detect_suelo_derecha, $detect_suelo_izquierda)
		
	move_and_slide()

func _ready() -> void:
	$ani_demogorgon.play("default")
	if gravedad_invertida:
		gravity *= -1
		$ani_demogorgon.flip_v = true
	
func moverse(detector_derecha, detector_izquierda) -> void:
	if sentido == -1 && detector_izquierda.is_colliding():
		velocity.x = SPEED*sentido
		$ani_demogorgon.flip_h = true
	elif sentido == 1 && detector_derecha.is_colliding():
		velocity.x = SPEED*sentido
		$ani_demogorgon.flip_h = false
	else:
		sentido *= -1

func _on_enem_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("jugadores"):
		$enem_area/audio_ataque.play()
		body.perder_vida()
		
