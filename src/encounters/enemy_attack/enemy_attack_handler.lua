---@param context CaravanWaylaid
function Old_world_caravans:enemy_attack_handler(context)
  local dilemma_name = "wh3_main_dilemma_cth_caravan_battle_1A";

  local enemy_cqi = self:prepare_forces_for_battle(context,
    function()
      return self:get_enemy_by_regions(context)
    end, "wh2_dlc16_bundle_scripted_wood_elf_encounter", "owc_caravan_no_menace_bellow");

  self:create_dilemma_with_cargo(context, dilemma_name, enemy_cqi);
end
