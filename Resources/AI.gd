extends KinematicBody2D

const SPEEDFACTOR = 100;

var Left = false;
var Right = false;
var Vel = Vector2(0, 0);
var Gravity = 200;
var GravDir = Vector2(0, 1);
var Dir = Vector2();
var Acceleration = 2000;
var Deacceleration = 2000;
var Jump = false;
var PropJump = 1;
var PropAttack = 3;
var PropDefence = 3;
var PropWeight = 1;
var PropSpeed = 8;
var PropWizarding = 3;
var Knocked = false;

func _ready():
	set_process(true);
	set_physics_process(true);

func _process(delta):
	if (get_parent().has_node("Player") == true):
		if (get_parent().get_node("Player").position.x > position.x):
			Right = true;
			Left = false;
		else:
			Left = true;
			Right = false;
	var move = false;
	if (Knocked == false):
		if (Left == true):
			Dir.x -= 1;
			$Sprite.flip_h = true;
			move = true;
		if (Right == true):
			Dir.x += 1;
			$Sprite.flip_h = false;
			move = true;
		if (Jump == true):
			Jump = false;
			Vel.y = -300 - ((PropJump) * 100);
	
	Dir = Dir.normalized();
	if (move == false && Knocked == false):
		if (Vel.x > 0):
			Vel.x -= (Deacceleration * PropSpeed) * delta;
			if (Vel.x < 0):
				Vel.x = 0;
		elif (Vel.x < 0):
			Vel.x += (Deacceleration * PropSpeed) * delta;
			if (Vel.x > 0):
				Vel.x = 0;
	elif (Knocked == false):
		if (Dir.x < 0 && Vel.x > -(PropSpeed * SPEEDFACTOR + 100)):
			Vel += Dir * (Acceleration * PropSpeed) * delta;
		elif (Dir.x > 0 && Vel.x < (PropSpeed * SPEEDFACTOR + 100)):
			Vel += Dir * (Acceleration * PropSpeed) * delta;
	
	Vel += (Gravity * PropWeight + 400) * GravDir * delta;
	if (Knocked == true):
		$Sprite.rotation = deg2rad(90);
	else:
		$Sprite.rotation = deg2rad(0);
	Vel += (Gravity * PropWeight + 400) * GravDir * delta;

func _jab():
	pass

func _physics_process(delta):
	move_and_slide(Vel, Vector2(0, -1));
	if (is_on_floor()):
		Knocked = false;
		Jump = true;
		Vel.y = 0;
	if (is_on_wall()):
		Vel.x = 0;