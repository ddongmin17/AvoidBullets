application = 
{
	content = 
    {
		width = 506,
        height = 900, 
		scale = "letterBox",
        xAlign = "center",
        yAlign = "center",
		--fps = 30,
		
		
        imageSuffix = {
		    ["@2x"] = 1.5,
            ["@4x"] = 3.0,
		},
		
	},

    --[[
    -- Push notifications

    notification =
    {
        iphone =
        {
            types =
            {
                "badge", "sound", "alert", "newsstand"
            }
        }
    }
    --]]    
}
