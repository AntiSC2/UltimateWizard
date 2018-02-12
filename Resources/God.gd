extends Node

var CurrentScene = null;

func _ready():
	var root = get_tree().get_root();
	CurrentScene = root.get_child(root.get_child_count() - 1);

func change_scene(path):
	call_deferred("_deferred_change_scene", path);

func _deferred_change_scene(path):
	CurrentScene.free();
	var s = ResourceLoader.load(path);
	CurrentScene = s.instance();
	get_tree().get_root().add_child(CurrentScene);
	get_tree().set_current_scene(CurrentScene);