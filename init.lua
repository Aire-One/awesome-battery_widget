local upower = require('lgi').require('UPowerGlib')

local gtable = require 'gears.table'
local wbase = require 'wibox.widget.base'

local setmetatable = setmetatable -- luacheck: ignore setmetatable
local screen = screen -- luacheck: ignore screen


local battery_widget = {}
local mt = {}

--- Helper function to convert seconds into a human readable clock string.
--
-- This translates the given seconds parameter into a human readable string
-- following the notation `HH:MM` (where HH is the number of hours and MM the
-- number of minutes).
-- @tparam number seconds The umber of seconds to translate.
-- @treturn string The human readable generated clock string.
function battery_widget.to_clock(seconds)
    if seconds <= 0 then
        return '00:00';
    else
        local hours = string.format('%02.f', math.floor(seconds/3600));
        local mins = string.format('%02.f', math.floor(seconds/60 - hours*60));
        return hours .. ':' .. mins
    end
end


--- Gives the default widget to use if user didn't specify one.
-- The default widget used is an `empty_widget` instance.
-- @treturn widget The default widget to use.
local function default_template ()
    return wbase.empty_widget()
end


--- battery_widget constructor.
--
-- This function creates a new `battery_widget` instance. This widget watches
-- the `display_device` status and report.
-- @tparam table args The arguments table.
-- @tparam[opt=1] screen|number args.screen the widget's screen.
-- @tparam[opt] widget args.widget_template The widget template to use to
--    create the widget instance.
-- @tparam[opt] function args.create_callback User defined callback for the
--    widget initialization.
-- @treturn battery_widget The battery_widget instance build.
function battery_widget.new (args)
    args = gtable.crush({
        widget_template = default_template(),
        create_callback = nil
    }, args or {})
    args.screen = screen[args.screen or 1]

    local widget = wbase.make_widget_from_value(args.widget_template)
    local display_device = upower.Client():get_display_device()

    if type(args.create_callback) == 'function' then
        args.create_callback(widget, display_device)
    end

    -- Attach signals:
    display_device.on_notify = function (device)
        widget:emit_signal('upower::update', device)
    end

    return widget
end


function mt.__call(self, ...)
    return battery_widget.new(...)
end

return setmetatable(battery_widget, mt)
