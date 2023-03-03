---@param context CaravanWaylaid
function Old_world_caravans:ambush_handler(context)
  local enemy_cqi = self:prepare_forces_for_battle(context,
    function()
      return self:get_enemy_by_regions(context)
    end, "wh2_dlc17_bundle_scripted_lizardmen_encounter", "owc_caravan_no_menace_bellow"
  );

  local caravan_cqi = context:caravan():caravan_force():command_queue_index();

  cm:force_attack_of_opportunity(enemy_cqi, caravan_cqi, true);
end
