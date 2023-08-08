extends Resource
class_name PlantCardResource

enum types {Offensive,Defensive,Equipment}

@export var plant_name : String
@export var plant_type : types
@export var portrait : Texture2D
@export var cost : int
@export var growthtime : int
@export var plantPath : String
