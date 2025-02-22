extends Node2D

@onready var musica_fondo = $MusicPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play_music()
		
func play_music():
	if not musica_fondo.playing:
		musica_fondo.play()
		
func cambiar_musica(nueva_musica):
	musica_fondo.stop()
	musica_fondo.stream = nueva_musica
	musica_fondo.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
