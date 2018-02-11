extends Area2D

var Player = -1;
var Attack = 0;
var Life = 0.1;

func _ready():
	set_process(true);

func _process(delta):
	Life -= delta;
	if (Life < 0):
		queue_free();

func _on_Jab_body_entered(body):
	if (body.has_method("jab") == true && body.Player != Player):
		body.jab(Attack, $Sprite.flip_h);
