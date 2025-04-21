extends Item
class_name ItemWeapon
var attachment: Attachment
var handle: Handle
var projectile: Projectile
var weapon: Weapon_Frame
var equipped: bool = false
var is_ready: bool = false

func setup(a: Attachment, h: Handle, p: Projectile):
	attachment = a
	handle = h
	projectile = p
	a.setdata()
	h.setdata()
	p.setdata()
	setdata()
	is_ready = true

func equip(new_weapon: Weapon_Frame):
	weapon = new_weapon
	equipped = true

func setdata():
	if attachment && handle && projectile:
		var cost = attachment.getdata().item_buy_cost + handle.getdata().item_buy_cost + projectile.getdata().item_buy_cost
		var itemname = attachment.getdata().item_name + handle.getdata().item_name + projectile.getdata().item_name
		var descrip = attachment.getdata().item_name + handle.getdata().item_name + projectile.getdata().item_name
		data.setdata(itemname, descrip, ItemData.WEAPON, "common", Color.BLUE, ItemData.MISSINGTEXTURE, cost, 0.6)
	pass #TODO: set data based on components

func getdata() -> ItemData:
	return data
