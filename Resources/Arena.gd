extends Node

enum WIZARDS {
	OG,
	W117,
	Speedo,
	Arcane,
	Norwegian
}

func _ready():
	$Wizard1.Player = 1;
	$Wizard1.set_stats(WIZARDS.Arcane);
	$Wizard2.set_stats(WIZARDS.OG);
