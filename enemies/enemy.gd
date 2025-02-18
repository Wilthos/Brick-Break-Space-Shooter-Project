class_name Enemy
extends Node2D

@export var game_stats: GameStats

@onready var stats_component: StatsComponent = $StatsComponent
@onready var move_component: MoveComponent = $MoveComponent
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D
@onready var scale_component: ScaleComponent = $ScaleComponent
@onready var flash_component: FlashComponent = $FlashComponent
@onready var shake_component: ShakeComponent = $ShakeComponent
@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent
@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var destroyed_component: DestroyedComponent = $DestroyedComponent
@onready var score_component: ScoreComponent = $ScoreComponent
@onready var variable_pitch_audio_stream_player: VariablePitchAudioStreamPlayer = $VariablePitchAudioStreamPlayer
@onready var damage_numbers_origin: Node2D = $DamageNumbersOrigin

func _ready() -> void:
	stats_component.no_health.connect(func():
		score_component.adjust_score()
		game_stats.enemy_destroyed_count += 1
		game_stats.combo_count += 1
		# Store the max combo for the level
		if game_stats.combo_count > game_stats.maxcombo: game_stats.maxcombo = game_stats.combo_count
		#print_debug("Enemies Destroyed:", game_stats.enemy_destroyed_count)
		#print_debug("Combo Count: ",game_stats.combo_count)
		)
	
	# Keep track of how many enemies get passed the player
	visible_on_screen_notifier_2d.screen_exited.connect(func():
		game_stats.enemy_passed_count += 1
		game_stats.combo_count = 0
		print_debug("Enemies Passed:", game_stats.enemy_passed_count)
		print_debug("Combo Broken! Max Combo: ",game_stats.maxcombo)
		)
		
	visible_on_screen_notifier_2d.screen_exited.connect(queue_free)
	
	hurtbox_component.hurt.connect(func(hitbox: HitboxComponent):
		scale_component.tween_scale()
		flash_component.flash()
		shake_component.tween_shake()
		variable_pitch_audio_stream_player.play_with_variance()
		#print("Green Enemy Health: ", stats_component.health)
		# Call function to diplay damage done
		DamageNumbers.display_number(hitbox.damage,damage_numbers_origin.global_position)
	)
	stats_component.no_health.connect(queue_free)
	hitbox_component.hit_hurtbox.connect(destroyed_component.destroy.unbind(1))
