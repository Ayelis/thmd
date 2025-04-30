# Library.gd
extends TextureRect

func _ready():
	print("Library area ready!")

func _on_door_pressed():
	print("Door opened!")
	GameManager.change_room("Transit")

func _on_dresser_pressed():
	print("Dresser accessed!")
	if(!GameManager.inventory[GameManager.ItemIDs.TRANSPASS]):
		GameManager.obtain_item(GameManager.ItemIDs.DAGGER)
		GameManager.obtain_item(GameManager.ItemIDs.ROBE)
		GameManager.obtain_item(GameManager.ItemIDs.ROPE)
		GameManager.obtain_item(GameManager.ItemIDs.GUN)
		GameManager.obtain_item(GameManager.ItemIDs.PAIL)
		GameManager.obtain_item(GameManager.ItemIDs.BULLHORN)
		GameManager.obtain_item(GameManager.ItemIDs.KEY)
		GameManager.obtain_item(GameManager.ItemIDs.FLYER)
		GameManager.learn_info(GameManager.InfoIDs.APPOINTMENT)
		GameManager.learn_info(GameManager.InfoIDs.SHACK)
		GameManager.learn_info(GameManager.InfoIDs.MANSION)
		GameManager.learn_info(GameManager.InfoIDs.CULTISTS)
		GameManager.learn_info(GameManager.InfoIDs.POLICE)
		GameManager.learn_info(GameManager.InfoIDs.TUNNEL)
