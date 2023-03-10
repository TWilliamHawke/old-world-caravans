---@param context Encounter_creator_context
---@return integer encounter_probability
function Old_world_caravans:giftFromInd_creator(context)
  local caravan_culture = context.faction:subculture();
  if caravan_culture ~= "wh3_main_sc_cth_cathay" then return 0 end

  local turn_number = cm:turn_number();

  local probability = 1 + math.floor(turn_number / 100);

  if turn_number < 25 then
    probability = 0;
  end


  return probability;
end