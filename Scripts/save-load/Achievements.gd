extends Node
class_name Achievement
## Simply holds consts for each achivement with their save/load string key
const TEST = "test"
## Also holds a runtime dictionary setup with all achievements and their values so we don't have to access JSON
static var achievements: Dictionary = {
	TEST = false
}
