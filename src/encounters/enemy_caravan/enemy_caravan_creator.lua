---@param context Encounter_creator_context
---@return integer encounter_probability
function Old_world_caravans:enemy_caravan_creator(context)
  local probability = 0;
  local caravan_culture = context.faction:subculture();
  local culture_from = self:get_subculture_of_node(context.from);
  local culture_to = self:get_subculture_of_node(context.to);

  for network_culture, network_data in pairs(self.node_culture_to_event_weight) do
    if network_culture ~= caravan_culture then
      local weight_from = network_data[culture_from] or 200;
      local weight_to = network_data[culture_to] or 200;

      --low weight means hight caravan chance
      if weight_from < 100 or weight_to < 100 then
        probability = cm:turn_number() < 30 and 3 or 5;
        break
      end
    end
  end

  return probability;
end
