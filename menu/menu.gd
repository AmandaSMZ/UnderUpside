extends Control

func _on_btn_start_pressed():
	#get_tree().change_scene_to_file("res:\\enviroment\environment.tscn")
	if ResourceLoader.exists("res://environment/environment.tscn"):
		get_tree().change_scene_to_file("res://environment/environment.tscn")
	else:
		print(" ERROR: La escena no existe o la ruta está mal escrita")


func _on_btn_end_pressed():
	get_tree().quit()

func _ready():
	# La música de fondo se reproduce de manera global
	ReproductorMusica.play_music()
