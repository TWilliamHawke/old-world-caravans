---@param context Encounter_creator_context
---@return integer encounter_probability
function Old_world_caravans:daemons_attack_creator(context)
  local caravan_force = context.caravan:caravan_force()
  local probability = 0
  local agents_count = caravan_force:character_list():num_items();
  local units_count = caravan_force:unit_list():num_items();

  if units_count - agents_count < 1 then return 0 end

  for i = 0, context.list_of_regions:num_items() - 1 do
    local region = context.list_of_regions:item_at(i);

    for corruption in pairs(self.chaos_corruptions) do
      local corruption_level = cm:get_corruption_value_in_region(region, corruption) or 0;
      if corruption_level > 0 then
        probability = probability + 2;
        break
      end
    end
  end

	return math.min(probability, 8)
end