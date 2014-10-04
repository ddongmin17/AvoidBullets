
display.setStatusBar(display.HiddenStatusBar)

--[[-------------------
--- Game Components ---
---------------------]]--

--[[ GLOBAL VARIABLES ]]--
lvl = 1
movement_flag = "true" -- Controls objects to be moved or not
--collision_flag = "false" 
--finish_flag = "false"
starting_stage = "true" -- Allows to have consistant game_time throughout all levels
collision_counter = 5

--[[ VARIABLES ]]--
local mario
local bullet
local bomb
local stewie
local game_time = 5 -- Limits time for each level
local waiting_time = 6

local timer_0
local timer_1
local timer_2
local timer_3

--[[ GRAPHICS ]]--
local menuScreen -- Menu Screen (Starting Screen)
local menuScreen_background
local menuScreen_logo
local start_button
local about_button

local aboutScreen -- About Screen (After pressing About button)
local aboutScreen_background
local back_button
local credit_txt
local developed_txt
local time_txt
local reload_bg -- This variable is used to fix weirdness in transition betweeen backgrounds.
				-- Without this variable, when back button is pressed from about screen,
				-- screen changes to menu screen with black screen on back

local gameScreen -- Game Screen (After pressing game button)
local gameScreen_background
local life_bar_txt
local life_bar_1
local life_bar_2
local life_bar_3
local life_bar_4
local life_bar_5

local nextLvl_txt
local congrat_txt
local congrat_txt_2
local replay_button
local replay_button2

local pow
local gameOverScreen

--[[ PHYSICS ]]--
local physics = require("physics")
physics.start()
physics.setGravity(0,0)



--[[-------------------------------
-- Engines (functions/listeners) --
-------------------------------]]--

--[[ SCREENS ]]--
local openMenuScreen = {} --
local controlScreens = {} --
local back_to_menu = {} --


--[[ GRAPHCIS ]]--

local addAboutGraphics = {}
local addGameGraphics = {}

local removeMenuScreen = {}
local removeAboutScreen = {}

--[[ CONTROL ]]--

local startGame = {}
local addGameListeners = {}
local removeGameListener = {}
local move_mario = {}
local move_bullet = {}
local move_bomb = {}

local countDown = {}
local decreaseTime = {}

local toNextLevel = {}
local level = {}

local delay = {}
local delay_for_loading = {}

local game_over = {}

--[[----------------------------------------------------------------------------------------------------------------------------------------------


Flowchart




													MAIN
													  |
												opeMenuScreen
												      |
												controlScreen
													  |
											------------------------------------
											|	    			 			   |
									 addGameGraphics	     			addAboutGraphics
											&					 			   &
									 removeMenuScreen					  back_to_menu
											|					 			   |
										startGame		  				removeAboutScreen
											|
											|
									-----------------------------------------------------------------
									|				 	 |					|				 		|	
							  addGameListeners		 move_bullet		move_bomb	    ...	   	 countDown
							  		|														 		|
							  	onCollision												 		decreaseTime
							  	    &														 		|
							  	move_mario				 									    toNextLevel
									|														 		|
									|													   		  level
									|
							  	
								
----------------------------------------------------------------------------------------------------------------------------------------------]]--


-- main Function
local function main()
	openMenuScreen()
end

-- Starting Menu Screen (Logo, Start/About buttons will be appeared)
function openMenuScreen()

	menuScreen = display.newGroup() -- menuScreen Group contains Menu Background, Logo and Start/About button
	menuScreen_background = display.newImage( "images/bg4.jpg" )
	menuScreen_background:toBack()
	menuScreen:insert(menuScreen_background)

	menuScreen_logo = display.newImage( "images/logo2.png" )
	menuScreen_logo.x = 450
	menuScreen_logo.y = 180
	menuScreen:insert(menuScreen_logo)

	start_button = display.newImage( "images/start.png" )
	start_button.name = "start_button"
	start_button.x = 360
	start_button.y = 380
	menuScreen:insert(start_button)

	about_button = display.newImage( "images/about.png" )
	about_button.name = "about_button"
	about_button.x = 545
	about_button.y = 380
	menuScreen:insert(about_button)

	-- Start/About Button Listeners
	start_button:addEventListener("touch", controlScreens)
	about_button:addEventListener("touch", controlScreens)

end

-- controlScreens funtion will be called when Start/About Button is pressed
function controlScreens(event)
	if(event.target.name == "start_button") then

		menuScreen_logo.isVisible = false
		start_button.isVisible = false
		about_button.isVisible = false

		-- addGameGraphics will bring forth Game Background, Mario, Bullet and Bomb on screen
		addGameGraphics()
		transition.from(gameScreen, {time = 1000, y = display.contentHeight, transition = easing.outExpo, onComplete = removeMenuScreen})
		

	else
		menuScreen_logo.isVisible = false
		start_button.isVisible = false
		about_button.isVisible = false

		-- addAboutGraphics will bring forth About Background and few texts about credits
		addAboutGraphics()

		transition.from(aboutScreen, {time = 1000, x = (display.contentWidth)*2, transition = easing.outExpo})

		-- Back Button Listeners
		back_button:addEventListener("touch", back_to_menu)
	end
end

-- Bring forth Game Background, Mario, Bullet and Bomb on screen
function addGameGraphics ()

	gameScreen = display.newGroup() -- gameScreen Group contains Game background, Mario, Bullet and Bomb

	gameScreen_background = display.newImage( "images/bg3.jpg" )
	gameScreen_background:toBack()
	gameScreen:insert(gameScreen_background)

	bullet = display.newImage( "images/bullet.png" )
	bullet.x = 800
	bullet.y = 440
	gameScreen:insert(bullet)	
	
	bomb = display.newImage( "images/bomb.png" )
	bomb.x = 800
	bomb.y = 440
	gameScreen:insert(bomb)
	
	mario = display.newImage( "images/mario.png" )
	mario.x = 100
	mario.y = 100
	gameScreen:insert(mario)

	life_bar_txt = display.newText("Life:", 10, 0, native.systemFont, 25)
	gameScreen:insert(life_bar_txt)


	--[[ Named each life bar image (tiny mario on top-left screen) individually
		 It allows to disappear life bar one by one when there's collosion 		]]--

	life_bar_1 = display.newImage( "images/life.png" )
	life_bar_1.x = 80 + 1 * 20
	gameScreen:insert(life_bar_1)
	
	life_bar_2 = display.newImage( "images/life.png" )
	life_bar_2.x = 80 + 2 * 20
	gameScreen:insert(life_bar_2)

	life_bar_3 = display.newImage( "images/life.png" )
	life_bar_3.x = 80 + 3 * 20
	gameScreen:insert(life_bar_3)

	life_bar_4 = display.newImage( "images/life.png" )
	life_bar_4.x = 80 + 4 * 20
	gameScreen:insert(life_bar_4)

	life_bar_5 = display.newImage( "images/life.png" )
	life_bar_5.x = 80 + 5 * 20
	gameScreen:insert(life_bar_5)


end


-- Bring forth About Background and few texts about credits
function addAboutGraphics()

	aboutScreen = display.newGroup()

	aboutScreen_background = display.newImage( "images/bg5.jpg" )
	aboutScreen:insert(aboutScreen_background)
	
	back_button = display.newImage( "images/back.png")
	back_button.name = "back_button"
	back_button.x = 450
	back_button.y = 400
	aboutScreen:insert(back_button)

	credit_txt = display.newText("Credits", 361, 80, native.systemFont, 52)
	aboutScreen:insert(credit_txt)

	developed_txt = display.newText("Developed by Dong Min Shin", 100, 150, native.systemFont, 52)
	aboutScreen:insert(developed_txt)

	time_txt = display.newText("[C] 2013", 349, 230, native.systemFont, 52)
	aboutScreen:insert(time_txt)

end

-- Allows smooth transition between About Screen and Menu Screen
function back_to_menu()

	menuScreen_logo.isVisible = true
	menuScreen_background.isVisible = true
	start_button.isVisible = true
	about_button.isVisible = true

	reload_bg = display.newImage( "images/bg5.jpg" )
	reload_bg:toBack()

	transition.from(menuScreen, {time = 1000, x = -display.contentHeight , transition = easing.outExpo})
	removeAboutScreen()

end


function removeAboutScreen()
	aboutScreen:removeSelf()
	aboutScreen = nil
	
end


function removeMenuScreen()

	menuScreen:removeSelf()
	menuScreen = nil

	if (reload_bg ~= nil) then
		reload_bg:removeSelf()
		reload_bg = nil

	end
	startGame()

end


--[[----------------------------------------------------------------------------------------------------------------------------------------------
 
This is where it gets complicated.
* startGame function does,
	1. add Physics body
	2. call function that add event handlers (touch, collision event)
	3. call functions that allow images to float around randomly (bullet, bomb, stewie, )
	4. call function that limit a single level to a certain amount of time
	
Two possible cases for a level to be ended.
First, user survives throughout the set game time or Second, user (mario) collides with any obstacles.
For the first case, user goes to the next level. This case, endGame functions is called
* endGame function does,
	1. remove Physics body
	2. call functions that remove event handlers
	3. set the flag so that previously called functions for moving images around will stop self-looping
	4. call startGame function

--]]----------------------------------------------------------------------------------------------------------------------------------------------

function startGame()

	if(lvl == 1) then
		--[[ disply_to_next_lvl function is called here only when lvl == 1 since startGame function gets called whenever lvl is completed from
			 endgame(). Thus, to notify user that level 1 has started, display_to_next_lvl() has to be called here at the very beginning		
			 After displaying "Level 1," we need some time to let "Level 1" string to disappear.
			 Delaying 3 second gives enough time to show "START!!" strings after "Level 1" string disappears.									]]--
		display_to_next_lvl()
		timer.performWithDelay(3000, display_start, 1)
	end

	physics.addBody(bullet, "static", {density = 1.0, friction = 0.3, bounce = 0.2, isSensor = false})
	physics.addBody(bomb, "static", {density = 1.0, friction = 0.3, bounce = 0.2, isSensor = false})
	physics.addBody(mario, "dynamic", {density = 1.0, friction = 0.3, bounce = 0.2, isSensor = false})
	
	if(lvl == 2) then
		physics.addBody(stewie, "static", {density = 1.0, friction = 0.3, bounce = 0.2, isSensor = false})
	elseif(lvl == 3) then
		physics.addBody(cartman, "static", {density = 1.0, friction = 0.3, bounce = 0.2, isSensor = false})
	elseif(lvl == 4) then
		physics.addBody(simpson, "static", {density = 1.0, friction = 0.3, bounce = 0.2, isSensor = false})
	end



	addGameListeners()

	--[[ For each level, it takes 6 second to load up "Level #" and "START!!" message (3 second respectively).
		 Other than level 1, each level takes up 6 second to move moving objects into orignial place; thus there's no discrepancy in time.
		 However, level 1 does not need to move moving objects back so we performWithDelay 6 second to move bullet and bomb 			   ]]--
	if(lvl == 1) then
		timer.performWithDelay(6000, move_bullet, 1)
		timer.performWithDelay(6000, move_bomb, 1)
	elseif(lvl == 2) then
		move_bomb()
		move_bullet()
		move_stewie()
	elseif(lvl == 3) then
		move_bomb()
		move_bullet()
		move_stewie()
		move_cartman()
	elseif(lvl == 4) then
		move_bomb()
		move_bullet()
		move_stewie()
		move_cartman()
		move_simpson()
	end

	countDown()

end

--[[ Event Listener (Listening touch anywhere on the screen since addEventListener is attached to Runtime) ]]--
function addGameListeners()
	Runtime:addEventListener("touch", move_mario)
	Runtime:addEventListener("collision", onCollision)
end

--[[ Touch Listener for mario ]]--
function move_mario(event)
	if event.phase == "began" then
		transition.to(mario, {time = 1000, x = event.x, y = event.y})
	end
end

--[[ Define Movement for bullet ]]--
function move_bullet()
	if movement_flag == "true" then
		transition.to(bullet, {time = 2500,	x = math.random(43, 859), y = math.random(30, 480), onComplete = move_bullet})
	end
end

--[[ Define Movement for bomb ]]--
function move_bomb()
	if movement_flag == "true" then
		transition.to(bomb, {time = 2200, x = math.random(43, 859), y = math.random(30, 480), onComplete = move_bomb})
	end
end

--[[ Define Movement for stewie ]]--
function move_stewie()
	if movement_flag == "true" then
		transition.to(stewie, {time = 1800,	x = math.random(43, 859), y = math.random(30, 480), onComplete = move_stewie})
	end
end

--[[ Define Movement for cartman ]]--
function move_cartman()
	if movement_flag == "true" then
		transition.to(cartman, {time = 1300, x = math.random(43, 859), y = math.random(30, 480), onComplete = move_cartman})
	end
end

--[[ Define Movement for simpson ]]--
function move_simpson()
	if movement_flag == "true" then
		transition.to(simpson, {time = 900,	x = math.random(43, 859), y = math.random(30, 480), onComplete = move_simpson})
	end
end


--[[ Collision Listener ]]--
function onCollision(event)

	local pow = display.newImage( "images/pow.png" )
	pow.x = mario.x + 30
	pow.y = mario.y + 20
	pow.alpha = 1
	transition.to(pow, {time = 500, alpha = 0})

	if(collision_counter == 5) then
		transition.to(life_bar_5, {time = 500, alpha = 0})
	elseif(collision_counter == 4) then
		transition.to(life_bar_4, {time = 500, alpha = 0})
	elseif(collision_counter == 3) then
		transition.to(life_bar_3, {time = 500, alpha = 0})
	elseif(collision_counter == 2) then
		transition.to(life_bar_2, {time = 500, alpha = 0})
	elseif(collision_counter == 1) then
		transition.to(life_bar_1, {time = 500, alpha = 0})
		timer.performWithDelay(1000, game_over(), 1)
	end

	collision_counter = collision_counter - 1

end

function game_over()

	gameOverScreen = display.newGroup()

	game_over_screen_bg = display.newRect(0, 0, 900, 506)
	game_over_screen_bg:setFillColor(0, 0, 0)
	gameOverScreen:insert(game_over_screen_bg)
	game_over_screen = display.newImage( "images/gameover.jpeg" )
	gameOverScreen:insert(game_over_screen)

	transition.from(gameOverScreen, {time = 1000, x = -(display.contentWidth)*2 , transition = easing.outExpo})

	reload_bg = display.newImage( "images/bg3.jpg" )
	reload_bg:toBack()

	removeGameListener()
	--[[
	mario:removeSelf()

	if lvl == 1 then
		bomb:removeSelf()
		bullet:removeSelf()
	end

	if lvl == 2 then
		bomb:removeSelf()
		bullet:removeSelf()
		stewie:removeSelf()
	end

	if lvl == 3 then
		bomb:removeSelf()
		bullet:removeSelf()
		stewie:removeSelf()
		cartman:removeSelf()
	end

	if lvl == 4 then
		bomb:removeSelf()
		bullet:removeSelf()
		stewie:removeSelf()
		cartman:removeSelf()
		simpson:removeSelf()
	end
]]--
	replay_button2 = display.newImage( "images/menu2.png" )
	replay_button2.alpha = 0
	replay_button2.x = 430
	replay_button2.y = 370

	transition.to(replay_button2, {time = 6000, alpha = 1})

	replay_button2:addEventListener("touch", restart)

	
end

-- Removing Event Listeners when the game is over
function removeGameListener()
	Runtime:removeEventListener("touch", move_mario)
	Runtime:removeEventListener("collision", onCollision)
end

--[[ countDown function is used to run each level for specific amount of time ]]--
function countDown()
	if(starting_stage == "true") then
		-- For level 1, game_time has to have 6 more second than other levels due to discrepancy in time
		game_time = game_time + 6
	end
	timer_1 = timer.performWithDelay(1000, decreaseTime, game_time)
end

-- Helper function for countDown
function decreaseTime()
	game_time = game_time - 1
	if(game_time == 0) then
			game_time = 5
			timer.cancel(timer_1)
			endGame()
	end

	-- Setting starting_stage allows game_time to be equivalent throughout all levels except level 1.
	starting_stage = "false"
end

function endGame()

	removeGameListener()
	if(lvl < 4) then 
		display_lvl_completed()
	end

	-- Stops continuous random movement of objects
	movement_flag = "false"
	
	
	-- Putting all objects into their original place
	transition.to(mario, {time = 5000, x = 100, y = 100})
	transition.to(bullet, {time = 5000, x = 800, y = 440})
	transition.to(bomb, {time = 5000, x = 800, y = 440})

	if(lvl == 2) then
		transition.to(stewie, {time = 5000, x = 800, y = 440})		
	elseif(lvl == 3) then
		transition.to(stewie, {time = 5000, x = 800, y = 440})
		transition.to(cartman, {time = 5000, x = 800, y = 440})
	elseif(lvl == 4) then
		transition.to(stewie, {time = 5000, x = 800, y = 440})
		transition.to(cartman, {time = 5000, x = 800, y = 440})
		transition.to(simpson, {time = 5000, x = 800, y = 440})
	end


	if(lvl < 5) then
		lvl = lvl + 1
		if(lvl < 5) then
			-- Delaying 3 second gives enough time to show "Level #" strings after "Level # Completed!" string disappears
			timer_2 = timer.performWithDelay(3000, display_to_next_lvl, 1)
		end
	end
	
	-- If all lvl == 5 and reach this part, that means all levels has been completed successfully.
	-- Timer is no longer needed; thus we need to remove them
	if(lvl == 5) then
		completed_all_lvl()
		timer.cancel(timer_2)
		timer.cancel(timer_3)
	end


	print("continue")
end

function display_lvl_completed()
	completed_txt = display.newText("Level " .. lvl .. " Completed!", 270, 200, native.systemFont, 40)
	completed_txt.alpha = 1
	transition.to(completed_txt, { time = 3000, alpha = 0})
end

function display_to_next_lvl()
	nextLvl_txt = display.newText("Level " .. lvl, 350, 200, native.systemFont, 45)
	nextLvl_txt.alpha = 1
	transition.to(nextLvl_txt, {time = 3000, alpha = 0})
	if(lvl ~= 1) then
		level(lvl)
	end

end

function display_start()
	start_txt = display.newText("START!!", 340, 200, native.systemFont, 50)
	start_txt.alpha = 1
	transition.to(start_txt, {time = 3000, alpha = 0})

end

-- Display new objects for corresponding level
function level(lev)	

	-- Delaying 3 second gives enough time to show "START!!" string after "Level #" string disappears
	timer_3 = timer.performWithDelay(3000, display_start, 1)

	if lev == 2 then
		stewie = display.newImage( "images/level/lvl2.png" )
		stewie.alpha = 0
		stewie.x = 800
		stewie.y = 440
		transition.to(stewie, {time = 6000, alpha = 1})
		gameScreen:insert(stewie)
	elseif lev == 3 then
		cartman = display.newImage( "images/level/lvl3.png" )
		cartman.alpha = 0
		cartman.x = 800
		cartman.y = 440
		transition.to(cartman, {time = 6000, alpha = 1})
		gameScreen:insert(cartman)
	elseif lev == 4 then
		simpson = display.newImage( "images/level/lvl4.png" )
		simpson.alpha = 0
		simpson.x = 800
		simpson.y = 440
		transition.to(simpson, {time = 6000, alpha = 1})
		gameScreen:insert(simpson)
	end

	--[[ For each level, it takes 6 second to load up "Level #" and "START!!" message (3 second respectively).
		 Delaying 6 second before executing toNextLevel successfully even out discrepancy in time.				]]--
	timer.performWithDelay( 6000, toNextLevel, 1)

end

-- After loading up new objects, allow the old and new objects to move randomly constantly till the level ends
function toNextLevel()
	movement_flag = "true"
	startGame()	
end

function completed_all_lvl()

	
	physics.removeBody(mario)
	physics.removeBody(bullet)
	physics.removeBody(bomb)
	physics.removeBody(stewie)
	physics.removeBody(cartman)
	physics.removeBody(simpson)

	transition.to(mario, {time = 6000, alpha = 0})
	transition.to(bullet, {time = 6000, alpha = 0})
	transition.to(bomb, {time = 6000, alpha = 0})
	transition.to(stewie, {time = 6000, alpha = 0})
	transition.to(cartman, {time = 6000, alpha = 0})
	transition.to(simpson, {time = 6000, alpha = 0})

	congrat_txt = display.newText("Congratulations!", 230, 150, native.systemFont, 50)
	congrat_txt.alpha = 0
	congrat_txt_2 = display.newText("You've completed all levels!", 120, 220, systemFont, 50)
	congrat_txt_2.alpha = 0

	replay_button = display.newImage( "images/menu2.png" )
	replay_button.alpha = 0
	replay_button.x = 430
	replay_button.y = 370

	gameScreen:insert(congrat_txt)
	gameScreen:insert(congrat_txt_2)
	gameScreen:insert(replay_button)

	transition.to(congrat_txt, {time = 6000, alpha = 1})
	transition.to(congrat_txt_2, {time = 6000, alpha = 1})
	transition.to(replay_button, {time = 6000, alpha = 1})

	replay_button:addEventListener("touch", restart)

end
	
function restart()
--[[
	openMenuScreen()
	transition.from(menuScreen, {time = 1000, x = (display.contentWidth)*2 , transition = easing.outExpo})
	
	reload_bg = display.newImage( "images/bg3.jpg" )
	reload_bg:toBack()

	--gameScreen:removeSelf()
	--gameScreen = nil
]]--
	
	gameScreen:removeSelf()
	gameScreen = nil

	collision_counter = 5
	lvl = 1
	openMenuScreen()

end

main()







