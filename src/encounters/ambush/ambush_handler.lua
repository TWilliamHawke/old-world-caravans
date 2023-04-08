---@diagnostic disable: undefined-field
---@param context CaravanWaylaid
function Old_world_caravans:ambush_handler(context)
  local enemy_cqi = self:prepare_forces_for_battle(context,
    function()
      return self:get_enemy_by_regions(context)
    end, "wh2_dlc17_bundle_scripted_lizardmen_encounter", "owc_caravan_no_menace_bellow"
  );
  local dilemma_name = "owc_main_dilemma_caravan_1";

  local caravan = context:caravan();
  local caravan_force = caravan:caravan_force();
  local caravan_master_cqi = caravan_force:general_character():command_queue_index();
  local lord_str = cm:char_lookup_str(caravan_master_cqi);

  local agents_count = caravan_force:character_list():num_items();
  local units_count = caravan_force:unit_list():num_items();

  if units_count - agents_count < 1 then
    self:log("not enough units for ambush event")
    cm:move_caravan(caravan);
    return
  end

  local random_idx = cm:random_number(units_count - 1, agents_count);
  local random_unit = caravan_force:unit_list():item_at(random_idx):unit_key();

  local units_to_add = {};

  for i = 0, units_count - 1 do
    local unit = caravan_force:unit_list():item_at(i);
    if unit:unit_key() == random_unit then
      table.insert(units_to_add, unit:experience_level());
    end
  end

  self:spy_on_dilemmas(caravan, function()
    local enemy_force = cm:get_military_force_by_cqi(enemy_cqi);
    if not enemy_force or enemy_force:is_null_interface() then
      self:log("enemy army not found! cancel the encounter")
      cm:set_saved_value(self.encounter_was_canceled_key, true)
      return
    end

    self:bind_battle_to_dilemma(caravan, dilemma_name, enemy_cqi, true, function()
      --doesn't work properly
      cm:remove_unit_from_character(lord_str, random_unit);

      for _ = 2, #units_to_add do
        cm:grant_unit_to_character(lord_str, random_unit);
      end

      local table_index = 1;
      local caravan_master = cm:get_character_by_cqi(caravan_master_cqi)
      local unit_list = caravan_master:military_force():unit_list()

      for i = 0, units_count - 2 do
        local unit = unit_list:item_at(i);
        if unit:unit_key() == random_unit and units_to_add[table_index] then
          cm:add_experience_to_unit(unit, units_to_add[table_index]);
          table_index = table_index + 1;
        end
      end
    end);

    self:log("battle has attached, goto dilemma builder")

    local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
    local payload_builder = cm:create_payload();
    dilemma_builder:add_choice_payload("FIRST", payload_builder);
    payload_builder:remove_unit(caravan:caravan_force(), random_unit);
    dilemma_builder:add_choice_payload("SECOND", payload_builder);
    dilemma_builder:add_target("default", caravan:caravan_force());

    self:log("dilemma_builder is finished, launch the dilemma")

    cm:launch_custom_dilemma_from_builder(dilemma_builder, caravan_force:faction());
  end);
end
