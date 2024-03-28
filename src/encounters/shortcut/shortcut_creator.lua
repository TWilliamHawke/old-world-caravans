---@diagnostic disable: undefined-field
---@param context Encounter_creator_context
---@return integer encounter_probability
function Old_world_caravans:shortcut_creator(context)
  local probability = 2;
  local caravan = context.caravan;
  local caravan_master = caravan:caravan_master():character();
  local faction_sc = caravan_master:faction():subculture();
  local destination = context.to:name();

  local is_final_segement = self.awards[faction_sc]
      and self.awards[faction_sc][destination]

  if is_final_segement then return 0 end

  --5 or 10
  local skill_bonus= cm:get_characters_bonus_value(caravan_master, "caravan_double_move")
  skill_bonus = math.ceil(skill_bonus * 0.4);

  return probability + skill_bonus;
end
