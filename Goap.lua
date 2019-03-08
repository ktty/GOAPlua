
function distance_to_state(state_1, state_2) 
    local _scored_keys = {} 
    local _score = 0
    for key,_ in pairs(state_2) do 
        local _value = state_2[key]
        
        if _value == -1 then 
        
        else 
            if _value ~= state_1[key] then 
                _score = _score + 1
            end 
            table.insert(_scored_keys,{key = 1})
        end 
    end 
    
    for key,v in pairs(state_1) do 
        if _scored_keys[key] ~= nil then 
        
        else 
            local _value = state_1[key]
            if _value ~= -1 then 
                if _value ~= state_2[key] then 
                    _score = _score + 1
                end 
            end 
        end 
    end 
    return _score
end 

function conditions_are_met(state_1, state_2)
    
    for k,v in pairs(state_2) do 
        if v == -1 then 

        else 
            if state_1[k] ~= v then 
                return false
            end 
        end 
    end 
    return true 
end 

local function compareTable(t1,t2)
    
    for k1,v1 in pairs(t1) do 
        if t1[k1] ~= t2[k1] then return false  end 
    end 
    return true 
end 

function node_in_list(node,node_list)
    local continue = false 
    for k1,v in pairs(node_list) do 
        if  node["name"] == v["name"] and compareTable(node["state"],v["state"]) then
            return true
        end 
    end 
    return false
end

function  create_node(path,state,name)
    path["node_id"] = path["node_id"] + 1
    path["nodes"][ path["node_id"] ] = {state = state, f =  0, g =  0, h =  0, p_id =  nil, id =  path['node_id'], name = name or ""}
    return copyTable(path["nodes"][ path["node_id"] ])
end

function astar(start_state, goal_state, actions, reactions, weight_table)
    local _path = {
        nodes =  {},
        node_id =  0,
        goal = goal_state,
        actions =  actions,
        reactions =  reactions,
        weight_table =  weight_table,
        action_nodes = {},
        olist =  {},
        clist =  {}
    }
    local _start_node = create_node(_path, start_state,'start')
    _start_node['g'] = 0
    _start_node['h'] = distance_to_state(start_state, goal_state)
    _start_node['f'] = _start_node['g'] + _start_node['h']
    
    _path['olist'][ _start_node['id'] ] = copyTable(_start_node)
    for k,v in pairs(actions) do 
        _path['action_nodes'][k] = create_node(_path, copyTable(v), k)
    end 
    
    return walk_path(_path)
end 

local function reverse(t)
    local tmp = {}
    local len = #t 
    for i=1,len do 
        local key = #t 
        tmp[i] = table.remove(t,key)
    end 
    return tmp 
end 
function  walk_path(path)
    local node = nil
    
    local _clist = path["clist"]
    local _olist = path["olist"]
    while next(_olist) ~= nil  do 
        --Find lowest node
        local _lowest = {node = nil ,f = 9000000}
        for _,next_node in pairs(_olist) do 
            if not _lowest["node"]  or next_node["f"] < _lowest["f"] then 
               _lowest["node"] = next_node["id"]
               _lowest["f"] = next_node["f"] 
            end 
        end 
        if _lowest["node"] then 
            node = path["nodes"][_lowest["node"] ]
        else 
            return 
        end 
        --Remove node with lowest rank
        _olist[ node["id"] ] = nil 

        --If it matches the goal, we are done
        if conditions_are_met(node['state'], path['goal']) then 
            local _path = {}

            while node['p_id'] do 
                table.insert(_path,node)
                node = path['nodes'][node['p_id']]
            end 

            return reverse(_path)
        end 
        --Add it to closed
        _clist[ node['id'] ] = node
        --Find neighbors
        local _neighbors = {}
        for action_name,_ in pairs(path['action_nodes']) do 
            if conditions_are_met(node['state'], path['action_nodes'][action_name]['state']) then 
                path['node_id']  =  path["node_id" ] + 1
                local _c_node = copyTable(node)
                _c_node["id"] = path["node_id"]
                _c_node["name"] = action_name

                for key,_ in pairs(path['reactions'][action_name]) do 
                    local _value = path['reactions'][action_name][key]

                    if _value ~=  -1 then 
                        _c_node['state'][key] = _value
                    end 
                end 

                path["nodes"][_c_node["id"] ] = _c_node
                table.insert(_neighbors,_c_node)
            end 
        end 
        for _,next_node in pairs(_neighbors) do 
            local _g_cost = node['g'] + path['weight_table'][next_node['name']]
            local  _in_olist, _in_clist = node_in_list(next_node, _olist), node_in_list(next_node, _clist)
            if _in_olist and _g_cost < next_node["g"] then 
                table.remove(_olist,next_node)
            end 

            if _in_clist and _g_cost < next_node["g"] then 
                _clist [ next_node["id"] ] = nil  
            end 

            if not _in_olist and not _in_clist then 
                next_node['g'] = _g_cost
                next_node['h'] = distance_to_state(next_node['state'], path['goal'])
                next_node['f'] = next_node['g'] + next_node['h']
                next_node['p_id'] = node['id']

                _olist[next_node['id']] = next_node
            end 
        end 
        
        
    end --end while 
    return {}
end 


