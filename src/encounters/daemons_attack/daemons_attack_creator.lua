---@param context Encounter_creator_context
---@return integer encounter_probability
function Old_world_caravans:daemons_attack_creator(context)

  local probability = 0

  for i = 0, context.list_of_regions:num_items() - 1 do
    local region = context.list_of_regions:item_at(i);

    local corruption_level = cm:get_corruption_value_in_region(region, "wh3_main_corruption_chaos");

    if corruption_level > 0 then
      probability = probability + 1;
    end
  end
	return math.min(probability, 4)
end