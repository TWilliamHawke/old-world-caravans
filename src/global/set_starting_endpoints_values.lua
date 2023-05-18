function Old_world_caravans:set_starting_endpoints_values()
  if cm:get_campaign_name() == "wh3_main_chaos" then return end
  local effect_name = "wh3_main_ivory_road_end_node_value";
  local ivory_road_demand = cm:get_saved_value("ivory_road_demand");
  local values_is_touched = false;

  for i = 1, #self.new_caravan_targets do
    local region_name = self.new_caravan_targets[i];

    if ivory_road_demand.cathay[region_name] == nil then
      values_is_touched = true
      local region = cm:get_region(region_name);
      local value = cm:random_number(140, 25);
      local cargo_value_bundle = cm:create_new_custom_effect_bundle(effect_name);
      cargo_value_bundle:set_duration(0);
      cargo_value_bundle:add_effect("wh3_main_effect_caravan_cargo_value_regions", "region_to_region_own", value);
      ivory_road_demand.cathay[region_name] = value;

      if region:has_effect_bundle(effect_name) then
        cm:remove_effect_bundle_from_region(effect_name, region_name);
      end

      cm:apply_custom_effect_bundle_to_region(cargo_value_bundle, region);
    end
  end

  if values_is_touched then
    self:logCore("trade values has updated")
    cm:set_saved_value("ivory_road_demand", ivory_road_demand);
  end
end
