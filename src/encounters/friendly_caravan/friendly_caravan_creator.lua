---@param context Encounter_creator_context
---@return integer encounter_probability
function Old_world_caravans:friendly_caravan_creator(context)
  local caravan_culture = context.faction:subculture();
  if caravan_culture == "wh3_main_sc_cth_cathay" then return 0 end
  if caravan_culture == "wh_main_sc_brt_bretonnia" then return 0 end

  local cargo = context.caravan:cargo();

  if cargo < 500 then return 0 end

  local culture_from = self:get_subculture_of_node(context.from);
  local culture_to = self:get_subculture_of_node(context.to);

  local weight_from = self.cathay_caravans_probability[culture_from] or 0
  local weight_to = self.cathay_caravans_probability[culture_to] or 0

  local probability = math.max(weight_from, weight_to);

  if not context.faction:ancillary_exists("owc_main_anc_enchanted_item_jar_of_all_souls") then
    probability = probability * 2
  end

  return probability;
end
