class_name GameStats

extends Resource

@export var score: int = 0 :
	set(value):
		score = value
		score_changed.emit(score)

@export var highscore: int = 0

@export var portal_count: int = 100 :
	set(value):
		portal_count = value
		if portal_count == 0:
			no_more_portals.emit()

@export var enemy_passed_count: int = 0 :
	set(value):
		enemy_passed_count = value
		
		
@export var enemy_destroyed_count: int = 0 :
	set(value):
		enemy_destroyed_count = value

@export var combo_count: int = 0 :
	set(value):
		combo_count = value
		
@export var maxcombo: int = 0

signal score_changed(new_score)
signal no_more_portals()
