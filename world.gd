extends Node2D

@export var game_stats: GameStats
@export var ball_speed = 50 

@onready var ship: Ship = $Ship
@onready var score_label: Label = $ScoreLabel
@onready var player_ball: PlayerBall = $PlayerBall
@onready var ball_health: BallHealth = $CanvasLayer/BallHealth

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Display the Player Ball's Health
	ball_health.set_max_hearts(player_ball.stats_component.health)
	ball_health.update_hearts(player_ball.stats_component.health)
	
	# Randomize the seed so no game is the same
	randomize() 
	
	# Position the ball
	player_ball.position = Vector2(80,200)
	# Make the ball move in a random direction upward
	player_ball.move_component.velocity = Vector2(randf_range(-1, 1), randf_range(-.1, -1)).normalized() * ball_speed
	
	# Put a scrore of 0 to begin with
	update_score_label(game_stats.score)
	game_stats.score_changed.connect(update_score_label)
	
	# Break the combo count when the ship is hit
	ship.stats_component.health_decreased.connect(func():
		game_stats.combo_count = 0
		#print_debug("Ship Hit! Combo Broken")
		)
	
	# Game Over is the ship/player is destroyed
	ship.tree_exiting.connect(func():
		await get_tree().create_timer(1.0).timeout # Quick code for a timer
		get_tree().change_scene_to_file("res://menus/game_over.tscn")
	)
	
	# Game over if the ball loses all health
	player_ball.tree_exiting.connect(func():
		await get_tree().create_timer(1.0).timeout # Quick code for a timer
		get_tree().change_scene_to_file("res://menus/game_over.tscn")
	)
	
	# Move to the next level if all portals are destroyed
	game_stats.no_more_portals.connect(func():
		await get_tree().create_timer(1.0).timeout # Quick code for a timer
		get_tree().change_scene_to_file("res://menus/game_over.tscn")
	)
	
	# Update the Ball Health GUI when the ball's health is changed
	player_ball.stats_component.health_changed.connect(func():
		#print_debug(player_ball.stats_component.health)
		ball_health.update_hearts(player_ball.stats_component.health)
		)
	
	
	# Get the number of EnemyPortals in the start of the level 
	# and store that number in the game stats
	var enemy_portal_total = get_children().filter(func(n):
		return n is EnemyPortal).size()
	print_debug(enemy_portal_total)
	# Set the number of enemy portals in the game stats
	game_stats.portal_count = enemy_portal_total

# Function to update the score label in the level GUI
func update_score_label(new_score: int) -> void:
	score_label.text = "Score: " + str(new_score)
