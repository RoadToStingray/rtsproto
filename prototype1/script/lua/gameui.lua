--[[
	Customized functions for controlling what happens for a particular loaded level.
	These classes should define any  of

	init(level)
	start(level)
	update(level, dt)
	shutdown(level)
	render(level)
]]--

local Util = require 'core/appkit/lua/util'
local SimpleProject = require 'core/appkit/lua/simple_project'

Project.MainMenu = Project.MainMenu or {}
local MainMenu = Project.MainMenu
MainMenu.custom_listener = MainMenu.custom_listener or nil

local start_time = 0

function MainMenu.start()
	if stingray.Window then
		stingray.Window.set_show_cursor(true)
	end

	if scaleform then
	    --現在の実装だと読み込まれているlevelが変わると、scaleformを読み込み治す必要がある
	    scaleform.Stingray.load_project_and_scene("s2d_projects/rts_ui.s2d/rts_ui") 
		--[[scaleform.Stingray.load_project("test_gameui.s2dproj", "s2d_projects/test_gameui")
		
		scaleform.Stage.set_view_scale_mode(1)
		--Register menu button mouse listener
		local custom_listener = MainMenu.custom_listener
		custom_listener = scaleform.EventListener.create(custom_listener, MainMenu.on_custom_event)
		MainMenu.custom_listener = custom_listener
		scaleform.EventListener.connect(custom_listener, scaleform.EventTypes.Custom)]]--
		
		print('gameuiを読み込むよ')
       	local loading = scaleform.Actor.load("gameui.s2dscene")
	    -- Remove the main menu scene
        scaleform.Stage.remove_scene_by_index(1)
        -- Add the loading scene
        scaleform.Stage.add_scene(loading)
        print('gameuiを読み込めたよ')
	end

	local level = SimpleProject.level
	start_time = stingray.World.time(SimpleProject.world)
	-- make sure camera is at correct location
	local camera_unit = SimpleProject.camera_unit
	local camera = stingray.Unit.camera(camera_unit, 1)
	stingray.Unit.set_local_pose(camera_unit, 1, stingray.Matrix4x4.identity())
	stingray.Camera.set_local_pose(camera, camera_unit, stingray.Matrix4x4.identity())

	Appkit.manage_level_object(level, MainMenu, nil)
end

function MainMenu.shutdown(object)
	if scaleform then
		scaleform.EventListener.disconnect(MainMenu.custom_listener)
		scaleform.Stingray.unload_project()
	end

	MainMenu.evt_listener_handle = nil
	Appkit.unmanage_level_object(SimpleProject.level, MainMenu, nil)
	if stingray.Window then
		stingray.Window.set_show_cursor(false)
	end
end

MainMenu.action = nil
function MainMenu.on_custom_event(evt)

end

local function perform_action()
	-- Load empty level
end

-- [[Main Menu custom functionality]]--
function MainMenu.update(object, dt)
	if MainMenu.action == nil  then
		local time = stingray.World.time(SimpleProject.world)
		local p = stingray.Application.platform()
		if time - start_time > 1 then
			if Appkit.Util.is_pc() then
				if stingray.Keyboard.pressed(stingray.Keyboard.button_id("1")) then
					MainMenu.action = "start"
				elseif stingray.Keyboard.pressed(stingray.Keyboard.button_id("esc")) then
					MainMenu.action = "exit"
				end
			elseif p == stingray.Application.XB1 or p == stingray.Application.PS4 then 
				if stingray.Pad1.pressed(stingray.Pad1.button_id(Appkit.Util.plat(nil, "a", nil, "cross"))) then
    				MainMenu.action = "start"
    			elseif stingray.Pad1.pressed(stingray.Pad1.button_id(Appkit.Util.plat(nil, "b", nil, "circle"))) then
    				MainMenu.action = "exit"
    			end
    		end

		end
	end
	perform_action()
end

return MainMenu
