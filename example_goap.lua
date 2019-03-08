
local World = require("World")
local Planner = require("Planner")
local Action = require("Action")
local world = Planner.new('hungry', 'has_food', 'in_kitchen', 'tired', 'in_bed')
world:set_start_state({hungry=true, has_food=false, in_kitchen=false, tired=true, in_bed=false})
--world:set_goal_state({tired=false})
world:set_goal_state({tired=false,has_food=true})
local actions = Action.new()
actions:add_condition('eat', {hungry=true, has_food=true, in_kitchen=false})
--actions:add_reaction('eat', {hungry=false})
actions:add_reaction('eat', {hungry=false,has_food=false})

actions:add_condition('cook', {hungry=true, has_food=false, in_kitchen=true})
actions:add_reaction('cook', {has_food=true})
actions:add_condition('sleep', {tired=true, in_bed=true})
actions:add_reaction('sleep', {tired=false})
actions:add_condition('go_to_bed', {in_bed=false, hungry=false})
actions:add_reaction('go_to_bed', {in_bed=true})
actions:add_condition('go_to_kitchen', {in_bed=false,in_kitchen=false})
actions:add_reaction('go_to_kitchen', {in_kitchen=true})
actions:add_condition('leave_kitchen', {in_kitchen=true})
actions:add_reaction('leave_kitchen', {in_kitchen=false})
actions:add_condition('order_pizza', {has_food=false, hungry=true})
actions:add_reaction('order_pizza', {has_food=true})
actions:add_condition("sleep_up",{in_bed=true})
actions:add_reaction("sleep_up",{in_bed=false,hungry=true})
actions:set_weight('go_to_kitchen', 2)
actions:set_weight('order_pizza', 20)

world:set_action_list(actions)

local t = os.clock()
local path = world:calculate()
local took_time = os.clock() - t 

for k,_p in pairs(path) do 
    print(k, _p['name'])
end 

print ('Took:', took_time)
