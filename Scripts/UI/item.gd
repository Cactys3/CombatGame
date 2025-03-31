extends Resource
class_name Item
## variables to init, getters would ask the 'underyling_item' for variable of specific thing?
var name: String = "name_not_set"
var ID: String = "id_not_set"
var texture: Texture
var description: String = "description_not_set"
var rarity: int
var underlying_item

## ideas for future
#var sound_on_hover
#var animation_on_hover
#var limited_time_offer # dissapears from shop after time
#var sellable
#var placeable
#var extra_lore
