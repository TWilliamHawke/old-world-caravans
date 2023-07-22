---@param context Encounter_creator_context
---@return integer encounter_probability
function Old_world_caravans:ogres_my_lord_creator(context)
  local army_size = context.caravan:caravan_force():unit_list():num_items();
  local caravan_master = context.caravan:caravan_master():character()
  local probability = math.floor((20 - army_size) / 2);

  if self:caravan_master_has_special_trait(caravan_master, "wh3_main_sc_ogr_ogre_kingdoms") then
    probability = probability * 2;
  end

  return probability
end