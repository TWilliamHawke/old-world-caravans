---@param context Encounter_creator_context
---@return integer encounter_probability
---@return string encounter_string
function Old_world_caravans:new_agent_creator(context)
  local caravan_force = context.caravan:caravan_force();

  if caravan_force:unit_list():num_items() >= 19 then
    return 0, "";
  end

  local faction = context.faction;
  local faction_culture = faction:subculture();
  local caravan_master = context.caravan:caravan_master():character();
  local hero_list = {};
  local probability = 1;

  for culture, agent in pairs(self.culture_to_agent_subtype) do
    if culture ~= faction_culture then 
      table.insert(hero_list, agent)
    end
  end

  if #hero_list == 0 then return 0, "" end

  if not cm:military_force_contains_unit_type_from_list(caravan_force, hero_list) then
    probability = 5;
  end

  local start_node_agent, start_node_weight = self:get_agent_from_region(context.from,caravan_master);
  local end_node_agent, end_node_weight = self:get_agent_from_region(context.to, caravan_master);

  local agents_weight = {
    [start_node_agent] = start_node_weight,
    [end_node_agent] = end_node_weight;
  }

  local agent = self:select_random_key_by_weight(agents_weight, function (val)
    return val
  end)

  if not agent then return 0, "" end

  return probability, "new_agent?"..agent.."*";
end