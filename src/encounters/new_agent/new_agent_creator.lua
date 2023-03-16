---@param context Encounter_creator_context
---@return integer encounter_probability
function Old_world_caravans:new_agent_creator(context)
  local caravan_force = context.caravan:caravan_force();

  if caravan_force:unit_list():num_items() >= 19 then
    return 0;
  end

  local faction = context.faction;
  local caravan_culture = faction:subculture();
  local hero_list = {};
  local probability = 1;

  for culture, agent in pairs(self.culture_to_agent_subtype) do
    if culture ~= caravan_culture then
      table.insert(hero_list, agent)
    end
  end

  if #hero_list == 0 then return 0 end

  if not cm:military_force_contains_unit_type_from_list(caravan_force, hero_list) then
    probability = 8;
  end

  ---@param region REGION_SCRIPT_INTERFACE
  ---@return boolean
  function node_has_agent(region)
    local region_culture = self:get_culture_of_node(region);
    local agent = self.culture_to_agent_subtype[region_culture];

    if not agent or region_culture == caravan_culture then
      return false;
    else
      return true;
    end
  end

  if node_has_agent(context.from) or node_has_agent(context.to) then
    return probability;
  else
    return 0
  end

end
