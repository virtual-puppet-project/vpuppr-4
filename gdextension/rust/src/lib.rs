use std::str::FromStr;

use godot::prelude::*;

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
    fn init(base: godot::obj::Base<Self::Base>) -> Self {
        Self { base }
    }
}

struct Vpuppr;

#[gdextension]
unsafe impl ExtensionLibrary for Vpuppr {}
