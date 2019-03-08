require("class")
local Action = class()
function Action:ctor()
    self.conditions = {}
    self.reactions = {}
    self.weights = {}
end
local function  update(t1,t2)
    -- body
    for k,v in pairs(t2) do 
        t1[k] =v 
    end 
end

function Action:add_condition(key, conditions)
    if not self.weights[key] then 
        self.weights[key] = 1
    end 

    if not self.conditions[key] then 
        self.conditions[key] = conditions
        return 
    end 
    update(self.conditions[key],conditions)
end 


function Action:add_reaction(key, reaction)
    if not self.conditions[key] then 
        error('Trying to add reaction \''..key..'\' without matching condition.' )
    end 
    if not self.reactions[key] then 
        self.reactions[key] = reaction
        return
    end 
    update(self.reactions[key],reaction)
end 


function Action:set_weight(key, value)
    if not self.conditions[key] then 
        error('Trying to set weight \''..key..'\' without matching condition.')
    end
    self.weights[key] = value
end 

return Action
