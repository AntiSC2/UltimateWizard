extends Control



func _on_Play_pressed():
	$Title.text = "Select Wizard";
	$Box.hide();
	$CharacterSelect.show();

func _on_Quit_pressed():
	get_tree().quit();


func _on_Cancel_pressed():
	$Title.text = "Ultimate Wizards IV";
	$Box.show();
	$CharacterSelect.hide();

func _on_Arcane_pressed():
	God.change_scene("res://Scenes/Arena.tscn");

func _on_Arcane_mouse_entered():
	$CharacterSelect/Panel/Preview.texture = preload("res://Textures/wizard2.png");


func _on_OG_mouse_entered():
	$CharacterSelect/Panel/Preview.texture = preload("res://Textures/wizard1.png");