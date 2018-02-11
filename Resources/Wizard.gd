extends KinematicBody2D

const SPEEDFACTOR = 100;
const BALANCERECOVERY = 1;
const KNOCKEDRECOVERY = 2;

enum WIZARDS {
	OG,
	W117,
	Speedo,
	Arcane,
	Norwegian
}

var Wizard = WIZARDS.OG;
var Player = 0;
var Left = false;
var Right = false;
var CooldownMax = 0.3;
var Cooldown = CooldownMax;
var Vel = Vector2(0, 0);
var Gravity = 200;
var GravDir = Vector2(0, 1);
var Dir = Vector2();
var Acceleration = 2000;
var Deacceleration = 2000;
var Jump = false;
var WantJump = false;
var PropJump = 3;
var PropAttack = 1;
var PropDefence = 3;
var PropWeight = 0;
var PropSpeed = 3;
var PropWizarding = 3;
var Balance = PropDefence;
var Recovery = 0;
var Knocked = false;
var Percent = 0;

func _ready():
	set_process(true);
	set_physics_process(true);

func _process(delta):
	var move = false;
	
	# Recovery Cooldown
	if (Balance < PropDefence || Knocked == true):
		Recovery += delta;
		if (Recovery >= BALANCERECOVERY && Knocked == false):
			Recovery = 0;
			Balance += 1;
		elif (Recovery >= KNOCKEDRECOVERY && Knocked == true):
			Recovery = 0;
			Knocked = false;
			Balance += 1;
	
	# Attack Cooldown
	if (Cooldown < 0):
		Cooldown = 0;
	elif (Cooldown > 0):
		Cooldown -= delta;
	
	# Player Controls
	if (Player > 0):
		if (Input.is_action_pressed("left" + var2str(Player))):
			Dir.x -= 1;
			$Sprite.flip_h = true;
			move = true;
		if (Input.is_action_pressed("right" + var2str(Player))):
			Dir.x += 1;
			$Sprite.flip_h = false;
			move = true;
		if (Input.is_action_pressed("jump" + var2str(Player)) && Jump == true):
			_jump();
		
		if (Input.is_action_pressed("attack" + var2str(Player)) && Cooldown == 0):
			_attack();
	
	# AI
	if (Player == 0):
		# AI Logic
		if (get_parent().has_node("Wizard1") == true):
			if (get_parent().get_node("Wizard1").position.x > position.x):
				Right = true;
				Left = false;
			else:
				Left = true;
				Right = false;
		var prop_chance = rand_range(0.0, 1000.0);
		if (prop_chance >= 990.0 && prop_chance <= 999.9):
			WantJump = true;
		else:
			WantJump = false;
		# AI Controls
		if (Left == true):
			Dir.x -= 1;
			$Sprite.flip_h = true;
			move = true;
		if (Right == true):
			Dir.x += 1;
			$Sprite.flip_h = false;
			move = true;
		if (Jump == true && WantJump == true):
			_jump();
	
	# Physics movement
	Dir = Dir.normalized();
	if ((move == false && Knocked == false) || (Knocked == true && is_on_floor())):
		if (Vel.x > 0):
			Vel.x -= (Deacceleration * PropSpeed + 100) * delta;
			if (Vel.x < 0):
				Vel.x = 0;
		elif (Vel.x < 0):
			Vel.x += (Deacceleration * PropSpeed + 100) * delta;
			if (Vel.x > 0):
				Vel.x = 0;
	elif (Knocked == false):
		if (Dir.x < 0 && Vel.x > -(PropSpeed * SPEEDFACTOR + 100)):
			Vel += Dir * (Acceleration * PropSpeed) * delta;
		elif (Dir.x > 0 && Vel.x < (PropSpeed * SPEEDFACTOR + 100)):
			Vel += Dir * (Acceleration * PropSpeed) * delta;
	
	if (Knocked == true):
		$Sprite.rotation = deg2rad(90);
	else:
		$Sprite.rotation = deg2rad(0);
	Vel += (Gravity * PropWeight + 400) * GravDir * delta;

func _jump():
	if (Knocked == false):
		Jump = false;
		Vel.y = -300 - ((PropJump) * 100);

func _attack():
	Cooldown = CooldownMax;
	var jab = preload("res://Scenes/Jab.tscn").instance();
	jab.Player = Player;
	jab.Attack = PropAttack;
	jab.get_node("Sprite").flip_h = $Sprite.flip_h;
	if ($Sprite.flip_h == true):
		jab.get_node("Sprite").rotation = -PI;
		jab.rotation = PI;
	
	get_parent().add_child(jab);
	if ($Sprite.flip_h == false):
		jab.position = position + Vector2(96, 0);
	else:
		jab.position = position - Vector2(96, 0);

func jab(attack, left):
	Percent += 11 - PropDefence;
	# Get hit by jab
	if (left == false):
		Vel += Vector2(100 + (attack * 50), -300 - (attack * 100));
	else:
		Vel += Vector2(-100 - (attack * 50), -300 - (attack * 100));
	Balance -= 1;
	print("Balance: " + var2str(Balance));
	if (Balance <= 0):
		knock();

func knock():
	Balance = 0;
	Knocked = true;
	Recovery = 0;

func set_stats(wizard):
	Wizard = wizard;
	if (Wizard == WIZARDS.OG):
		$Sprite.texture = preload("res://Textures/wizard1.png");
		$Sprite.scale = Vector2(1, 1);
		PropAttack = 6;
		PropWizarding = 6;
		PropSpeed = 6;
		PropDefence = 6;
		PropJump = 6;
		PropWeight = 6;
		Balance = PropDefence;
	elif (Wizard == WIZARDS.W117):
		$Sprite.texture = preload("res://Textures/wizard1.png");
		$Sprite.scale = Vector2(1, 1);
		PropAttack = 4;
		PropWizarding = 0;
		PropSpeed = 3;
		PropDefence = 4;
		PropJump = 2;
		PropWeight = 2;
		Balance = PropDefence;
	elif (Wizard == WIZARDS.Speedo):
		$Sprite.texture = preload("res://Textures/wizard1.png");
		$Sprite.scale = Vector2(1, 1);
		PropAttack = 2;
		PropWizarding = 2;
		PropSpeed = 8;
		PropDefence = 0;
		PropJump = 3;
		PropWeight = 0;
		Balance = PropDefence;
	elif (Wizard == WIZARDS.Arcane):
		$Sprite.texture = preload("res://Textures/wizard2.png");
		$Sprite.scale = Vector2(0.4, 0.5);
		PropAttack = 1;
		PropWizarding = 7;
		PropSpeed = 3;
		PropDefence = 1;
		PropJump = 3;
		PropWeight = 0;
		Balance = PropDefence;
	elif (Wizard == WIZARDS.Norwegian):
		$Sprite.texture = preload("res://Textures/wizard1.png");
		$Sprite.scale = Vector2(1, 1);
		PropAttack = 1;
		PropWizarding = 8;
		PropSpeed = 1;
		PropDefence = 3;
		PropJump = 1;
		PropWeight = 1;
		Balance = PropDefence;

func _physics_process(delta):
	# Process movement
	move_and_slide(Vel, Vector2(0, -1));
	if (is_on_floor()):
		Jump = true;
		Vel.y = 0;
	if (is_on_wall()):
		Vel.x = 0;