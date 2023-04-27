extends PanelContainer

const State := preload("res://gui/2d/png-tuber-config/state.tscn")

const TREE_COL: int = 0
const Menus := {
	FORWARD = "Forward",
	LEFT = "Left",
	RIGHT = "Right",
	UP = "Up",
	DOWN = "Down",
	CUSTOM = "Custom"
}

var _current_menu: Control = null
## State name to node.
var _menus := {}

#-----------------------------------------------------------------------------#
# Builtin functions
#-----------------------------------------------------------------------------#

func _ready() -> void:
	# TODO godot 4 fuckin sucks so this is necessary to get code completion
	var tree: Tree = %Tree as Tree
	var vc: VBoxContainer = %ViewContainer
	
	var root: TreeItem = tree.create_item()
	for menu_name in Menus.values():
		if menu_name == Menus.CUSTOM:
			continue
		
		var ti := tree.create_item(root)
		ti.set_text(TREE_COL, menu_name)
		
		var state := State.instantiate()
		state.state_name = menu_name
		# TODO init from config
		vc.add_child(state)
		_menus[menu_name] = state
		state.hide()
		
		if menu_name == Menus.FORWARD:
			tree.set_selected(ti, TREE_COL)
	
	# TODO custom state not yet implemented
	
	_select_menu(Menus.FORWARD)
	
	tree.item_selected.connect(func() -> void:
		_select_menu(tree.get_selected().get_text(TREE_COL))
	)

func _exit_tree() -> void:
	# TODO save on close
	pass

#-----------------------------------------------------------------------------#
# Private functions
#-----------------------------------------------------------------------------#

func _select_menu(menu_name: String) -> void:
	if _current_menu != null:
		_current_menu.hide()
	_current_menu = _menus[menu_name]
	_current_menu.show()

#-----------------------------------------------------------------------------#
# Public functions
#-----------------------------------------------------------------------------#

func save(config: PngTuberConfig) -> void:
	pass
