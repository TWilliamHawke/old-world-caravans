---@param context CaravanWaylaid
---@param enemy_data_callback enemy_data_callback
---@param invasion_callback fun(encounter_army: invasion) | nil
---@return integer
function Old_world_caravans:prepare_forces_for_battle(context, enemy_data_callback, invasion_callback)
  local caravan = context:caravan();
  local enemy_culture, target_region, encounter_dif = enemy_data_callback();
  local caravan_master = caravan:caravan_master():character()
  local caravan_faction = context:faction():name()

  if enemy_culture == "wh_main_sc_teb_teb" then
    enemy_culture = "wh_main_sc_emp_empire"
  end

  self:start_callback_race()

  -- if self.default_enemy_culture then
  --   enemy_culture = self.default_enemy_culture;
  -- end

  local enemy_faction = self.culture_to_enemy_faction[enemy_culture] or "wh_main_grn_greenskins_qb1";

  local force_key = enemy_culture .. "_" .. tostring(encounter_dif);
  local army_string = self:generate_army(force_key);
  local x, y = find_battle_coords_from_region(caravan_faction, target_region)

  local encounter_army = invasion_manager:new_invasion(
    self.invasion_key,
    enemy_faction,
    army_string,
    { x, y }
  )
  encounter_army:set_target("CHARACTER", caravan_master:command_queue_index(), caravan_faction);

  if self.enemy_forces[force_key] and self.enemy_forces[force_key].general then
    ---@diagnostic disable-next-line: missing-parameter
    encounter_army:create_general(false, self.enemy_forces[force_key].general);
  end

  if invasion_callback then
    invasion_callback(encounter_army)
  end

  local enemy_cqi = 0;
  cm:disable_event_feed_events(true, "wh_event_category_diplomacy", "", "");
  cm:disable_event_feed_events(true, "wh_event_category_character", "", "");

  encounter_army:start_invasion(
  ---@param encounter_army invasion
    function(encounter_army)
      enemy_cqi = encounter_army:get_force():command_queue_index();
      cm:force_declare_war(enemy_faction, caravan_faction, false, false);
    end
  )

  ---@diagnostic disable-next-line: param-type-mismatch
  self:teleport_caravan_to_position(caravan, x, y);

  return enemy_cqi;
end;