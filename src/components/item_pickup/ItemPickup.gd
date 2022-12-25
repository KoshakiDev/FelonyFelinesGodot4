extends Area2D


func _on_ItemPickup_area_entered(area):
	var item = area.owner
	if not item.is_in_group("ITEM"):
		return
	owner.item_manager.add_item(item)
