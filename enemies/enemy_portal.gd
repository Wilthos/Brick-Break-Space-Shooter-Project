class_name EnemyPortal
extends Node2D

@export var GreenEnemyScene: PackedScene
@export var YellowEnemyScene: PackedScene
@export var PinkEnemyScene: PackedScene

@export var game_stats: GameStats
@onready var damage_numbers_origin: Node2D = $DamageNumbersOrigin

var margin = 8
var spwan_range_x = 50
var screen_width = ProjectSettings.get_setting("display/window/size/viewport_width")

@onready var spawner_component: SpawnerComponent = $SpawnerComponent
@onready var green_enemy_spawn_timer: Timer = $GreenEnemySpawnTimer
@onready var yellow_enemy_spawn_timer: Timer = $YellowEnemySpawnTimer
@onready var pink_enemy_spawn_timer: Timer = $PinkEnemySpawnTimer
@onready var stats_component: StatsComponent = $StatsComponent
@onready var flash_component: FlashComponent = $FlashComponent
@onready var shake_component: ShakeComponent = $ShakeComponent
@onready var scale_component: ScaleComponent = $ScaleComponent
@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent
@onready var score_component: ScoreComponent = $ScoreComponent
@onready var variable_pitch_audio_stream_player: VariablePitchAudioStreamPlayer = $VariablePitchAudioStreamPlayer
@onready var portal_counts_component: PortalCountsComponent = $PortalCountsComponent



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	green_enemy_spawn_timer.timeout.connect(handle_spawn.bind(GreenEnemyScene,green_enemy_spawn_timer,2.0))
	yellow_enemy_spawn_timer.timeout.connect(handle_spawn.bind(YellowEnemyScene,yellow_enemy_spawn_timer,10.0))
	pink_enemy_spawn_timer.timeout.connect(handle_spawn.bind(PinkEnemyScene,pink_enemy_spawn_timer,20.0))
	
	game_stats.score_changed.connect(func(new_score: int):
		if new_score > 100:
			yellow_enemy_spawn_timer.process_mode = Node.PROCESS_MODE_INHERIT
		if new_score > 450:
			pink_enemy_spawn_timer.process_mode = Node.PROCESS_MODE_INHERIT
		)
		
	stats_component.no_health.connect(func():
		score_component.adjust_score()
		portal_counts_component.adjust_portal_count()
		)
		
	
		
	hurtbox_component.hurt.connect(func(hitbox: HitboxComponent):
		#scale_component.tween_scale()
		flash_component.flash()
		shake_component.tween_shake()
		variable_pitch_audio_stream_player.play_with_variance()
		#print("Green Enemy Health: ", stats_component.health)
		# Call function to diplay damage done
		DamageNumbers.display_number(hitbox.damage,damage_numbers_origin.global_position)
	)
	stats_component.no_health.connect(queue_free)
	
func handle_spawn(enemy_scene: PackedScene, timer: Timer, time_offset: float = 1.0) -> void:
	spawner_component.scene = enemy_scene
	var spawn_position = Vector2(global_position)
	#spawn_position = Vector2(randf_range(margin,screen_width-margin),-16)
	spawn_position = Vector2(randf_range(global_position.x-spwan_range_x,global_position.x+spwan_range_x),global_position.y-16)
	# Check if spawn will be out of bounds and adjust
	if spawn_position.x < 0.0:
		spawn_position.x = margin
		
	if spawn_position.x > screen_width-margin:
		spawn_position.x = screen_width-margin
		
	spawner_component.spawn(spawn_position)
	
	var spawn_rate = time_offset / (0.5 + (game_stats.score * 0.01))
	timer.start(spawn_rate+ randf_range(0.25,0.5))
