extends Node

enum Block {AIR, WATER, DIRT, GRASS}

var loadedWorld = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	_loadWorld()

func blockForPosition(position: Vector3) -> int:
	if position.y > 64 or position.y < 63:
		return Block.AIR
	else:
		return Block.DIRT

func _loadWorld():
	pass
