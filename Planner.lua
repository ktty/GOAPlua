require("class")
require("Goap")
local Planner = class()
local function  update(t1,t2)
    -- body
    for k,v in pairs(t2) do 
        t1[k] =v 
    end 
end

function  Planner:ctor(...)
    -- body
    self.start_state = nil 
    self.goal_state = nil 
    self.values = {}
    for _,v in pairs({...}) do 
        self.values[v] = -1
    end  
    self.action_list = nil 
end

function Planner:state(kwargs)
    -- body
    local _new_state = copyTable(self.values)
    update(_new_state,kwargs)
    return _new_state
end

function Planner:set_start_state(kwargs)
    -- body
    local __invalid_states = {}
    for k,v in pairs(kwargs) do 
        if self.values[k] == nil then 
            error("Invalid states for world start state: "..k)
        end 
    end 
    self.start_state = self:state(kwargs)
end


function  Planner:set_goal_state(kwargs)
    --local __invalid_states = {}
    for k,v in pairs(kwargs) do 
        if self.values[k] == nil then 
            error("Invalid states for world goal state: "..k)
        end 
    end 
    self.goal_state = self:state(kwargs)
end

function Planner:set_action_list(action_list)
    -- body
    self.action_list = action_list
end

function Planner:calculate()
    -- body
    return astar(self.start_state,
        self.goal_state,
        copyTable(self.action_list.conditions),
        copyTable(self.action_list.reactions),
        copyTable(self.action_list.weights))
end


return Planner
