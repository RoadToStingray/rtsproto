-----------------------------------------------------------------------------------
-- This implementation uses the default SimpleProject and the Project extensions are 
-- used to extend the SimpleProject behavior.

-- This is the global table name used by Appkit Basic project to extend behavior
Project = Project or {}

require 'script/lua/flow_callbacks'
require 'script/lua/tools'

Project.level_names = {
    menu = "content/levels/test_mainmenu",
	testmap = "content/levels/testmap",
	testmap2 = "content/levels/testmap2"
}

-- Can provide a config for the basic project, or it will use a default if not.
local SimpleProject = require 'core/appkit/lua/simple_project'
SimpleProject.config = {
	standalone_init_level_name = Project.level_names.menu,
	camera_unit = "core/appkit/units/camera/camera",
	camera_index = 1,
	shading_environment = nil, -- Will override levels that have env set in editor.
	create_free_cam_player = true, -- Project will provide its own player.
	exit_standalone_with_esc_key = true
}

-- Optional function by SimpleProject after level, world and player is loaded 
-- but before lua trigger level loaded node is activated.
function Project.on_level_load_pre_flow()
-- Spawn the player for all non-menu levels. level_name will be nil if this 
	-- is an unsaved Test Level.
--	print("☆level load pre flow start"☆)
	local level_name = SimpleProject.level_name
	print("level load pre flow start :-:-:- " .. level_name)
	if level_name == nil then --or level_name ~= Project.level_names.menu
		local view_position = Appkit.get_editor_view_position() or stingray.Vector3(0,-14,4)
		local view_rotation = Appkit.get_editor_view_rotation() or stingray.Quaternion.identity()
		--local Player = require 'script/lua/player'
		--Player.spawn_player(SimpleProject.level, view_position, view_rotation)
	elseif level_name == Project.level_names.menu then
		local MainMenu = require 'script/lua/mainmenu'
		MainMenu.start()
	elseif level_name == Project.level_names.testmap2 then
	    local GameUI = require 'script/lua/gameui'
	    GameUI.start()
	end
end

-- Optional function by SimpleProject after loading of level, world and player and 
-- triggering of the level loaded flow node.
function Project.on_level_shutdown_post_flow()
end

-- Optional function called by SimpleProject after world update (we will probably want to split to pre/post appkit calls)
function Project.update(dt)
    if stingray.Window then
        stingray.Window.set_show_cursor(true)
        stingray.Window.set_clip_cursor(false)
    end
end

-- Optional function called by SimpleProject *before* appkit/world render
function Project.render()
end

-- Optional function called by SimpleProject *before* appkit/level/player/world shutdown
function Project.shutdown()
end

return Project
