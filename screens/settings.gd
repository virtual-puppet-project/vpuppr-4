extends CanvasLayer

const TREE_COL: int = 0

#-----------------------------------------------------------------------------#
# Builtin functions
#-----------------------------------------------------------------------------#

func _ready() -> void:
	var categories: Tree = %Categories
	categories.hide_root = true
	var root: TreeItem = categories.create_item()
	
	var pages: PanelContainer = %Pages
	for child in pages.get_children():
		var ti: TreeItem = categories.create_item(root)
		ti.set_text(TREE_COL, child.name)
	
	
	await get_tree().process_frame
	
	$VBoxContainer/HSplitContainer.split_offset = get_viewport().size.x * 0.2

#-----------------------------------------------------------------------------#
# Private functions
#-----------------------------------------------------------------------------#

#-----------------------------------------------------------------------------#
# Public functions
#-----------------------------------------------------------------------------#

