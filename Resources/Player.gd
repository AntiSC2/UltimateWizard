extends KinematicBody2D

const SPEEDFACTOR = 100;

var CooldownMax = 0.3;
var Cooldown = CooldownMax;
var Vel = Vector2(0, 0);
var Gravity = 200;
var GravDir = Vector2(0, 1);
var Dir = Vector2();
var Acceleration = 2000;
var Deacceleration = 2000;
var Jump = false;
var PropJump = 3;
var PropAttack = 1;
var PropDefence = 3;
var PropWeight = 0;
var PropSpeed = 3;
var PropWizarding = 3;
var Knocked = false;

func _ready():
	set_process(true);
	set_physics_process(true);

func _process(delta):
	var move = false;
	
	if (Cooldown < 0):
		Cooldown = 0;
	elif (Cooldown > 0):
		Cooldown -= delta;
	
	if (Input.is_action_pressed("left")):
		Dir.x -= 1;
		$Sprite.flip_h = true;
		move = true;
	if (Input.is_action_pressed("right")):
		Dir.x += 1;
		$Sprite.flip_h = false;
		move = true;
	if (Input.is_action_pressed("jump") && Jump == true):
		Jump = false;
		Vel.y = -300 - ((PropJump) * 100);
	
	if (Input.is_action_pressed("attack") && Cooldown == 0):
		Cooldown = CooldownMax;
		var jab = preload("res://Scenes/Jab.tscn").instance();
		jab.get_node("Sprite").flip_h = $Sprite.flip_h;
		
		get_parent().add_child(jab);
		if ($Sprite.flip_h == false):
			jab.position = position + Vector2(96, 0);
		else:
			jab.position = position - Vector2(96, 0);
	
	Dir = Dir.normalized();
	if (move == false):
		if (Vel.x > 0):
			Vel.x -= (Deacceleration * PropSpeed) * delta;
			if (Vel.x < 0):
				Vel.x = 0;
		elif (Vel.x < 0):
			Vel.x += (Deacceleration * PropSpeed) * delta;
			if (Vel.x > 0):
				Vel.x = 0;
	else:
		if (Dir.x < 0 && Vel.x > -(PropSpeed * SPEEDFACTOR + 100)):
			Vel += Dir * (Acceleration * PropSpeed) * delta;
		elif (Dir.x > 0 && Vel.x < (PropSpeed * SPEEDFACTOR + 100)):
			Vel += Dir * (Acceleration * PropSpeed) * delta;
	
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
		Jump = true;
		Vel.y = 0;
	if (is_on_wall()):
		Vel.x = 0;