extends CanvasLayer

const TREE_COL: int = 0

## Every toggleable page.
## Dictionary<String, Control> - Page name to page node.
var _pages := {}

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
		
		_pages[child.name] = child
		child.hide()
	
	categories.item_selected.connect(func() -> void:
		var item: TreeItem = categories.get_selected()
		var page_name: String = item.get_text(TREE_COL)
		
		for page in _pages.values():
			page.hide()
		_pages[page_name].show()
	)
	categories.set_selected(root.get_next(), TREE_COL)
	
	await get_tree().process_frame
	
	$VBoxContainer/HSplitContainer.split_offset = get_viewport().size.x * 0.2

#-----------------------------------------------------------------------------#
# Private functions
#-----------------------------------------------------------------------------#

#-----------------------------------------------------------------------------#
# Public functions
#-----------------------------------------------------------------------------#

