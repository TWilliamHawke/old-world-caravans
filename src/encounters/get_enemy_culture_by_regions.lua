---@param context CaravanWaylaid
---@return string enemy_culture
---@return string enemy_region
---@return 1 | 2| 3 encounter_dif
function Old_world_caravans:get_enemy_by_regions(context)
  local caravan = context:caravan();
  local caravan_faction = context:faction();
  local list_of_regions = self:get_regions_list(context) or {};
  local start_region = self:get_region_by_node(caravan, context:from())

  if context:faction():subculture() ~= "wh3_main_sc_cth_cathay" then
    table.insert(list_of_regions, start_region:name());
  end

  local bandit_threat = self:calculate_bandit_threat(list_of_regions);
  local encounter_dif = self:get_event_difficulty(bandit_threat, caravan);


  local threat_list, threated_regions = self:calculate_evil_faction_threat(list_of_regions, caravan_faction);

  local main_threat = self:select_random_key_by_weight(threat_list, function(val)
        return val
      end) or "wh_main_sc_grn_greenskins";

  local target_region = threated_regions[main_threat] or start_region:name();

  if self.random_enemies then
    main_threat = self:select_random_key_by_weight(self.culture_to_enemy_faction, function (val)
      return 1
    end) or "wh_main_sc_grn_greenskins"
  end


  return main_threat, target_region, encounter_dif;
end
