extends Area2D
class_name Projectile


@export var speed: float = 0.0

# for fork_stone item
var fork_count: int = 0
var fork_amount: int = 10
var fork_spread: float = 360.0
var can_fork: bool = false
var last_hit_enemy = null

var damage: Vector2
var damage_multiplier: float
var crit_chance: float
var crit_multiplier: float = 1.0


func _process(delta: float):
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * speed * delta
	
	
func _on_body_entered(_body):
	execute_hit()
	
	
func calculate_hit_damage():
	var hit_damage: float = 0
	var hit_is_crit: bool = false
	
	hit_damage = randf_range(damage.x, damage.y)
	
	hit_damage *= damage_multiplier
	
	if randf()*100 < crit_chance:
		hit_is_crit = true
		var multiplier = (100.0 + crit_multiplier)/100.0
		hit_damage = hit_damage * multiplier
		
	return {
		"damage": hit_damage,
		"is_crit": hit_is_crit
	}
	
	
func execute_hit():
	queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	if area is AnimatedEnemy and area != last_hit_enemy:
		var enemy = area
		var hit = calculate_hit_damage()
		enemy.take_damage(hit.damage, hit.is_crit)
		
		if can_fork and fork_count > 0:
			call_deferred("spawn_fork_projectiles", enemy)
			
		queue_free()

func spawn_fork_projectiles(hit_enemy):
	if fork_amount <= 0: return
	
	var spread = deg_to_rad(fork_spread)
	
	var angle_step = 0.0
	if fork_amount > 1:
		angle_step = spread / (fork_amount - 1)
		
	var start_angle = rotation - (spread / 2.0)
	
	for i in range(fork_amount):
		var fork = duplicate()
		
		# ignore enemy hit by generating projectile
		fork.last_hit_enemy = hit_enemy
		
		get_tree().current_scene.add_child(fork)
		
		fork.global_position = global_position
		fork.scale = scale * 0.8
		fork.rotation = start_angle + (angle_step * i) + randf_range(-0.1, 0.1)
		
		fork.damage = Vector2(self.damage.x * 0.5, self.damage.y * 0.5)
		fork.damage_multiplier = self.damage_multiplier
		fork.crit_chance = self.crit_chance
		fork.crit_multiplier = self.crit_multiplier
		
		print(fork.damage)
		fork.fork_count = self.fork_count - 1
		fork.can_fork = true
		
		var timer = get_tree().create_timer(0.2)
		timer.timeout.connect(_reset_last_hit_enemy.bind(fork))
		
func _reset_last_hit_enemy(projectile):
	if is_instance_valid(projectile):
		projectile.last_hit_enemy = null
