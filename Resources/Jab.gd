extends Area2D

var Life = 0.1;

func _ready():
	set_process(true);

func _process(delta):
	Life -= delta;
	if (Life < 0):
		queue_free();

func _on_Jab_body_entered(body):
	if (body.has_method("_jab") == true):
		body.Knocked = true;
		if ($Sprite.flip_h == false):
			body.Vel = Vector2(1000, -500);
		else:
			body.Vel = Vector2(-1000, -500);
