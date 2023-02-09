---@param context CaravanWaylaid
---@param event_string string
function Old_world_caravans:ambush_handler(context, event_string)
  local enemy_cqi = self:prepare_forces_for_battle(context,
          function()
            return self:get_enemy_by_regions(context)
          end
      );
  local caravan_cqi = context:caravan():caravan_force():command_queue_index();
  self:logCore("ambush_handler")

  local force = cm:get_military_force_by_cqi(enemy_cqi);
  local effect_is_exist = force:has_effect_bundle("wh2_dlc16_bundle_scripted_wood_elf_encounter")
  self:logCore("effect ixists is " .. tostring(effect_is_exist))

  cm:force_attack_of_opportunity(enemy_cqi, caravan_cqi, true);
end
