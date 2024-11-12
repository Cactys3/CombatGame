extends Weapon
var attacked_objects: Array[Node2D]
@onready var anim: AnimationPlayer = $AnimationPlayer
func _ready() -> void:
	super()
	
	pass 

func _process(_delta: float) -> void:
	super(_delta)
	
	pass

func attack():
	attacked_objects.clear()
	anim.play("stab")
	await get_tree().create_timer(0.5).timeout
	cooldown_timer = 0
	attacking = false





func _on_body_entered(body: Node2D) -> void:
	if (attacking && body.has_method("damage") && !attacked_objects.has(body)):
		print(body.name)
		var new_attack: Attack = Attack.new()
		new_attack.damage = weapon_damage
		new_attack.knockback = weapon_knockback
		new_attack.stun_time = weapon_stun
		new_attack.position = position
		new_attack.damage_effect = weapon_effect
		body.damage(new_attack)
		attacked_objects.append(body)
