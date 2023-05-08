---@param context Encounter_creator_context
---@return integer encounter_probability
function Old_world_caravans:wild_river_creator(context)
  local caravan_force = context.caravan:caravan_force();
  local agents_count = caravan_force:character_list():num_items();
  local units_count = caravan_force:unit_list():num_items();
  local character = context.caravan:caravan_master():character()

  if units_count - agents_count < 1 then return 0 end

  local cargo = context.caravan:cargo();

  if cargo < 500 then return 0 end

  if units_count > 16 then return 4 end

  if character:trait_points("owc_trait_grail_vow_caravan_cargo") == 1 then
    return 6
  end


	return 2
end