-- Default curves and animations, see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1}    } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1}    } })
hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1}       } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1}    } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1}     } })

-- Default springs
hl.curve("niri",           { type = "spring", mass = 1, stiffness = 800, dampening = 100 })
-- Animations
hl.animation({ leaf = "windows", enabled = true, speed = 2, spring = "niri" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 5, spring = "niri", style = "slide" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1, bezier = "easeOutQuint", style = "slide" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 0.1, spring = "niri" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 3, spring = "niri", style = "slidevert" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 2, spring = "niri", style = "slidefadevert" })
-- Ref https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/