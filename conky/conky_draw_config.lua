-- Define your visual elements here
-- For examples, and a complete list on the possible elements and their 
-- properties, go to https://github.com/fisadev/conky-draw/
-- (and be sure to use the lastest version)

elements = {
    {
        kind = 'bar_graph',
        conky_value = 'exec audioinfo vlc -p',
        from = {x = 0, y = 0},
        to = {x = 1920, y = 0},
        background_thickness = 4,
        background_color = 0x2b303b,
        bar_thickness = 4,
        bar_color = 0xbf616a
    }
}
