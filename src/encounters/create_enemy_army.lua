---@param context CaravanWaylaid
---@param enemy_culture string
---@param target_region string
---@param ... string effects
---@return integer enemy_cqi
---@return integer x
---@return integer y
function Old_world_caravans:create_enemy_army(context, enemy_culture, target_region, ...)

  local encounter_dif, additional_budget = self:get_event_difficulty(context);
  local caravan_faction_key = context:faction():name()

  if self.override_enemy and self.default_enemy_culture then
    enemy_culture = self.default_enemy_culture;
    encounter_dif = self.default_difficult;
  end

  local enemy_faction = self.culture_to_enemy_faction[enemy_culture] or "wh_main_grn_greenskins_qb1";

  local army_string, general = self:generate_army(enemy_culture, encounter_dif, additional_budget);
  local x, y = self:find_position_for_spawn(caravan_faction_key, target_region)
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
        for _, effect_bundle in pairs(arg) do
          cm:apply_effect_bundle_to_force(effect_bundle, enemy_force_cqi, 0);
        end

        enemy_cqi = enemy_force_cqi;
      end);
  else
    self:log("create_force_without general")

    cm:create_force(enemy_faction, army_string, target_region, x, y, true,
      function(enemy_char_cqi, enemy_force_cqi)
        cm:force_declare_war(enemy_faction, caravan_faction_key, false, false);
        cm:disable_movement_for_character(cm:char_lookup_str(enemy_char_cqi));
        for _, effect_bundle in pairs(arg) do
          cm:apply_effect_bundle_to_force(effect_bundle, enemy_force_cqi, 0);
        end
        enemy_cqi = enemy_force_cqi;
      end);
  end


  if enemy_cqi ~= 0 then
    cm:set_saved_value(self.encounter_faction_save_key..caravan_faction_key, enemy_cqi);
  end

  return enemy_cqi, x, y;
end
