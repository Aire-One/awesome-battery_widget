local upower = require('lgi').require('UPowerGlib')
local textbox = require 'wibox.widget.textbox'

local string = { format = string.format }
local math = { floor = math.floor }

local setmetatable = setmetatable -- luacheck ignore: setmetatable

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

--- Update the battery widget with the given device.
--
-- This method can be called by the user but it was designed to be used
-- automatically by UPower thanks to the `UPowerGlib.Device` notify signal.
-- @tparam battery_widget self The battery_widget instance to update.
-- @tparam UPowerGlib.Device device The device to use for the update.
function battery_widget.update (self, device)
    local text

    if device.state == upower.DeviceState.CHARGING  then
        text = 'Full in ' .. battery_widget.to_clock(device.time_to_full)
    elseif device.state == upower.DeviceState.DISCHARGING then
        text = string.format('%3d', device.percentage) .. '%'
    else
        text = 'N/A'
    end

    self:set_markup(text)
end

--- battery_widget constructor.
--
-- This function creates a new `battery_widget` instance. This widget watches
-- the `display_device` status and report.
-- @treturn battery_widget The battery_widget instance build.
function battery_widget.new ()
    local widget = textbox()

    widget.update = battery_widget.update

    local display_device = upower.Client():get_display_device()
    display_device.on_notify = function (device) widget:update(device) end

    widget:update(display_device)

    return widget
end


function mt.__call(self, ...)
    return battery_widget.new(...)
end

return setmetatable(battery_widget, mt)
