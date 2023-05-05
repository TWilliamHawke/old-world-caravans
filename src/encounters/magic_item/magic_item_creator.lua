---@param context Encounter_creator_context
---@return integer encounter_probability
function Old_world_caravans:magic_item_creator(context)
  local probability = 1;
  local caravan_master = context.caravan:caravan_master():character()

  local culture_to = self:get_subculture_of_node(context.to);
  local culture_from = self:get_subculture_of_node(context.from);

  local skill_to = self:caravan_master_has_special_trait(caravan_master, culture_to)
  local skill_from = self:caravan_master_has_special_trait(caravan_master, culture_from)

  if skill_from or skill_to then
    probability = 3;
  end

	return probability;
end