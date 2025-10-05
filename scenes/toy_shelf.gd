extends Node2D

func _ready():
	$BackButton.pressed.connect(return_to_fair)
	populate_shelf()
	
func populate_shelf():
	var collected_toys = GameManager.toys
	var toy_index_counter = 1
	var font = load("res://asstes/SuperAdorable-MAvyp.ttf")
	for toy in collected_toys:
		var toycontainer = VBoxContainer.new()
		var toynamelabel = Label.new()
		toynamelabel.text = GameManager.toy_names[toy]
		toynamelabel.add_theme_font_override("font", font)
		toynamelabel.add_theme_font_size_override("font_size", 24)
		
		var texrec = TextureRect.new()
		texrec.texture = GameManager.toy_textures[toy]
		texrec.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
		texrec.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		texrec.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS
		texrec.custom_minimum_size = Vector2(50, 50)
		texrec.size_flags_vertical = Control.SIZE_EXPAND_FILL 
		texrec.set_meta("toy_id", toy)
		
		toycontainer.add_child(texrec)
		toycontainer.add_child(toynamelabel)
		
		if toy_index_counter <= 3:
			$ShelfRow3.add_child(toycontainer)
		elif toy_index_counter <= 6:
			$ShelfRow2.add_child(toycontainer)
		else:
			$ShelfRow1.add_child(toycontainer)
		
		toy_index_counter += 1

func return_to_fair():
	get_tree().change_scene_to_packed(GameManager.preloaded_scenes["main"])
