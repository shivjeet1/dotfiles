-- ### SHIVJEET1's HYPR CONFIG (v0.55+ Lua Version) ###

--------------------------------------------------
-- DYNAMIC PYWAL COLOR PARSER
--------------------------------------------------
local function get_pywal_colors()
    local colors = {}
    local pywal_path = os.getenv("HOME") .. "/.cache/wal/colors-hyprland.conf"
    local file = io.open(pywal_path, "r")
    assert(file, "pywal colors file not found: " .. pywal_path)

    if file then
        for line in file:lines() do
            local key, val = line:match("%$(%w+)%s*=%s*(.-)%s*$")
            if key and val then
                val = val:gsub("#.*$", ""):match("^%s*(.-)%s*$")
                if val:match("^#?%x%x%x%x%x%x$") then
                    local hex = val:gsub("^#", "")
                    val = "rgba(" .. hex .. "ff)"
                elseif not (val:match("^rgb") or val:match("^rgba") or val:match("^0x")) then
                    val = "rgba(" .. val .. "ff)"
                end
                colors[key] = val
            end
        end
        file:close()
    end

    return colors
end

local colors = get_pywal_colors()


--------------------------------------------------
-- MONITORS
--------------------------------------------------
hl.monitor({
    output = "eDP-1",
    mode = "highres@highrr",
    position = "0x0",
    scale = "1.25",
    bitdepth = 8,
})

hl.monitor({
    output = "",
    mode = "preferred",
    position = "auto",
    scale = "1",
    mirror = "eDP-1",
})


--------------------------------------------------
-- PROGRAM VARIABLES
--------------------------------------------------
local terminal = "kitty"
local editor = "kitty nvim"
local menu = "wofi --show drun"
local killbar = "killall waybar; waybar"
local mainMod = "SUPER"


--------------------------------------------------
-- AUTOSTART
--------------------------------------------------
hl.on("hyprland.start", function()
    hl.exec_cmd("nm-applet")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("waybar")
    hl.exec_cmd("sleep 1; cava.sh")
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("wal -R")
    hl.exec_cmd("systemctl --user start hyprpolkitagent")
    hl.exec_cmd("hyprpm reload")
end)


--------------------------------------------------
-- ENVIRONMENT VARIABLES
--------------------------------------------------
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")


--------------------------------------------------
-- LOOK AND FEEL
--------------------------------------------------
hl.config({
    general = {
        border_size = 2,
        ["col.active_border"] = {
            colors = { colors.color4, colors.background },
            angle = 45,
        },
        ["col.inactive_border"] = {
            colors = { colors.color5 },
            angle = 45,
        },
        gaps_in = 5,
        gaps_out = 7,
        resize_on_border = false,
        allow_tearing = false,
        layout = "master",
    },
    decoration = {
        rounding = 5,
        active_opacity = 1.0,
        inactive_opacity = 0.85,
        blur = {
            enabled = true,
            size = 3,
            passes = 1,
            vibrancy = 0.1696,
        },
    },
    dwindle = {
        preserve_split = true,
    },
    master = {
        new_status = "dwindle",

    },
    misc = {
        disable_hyprland_logo = true,
    },
    input = {
        kb_layout = "us",
        follow_mouse = 1,
        sensitivity = 0,
        touchpad = {
            natural_scroll = true,
        },
    },
})


--------------------------------------------------
-- GESTURES & DEVICES
--------------------------------------------------
hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace",
})

hl.device({
    name = "epic-mouse-v1",
    sensitivity = -0.5,
})


--------------------------------------------------
-- ANIMATIONS & CURVES
--------------------------------------------------
hl.curve("myBezier", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })

hl.animation({ leaf = "windows", enabled = true, speed = 5, bezier = "myBezier" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 5, bezier = "default", style = "popin 80%" })
hl.animation({ leaf = "border", enabled = true, speed = 8, bezier = "default" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 8, bezier = "default" })
hl.animation({ leaf = "fade", enabled = true, speed = 5, bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 6, bezier = "default" })


--------------------------------------------------
-- KEYBINDINGS
--------------------------------------------------
-- All binds use the single-string "MOD + KEY" form so hl.bind gets exactly
-- (keybind_string, dispatcher_or_function, opts?) -- this is what fixed the
-- "dispatcher must be a dispatcher ... or a lua function" errors.

hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.exit())

hl.bind(mainMod .. " + F", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + F", hl.dsp.window.resize({ x = 945, y = 501 }))
hl.bind(mainMod .. " + F", hl.dsp.window.center())

hl.bind(mainMod .. " + slash", function() hl.exec_cmd(menu) end)
hl.bind(mainMod .. " + SHIFT + Return", function() hl.exec_cmd(terminal) end)
hl.bind(mainMod .. " + SHIFT + W", function() hl.exec_cmd(killbar) end)

hl.bind(mainMod .. " + SHIFT + J", function() hl.dispatch(hl.dsp.layout("togglesplit")) end)
hl.bind(mainMod .. " + SHIFT + K", function() hl.dispatch(hl.dsp.layout("pseudo")) end)
hl.bind(mainMod .. " + SHIFT + L", function() hl.dispatch(hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" })) end)

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + left", function() hl.dispatch(hl.dsp.focus({ direction = "l" })) end)
hl.bind(mainMod .. " + right", function() hl.dispatch(hl.dsp.focus({ direction = "r" })) end)
hl.bind(mainMod .. " + up", function() hl.dispatch(hl.dsp.focus({ direction = "u" })) end)
hl.bind(mainMod .. " + down", function() hl.dispatch(hl.dsp.focus({ direction = "d" })) end)

-- Workspaces 1-9
for i = 1, 9 do
    hl.bind(mainMod .. " + " .. i, function() hl.dispatch(hl.dsp.focus({ workspace = i })) end)
    hl.bind(mainMod .. " + SHIFT + " .. i, function() hl.dispatch(hl.dsp.window.move({ workspace = i })) end)
end

-- Floating window cycle
hl.bind(mainMod .. " + j", function() hl.dispatch(hl.dsp.window.cycle_next()) end)
hl.bind(mainMod .. " + k", function() hl.dispatch(hl.dsp.window.cycle_next({ prev = true })) end)

-- Special workspace (scratchpad)
hl.bind(mainMod .. " + SHIFT + S", function() hl.dispatch(hl.dsp.workspace.toggle_special("magic")) end)

-- Lock screen
hl.bind("ALT + SHIFT + L", function() hl.exec_cmd("hyprlock") end)

-- Scroll through workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", function() hl.dispatch(hl.dsp.focus({ workspace = "e+1" })) end)
hl.bind(mainMod .. " + mouse_up", function() hl.dispatch(hl.dsp.focus({ workspace = "e-1" })) end)

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.drag({ resize = true }), { mouse = true })

-- Screenshots
hl.bind("Print", function() hl.exec_cmd("spectacle") end)

-- Resize with repeating binds
hl.bind(mainMod .. " + h", hl.dsp.layout("mfact -0.01"))
hl.bind(mainMod .. " + l", hl.dsp.layout("mfact +0.01"))

-- Laptop multimedia keys for volume and LCD brightness
-- FIX: hl.bind takes (keystring, fn, opts) -- NOT (mods, key, fn, opts).
-- The original code passed an empty-string mod as a separate argument,
-- which is what triggered the "dispatcher must be a dispatcher ... or a
-- lua function" errors on these lines.
hl.bind("XF86AudioRaiseVolume", function() hl.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+") end, { repeating = true, locked = true })
hl.bind("XF86AudioLowerVolume", function() hl.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-") end, { repeating = true, locked = true })
hl.bind("XF86AudioMute", function() hl.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle") end, { locked = true })
hl.bind("XF86AudioMicMute", function() hl.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle") end, { locked = true })
hl.bind("XF86MonBrightnessUp", function() hl.exec_cmd("brightnessctl s 5%+") end, { repeating = true, locked = true })
hl.bind("XF86MonBrightnessDown", function() hl.exec_cmd("brightnessctl s 5%-") end, { repeating = true, locked = true })


--------------------------------------------------
-- WINDOW & WORKSPACE RULES
--------------------------------------------------
hl.window_rule({
    name = "tdf-opacity",
    match = { title = ".*tdf.*" },
    opacity = "1.0 override 1.0 override 1.0 override",
})

hl.window_rule({
    name = "kitty-opacity",
    match = { title = ".*kitty.*" },
    opacity = "1.0 override 0.6 override 1.0 override",
})
hl.window_rule({
    name = "rxvt-opacity",
    match = { title = ".*rxvt.*" },
    opacity = "1.0 override 0.6 override 1.0 override",
})

for _, app in ipairs({ ".*mpv.*", ".*sxiv.*", ".*Camera.*" }) do
    hl.window_rule({
        name = app .. "-float",
        match = { title = app },
        float = true,
        center = true,
        size = { 920, 518 },
    })
end

hl.window_rule({
    name = "suppress-maximize-events",
    match = { class = ".*" },
    suppress_event = "maximize",
})

hl.window_rule({
    name = "fix-xwayland-drags",
    match = {
        class = "^$",
        title = "^$",
        xwayland = true,
        float = true,
        fullscreen = false,
        pin = false,
    },
    no_focus = true,
})

hl.window_rule({
    name = "move-hyprland-run",
    match = { class = "hyprland-run" },
    move = "20 monitor_h-120",
    float = true,
})

hl.window_rule({
    name = "browser-fakefullscreen",
    match = { class = "zen", float = false },
    fullscreen_state = "0 2",
})

hl.layer_rule({
    name = "wofi-blur",
    match = { namespace = "wofi" },
    blur = true,
    animation = "slide top",
    ignore_alpha = 0.5, 
})

hl.layer_rule({ 
    name = "rofi-blur",
    match = { namespace = "rofi" }, 
    blur = true, 
    ignore_alpha = 0.5, 
    animation = "fade",
})
