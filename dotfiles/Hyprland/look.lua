-----------------------
---- LOOK AND FEEL ----
-----------------------
-- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config({
    general = {
        gaps_in  = 5,
        gaps_out = 8,
        border_size = 2,

        col = {
            active_border   = "rgba(107,31,173,1)",
            inactive_border = "rgba(77,77,77,1)",
        },
        snap = {
            enabled = true,
            respect_gaps = true,
        },
        -- Set to true to enable resizing windows by clicking and dragging on borders and gaps
        resize_on_border = true,

        -- Please see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/ before you turn this on
        allow_tearing = false,

        layout = "dwindle",
    },

    decoration = {
        rounding       = 10,
        rounding_power = 2,

        -- Change transparency of focused and unfocused windows
        active_opacity   = 1,
        inactive_opacity = 0.95,

        shadow = {
            enabled      = true,
            range        = 4,
            render_power = 3,
            color        = 0xee1a1a1a,
        },

        blur = {
            enabled   = false,
            passes = 3,
            size = 3,
            noise = 0.02,
            vibrancy = 0.5,
            xray = false,
        },
    },

    animations = {
        enabled = true,
    },
})