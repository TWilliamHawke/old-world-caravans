---@param context Encounter_creator_context
---@return integer encounter_probability
---@return string encounter_string
function Old_world_caravans:local_trouble_creator(context)
  local caravan_master = context.caravan:caravan_master():character();
  local probability = 5;

  local culture_from = self:get_culture_of_node(context.from);
  local culture_to = self:get_culture_of_node(context.to);

  if culture_to == culture_from == "wh_main_sc_dwf_dwarfs" then
    probability = 0;
  end

  if self:caravan_master_has_special_trait(caravan_master, culture_from) then
    probability = 0;
  end

  if self:caravan_master_has_special_trait(caravan_master, culture_to) then
    probability = 0;
  end


  return probability, ""
end
