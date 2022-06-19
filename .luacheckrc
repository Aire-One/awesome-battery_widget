-- Only allow symbols available in all Lua versions
std = "min"

files["doc/config.ld"].ignore = { "111" }
files["spec/*_spec.lua"].std = "+busted"
files[".luacheckrc"].std = "+luacheckrc"

read_globals = {
   "awesome",
   "button",
   "dbus",
   "drawable",
   "drawin",
   "key",
   "keygrabber",
   "mousegrabber",
   "selection",
   "tag",
   "window",
   "table.unpack",
   "math.atan2",
}

globals = {
   "screen",
   "mouse",
   "root",
   "client",
}

cache = true

-- color = false
