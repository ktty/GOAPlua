require("class")
local World = class()

function World:ctor()
	self.planners = {}
	self.plans = {}
end 

function World:add_planner(planner)
	table.insert(self.planners,planner)
end 

function World:calculate()
	self.plans = {}
	for _,v in pairs(self.planners) do 
		table.insert(self.plans,v.calculate())
	end 
end 
local function sum(plan)
	local s = 0 
	for _,v in pairs(plan)  do 
		s = s + v["g"]
	end 
	return s 
end 
function World:get_plan(debug)
	local _plans = {}
	for _,plan in pairs(self.plans) do 
		local _plan_cost = sum( plan )
		
		_plans[_plan_cost] = _plans[_plan_cost] or {}
		table.insert(_plans[_plan_cost],plan)
	end 
	if  debug then 
		local  i = 1
		for plan_score,plans in pairs(_plans) do 
			for _,plan in pairs(plans) do 
				print(i)
				for _,v in plan do 
					print("\t",v["name"])
				end 
				i = i + 1
				print("\n\tTotal cost",plan_score)
			end 
		end 
	end 
	for _,v in pairs(_plans) do 
		return v 
	end 
end

return World
