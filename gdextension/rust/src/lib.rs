use std::str::FromStr;

use godot::{obj, prelude::*};

#[derive(GodotClass)]
#[class(base = RefCounted)]
struct VarargTest {
    #[base]
    base: Base<RefCounted>,
}

#[godot_api]
impl VarargTest {
    #[func]
    fn test(&self) -> GodotString {
        GodotString::from_str("Hello world!").unwrap()
    }
}

#[godot_api]
impl RefCountedVirtual for VarargTest {
    fn init(base: obj::Base<Self::Base>) -> Self {
        Self { base }
    }
}

#[derive(GodotClass)]
#[class(base = Node)]
struct TrackerController {
    #[base]
    base: Base<Node>,
}

#[godot_api]
impl TrackerController {
    #[signal]
    fn data_received();
}

#[godot_api]
impl NodeVirtual for TrackerController {
    fn init(base: Base<Node>) -> Self {
        Self { base }
    }
}

struct Vpuppr;

#[gdextension]
unsafe impl ExtensionLibrary for Vpuppr {}
