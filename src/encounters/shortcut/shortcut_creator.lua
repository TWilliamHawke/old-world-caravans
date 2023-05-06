---@param context Encounter_creator_context
---@return integer encounter_probability
function Old_world_caravans:shortcut_creator(context)
  local probability = 4;
  local caravan = context.caravan;
  local caravan_master = caravan:caravan_master():character_details();

  local faction_sc = caravan_master:faction():subculture();

  local destination = context.to:name();

  local is_final_segement = self.awards[faction_sc]
      and self.awards[faction_sc][destination]

  if is_final_segement then return 0 end

  ---@diagnostic disable-next-line: redundant-parameter
  if caravan_master:has_skill("wh3_main_skill_cth_caravan_master_wheelwright") then
    probability = 6;
  end

  return probability;
end
