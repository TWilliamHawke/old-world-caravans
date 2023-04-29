---@diagnostic disable: undefined-field
---@param context CaravanWaylaid
function Old_world_caravans:ambush_handler(context)
  local enemy_cqi, x, y = self:create_enemy_army(context,
    function()
      return self:get_enemy_by_regions(context)
    end, "wh2_dlc17_bundle_scripted_lizardmen_encounter", "owc_caravan_no_menace_bellow"
  );
  local dilemma_name = "owc_main_dilemma_caravan_1";

  local caravan = context:caravan();
  local caravan_force = caravan:caravan_force();

  local agents_count = caravan_force:character_list():num_items();
  local units_count = caravan_force:unit_list():num_items();

  if units_count - agents_count < 1 then
    self:log("not enough units for ambush event")
    cm:move_caravan(caravan);
    return
  end

  local random_idx = cm:random_number(units_count - 1, agents_count);
  local random_unit = caravan_force:unit_list():item_at(random_idx):unit_key();

  ---@type Prebattle_caravan_data
  local prebattle_data = {
    caravan = caravan,
    dilemma_name = dilemma_name,
    enemy_force_cqi = enemy_cqi,
    is_ambush = true,
    x = x,
    y = y
  }

  self:spy_on_dilemmas(caravan, enemy_cqi, function()

    self:bind_battle_to_dilemma(prebattle_data, 0, function()
    end);

    self:log("battle has attached, goto dilemma builder")

    local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
    local payload_builder = cm:create_payload();
    dilemma_builder:add_choice_payload("FIRST", payload_builder);
    payload_builder:remove_unit(caravan:caravan_force(), random_unit);
    payload_builder:clear();

    dilemma_builder:add_choice_payload("SECOND", payload_builder);
    dilemma_builder:add_target("default", caravan:caravan_force());

    self:log("dilemma_builder is finished, launch the dilemma")

    cm:launch_custom_dilemma_from_builder(dilemma_builder, caravan_force:faction());
  end);
end
