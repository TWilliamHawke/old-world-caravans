---@param context CaravanWaylaid
function Old_world_caravans:slayers_handler(context)
  local caravan = context:caravan();
  local caravan_force = caravan:caravan_force();
  local faction = context:faction()
  local units_count = caravan_force:unit_list():num_items();
  local suffix = units_count < 20 and "1" or "2"
  local dilemma_name = "owc_main_dilemma_caravan_slayers_" .. suffix;

  local slayers = {
    wh_main_dwf_inf_slayers = 3,
    wh2_dlc10_dwf_inf_giant_slayers = 1
  }

  ---@type string
  local slayer_unit = self:select_random_key_by_weight(slayers, function(val)
    return val;
  end) or "wh_main_dwf_inf_slayers"


  self:bind_callback_to_dilemma(dilemma_name, caravan, 0, function()
    self:increase_caravan_cargo(caravan, -200)
  end)

  local dilemma_builder = cm:create_dilemma_builder(dilemma_name);

  local payload_builder = cm:create_payload();
  payload_builder:faction_pooled_resource_transaction("dwf_oathgold", "grudges", 100, false)
  local cargo_bundle = cm:create_new_custom_effect_bundle("wh3_main_dilemma_cth_caravan_2_b");
  cargo_bundle:add_effect("wh3_main_effect_caravan_cargo_DUMMY", "force_to_force_own", -200);
  cargo_bundle:set_duration(0);
  payload_builder:effect_bundle_to_force(caravan_force, cargo_bundle);

  dilemma_builder:add_choice_payload("FIRST", payload_builder);
  payload_builder:clear();

  if units_count < 20 then
    payload_builder:add_unit(caravan_force, slayer_unit, 1, 0);
  end
  dilemma_builder:add_choice_payload("SECOND", payload_builder);

  dilemma_builder:add_target("default", caravan_force);
  cm:launch_custom_dilemma_from_builder(dilemma_builder, faction);
end
