---@param context CaravanWaylaid
---@param event_string string
function Old_world_caravans:enemy_attack_handler(context, event_string)
  local dilemma_name = "wh3_main_dilemma_cth_caravan_battle_1A";

  local enemy_cqi = self:prepare_forces_for_battle(context,
  function ()
    return self:get_enemy_by_regions(context)
  end,
  function (enemy_force_cqi)
    cm:apply_effect_bundle_to_force("wh2_dlc16_bundle_scripted_wood_elf_encounter", enemy_force_cqi, 0)
  end);

  self:create_dilemma_with_cargo(context, dilemma_name, enemy_cqi);

end
