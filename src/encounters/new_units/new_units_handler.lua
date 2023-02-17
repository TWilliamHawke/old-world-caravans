---@param context CaravanWaylaid
function Old_world_caravans:new_units_handler(context)
  local caravan = context:caravan();
  local caravan_master = caravan:caravan_master():character();
  local caravan_force = context:caravan():caravan_force();
  local caravan_faction = context:faction();

  local end_region = self:get_region_by_node(caravan, context:to());
  local start_region = self:get_region_by_node(caravan, context:from());
  local end_region_culture = self:get_culture_of_node(end_region);
  local start_region_culture = self:get_culture_of_node(start_region);

  local regions_weight = {
    [end_region_culture] = self:get_region_weight(end_region_culture, caravan_master),
    [start_region_culture] = self:get_region_weight(start_region_culture, caravan_master),
  }

  local selected_cultureA = self:select_random_key_by_weight(regions_weight, function(val)
    return val;
  end);

  local selected_cultureB = self:select_random_key_by_weight(regions_weight, function(val)
    return val;
  end);

  if not selected_cultureA or not selected_cultureB then
    self:logCore("for sone reason culture_selector returned nill");
    return;
  end


  local strong_units_border = cm:turn_number() > 50 and 3 or 4;
  local force_strenght = cm:random_number(4) > strong_units_border and "strong" or "weak";
  self:logCore("selected force strenght is " .. force_strenght)

  local unitsA, unitsA_count = self:select_unit(selected_cultureA, force_strenght .. "A");
  local unitsB, unitsB_count = self:select_unit(selected_cultureB, force_strenght .. "B");

  if unitsA_count < 0 or unitsB_count < 0 then
    self:logCore("cannot select units");
    return;
  end

  local suffix = (force_strenght == "strong" or cm:random_number(2) > 1) and "A" or "B";

  local dilemma_name = "wh3_main_dilemma_cth_caravan_4" .. suffix;
  local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
  local payload_builder = cm:create_payload();

  payload_builder:add_unit(caravan_force, unitsB, unitsB_count, 0);
  dilemma_builder:add_choice_payload("FIRST", payload_builder);
  payload_builder:clear();

  payload_builder:add_unit(caravan_force, unitsA, unitsA_count, 0);
  dilemma_builder:add_choice_payload("SECOND", payload_builder);

  dilemma_builder:add_target("default", caravan_force);

  attach_battle_to_dilemma(dilemma_name, caravan);

  cm:launch_custom_dilemma_from_builder(dilemma_builder, caravan_faction);
end
