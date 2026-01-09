extends BasicProjectile
class_name EnemyProjectile

var parent_enemy: Node2D

## Setup values specific to EnemyProjectile
func setup_enemy_projectile(new_parent_enemy: Node):
	parent_enemy = new_parent_enemy

func attack_body(body: Node2D, clone: bool) -> void:
	if is_instance_valid(parent_enemy):
		parent_enemy.damage_player_projectile(body)
