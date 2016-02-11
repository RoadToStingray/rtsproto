ProjectFlowCallbacks = ProjectFlowCallbacks or {}
local Application = stingray.Application
local Level = s3d.Level

-- Example custom project flow node callback. Prints a message.
-- The parameter t contains the node inputs, and node outputs can
-- be set on t. See documentation for details.
function ProjectFlowCallbacks.example(t)
	local message = t.Text or ""
	print("Example Node Message: " .. message)
end


function ProjectFlowCallbacks.level_event(t)
    local message = t.text or "" -- note all custom node input variable names are converted to lower case
    local world = Application.flow_callback_context_world()
    local level = Application.flow_callback_context_level()
    flow_var = Level.trigger_event(level, message)
end