package = "awesome-battery_widget"
version = "1.0.0-1"

source = {
   url = "git+https://github.com/Aire-One/awesome-battery_widget.git",
   tag = "v1.0.0",
}

description = {
   summary = "A UPowerGlib based battery widget for the Awesome WM with a basic widget template mechanism! 🔋",
   homepage = "https://github.com/Aire-One/awesome-battery_widget",
   license = "MIT",
}

dependencies = {
   "lua >= 5.1, < 5.5",
}

build = {
   type = "builtin",
   modules = {
      ["awesome-battery_widget.init"] = "src/awesome-battery_widget/init.lua",
   },
   copy_directories = {
      "doc",
   },
}
