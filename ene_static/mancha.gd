extends Area2D

@export var tamaño_limite: Vector2 = Vector2(16, 16)  # Tamaño objetivo
@export var duracion: float = 120.0  # Tiempo en segundos para alcanzar el tamaño
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("enemigos")
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", tamaño_limite, duracion)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_body_entered(body:Node2D) -> void :
	if body.is_in_group("jugadores"):
		body.get_node("ani_jugadora").play("golpe")
		body.perder_vida()
