extends Resource
class_name StatusEffects

## Handles Keeping track of current status/elemental affect values and executing appropriate calls

## use signals to send when a status affect starts/ends?
## or just use booleans?
## both i think.


@export var statsbase = { #everything must be default at 0 because they are always added in add_stats and should default to adding 0
	"balh": 0.0,
	"balasdh": 0.0}

## Defense Values
@export var defense_burning: float 
@export var defense_frost: float 
@export var defense_poison: float 
@export var defense_bleed: float
@export var defense_shock: float
@export var defense_wet: float 
## Attack Values
@export var attack_burning: float
@export var attack_frost: float  
@export var attack_poison: float 
@export var attack_bleed: float  
@export var attack_shock: float
@export var attack_wet: float 
## Current Buildup Values
var burning: float
var frost: float 
var poison: float 
var bleed: float 
var shock: float
var wet: float
## Effect Status
var is_burning: bool = false

signal set_burning(bool, float)

var threshhold: float = 10

## on attack, they send Stats resource? No, 
## On Attack, Entity this self is on adds buildup values itself

func add_burning(x: float):
	if x > 0:
		burning += x
	if !is_burning && burning > threshhold:
		is_burning = true
		set_burning.emit(true, burning - threshhold)


func _process(delta: float) -> void:
	
	if burning > 0:
		burning -= delta
		if burning <= threshhold:
			set_burning.emit(false, 0)
			is_burning = false
		if burning < 0:
			burning = 0
