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

signal score_changed(new_score)
signal no_more_portals()
