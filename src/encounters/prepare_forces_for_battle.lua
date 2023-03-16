---@param context CaravanWaylaid
---@param enemy_data_callback enemy_data_callback
---@param ... string effects
---@return integer
function Old_world_caravans:prepare_forces_for_battle(context, enemy_data_callback, ...)
  local caravan = context:caravan();
  local enemy_culture, target_region, encounter_dif = enemy_data_callback();
  local caravan_faction_key = context:faction():name()

  if self.override_enemy and self.default_enemy_culture then
    enemy_culture = self.default_enemy_culture;
    encounter_dif = self.default_difficult;
  end

  local enemy_faction = self.culture_to_enemy_faction[enemy_culture] or "wh_main_grn_greenskins_qb1";

  local force_key = enemy_culture .. "_" .. tostring(encounter_dif);
  local force_budget = self.encounter_budgets[encounter_dif];
  local army_string = self:generate_army(force_key, force_budget);
  local x, y = self:find_position_for_spawn(caravan_faction_key, target_region)
  local general = self.enemy_forces[force_key] and self.enemy_forces[force_key].general;
  cm:disable_event_feed_events(true, "wh_event_category_diplomacy", "", "");
  cm:disable_event_feed_events(true, "wh_event_category_character", "", "");
  local enemy_cqi = 0;

  if general then
    self:log("create_force_with_general")

    cm:create_force_with_general(enemy_faction, army_string, target_region,
      x, y, "general", general, "", "", "", "", false,
      function(enemy_char_cqi, enemy_force_cqi)
        cm:force_declare_war(enemy_faction, caravan_faction_key, false, false);
        cm:disable_movement_for_character(cm:char_lookup_str(enemy_char_cqi));
        enemy_cqi = enemy_force_cqi;
      end);
  else
    self:log("create_force_without general")

    cm:create_force(enemy_faction, army_string, target_region, x, y, true,
      function(enemy_char_cqi, enemy_force_cqi)
        cm:force_declare_war(enemy_faction, caravan_faction_key, false, false);
        cm:disable_movement_for_character(cm:char_lookup_str(enemy_char_cqi));
        enemy_cqi = enemy_force_cqi;
      end);
  end


  if enemy_cqi ~= 0 then
    for _, effect_bundle in pairs(arg) do
      cm:apply_effect_bundle_to_force(effect_bundle, enemy_cqi, 0);
    end
    cm:set_saved_value(self.encounter_faction_save_key..caravan_faction_key, enemy_cqi);
    cm:set_saved_value(self.encounter_faction_save_key, enemy_cqi);
  end


  ---@diagnostic disable-next-line: param-type-mismatch
  self:teleport_caravan_to_position(caravan, x, y);

  return enemy_cqi;
end
