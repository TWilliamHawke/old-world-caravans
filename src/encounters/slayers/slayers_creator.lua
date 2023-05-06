---@param context Encounter_creator_context
---@return integer encounter_probability
function Old_world_caravans:slayers_creator(context)
  local faction = context.faction;

  if context.caravan:cargo() < 500 then
    return 0;
  end


  if faction:pooled_resource_manager():resource("dwf_oathgold"):is_null_interface() then
    return 0
  end

  return 4
end
