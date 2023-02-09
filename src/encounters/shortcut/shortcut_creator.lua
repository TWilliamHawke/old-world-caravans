---@param context Encounter_creator_context
---@return integer encounter_probability
---@return string encounter_string
function Old_world_caravans:shortcut_creator(context)
  local probability = 2;
  local caravan_master = context.caravan:caravan_master():character_details();

---@diagnostic disable-next-line: redundant-parameter
  if caravan_master:has_skill("wh3_main_skill_cth_caravan_master_wheelwright") then
    probability = 8;
  end;

  return probability, "shortcut"
end