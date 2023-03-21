function adjust_end_node_value(region_name, value, operation)

  local region = cm:get_region(region_name);
  local cargo_value_bundle = cm:create_new_custom_effect_bundle("wh3_main_ivory_road_end_node_value");
  cargo_value_bundle:set_duration(0);

  if operation == "replace" then
    local temp_end_nodes = safe_get_saved_value_ivory_road_demand()
    cargo_value_bundle:add_effect("wh3_main_effect_caravan_cargo_value_regions", "region_to_region_own", value);

    temp_end_nodes[region_name] = value;
    cm:set_saved_value("ivory_road_demand", temp_end_nodes);
    out.design("Change trade to " .. value .. " demand for caravans in " .. region_name)

  elseif operation == "add" then
    local temp_end_nodes = safe_get_saved_value_ivory_road_demand()
    local old_value = temp_end_nodes[region_name] or 0; --only this line changed

    local new_value = math.min(old_value + value, 200)
    new_value = math.max(old_value + value, -60)

    out.design("new value is " .. new_value)
    cargo_value_bundle:add_effect("wh3_main_effect_caravan_cargo_value_regions", "region_to_region_own", new_value);

    temp_end_nodes[region_name] = new_value;
    cm:set_saved_value("ivory_road_demand", temp_end_nodes);
    out.design("Change trade to " .. new_value .. " demand for caravans in " .. region_name)
  end

  if region:has_effect_bundle("wh3_main_ivory_road_end_node_value") then
    cm:remove_effect_bundle_from_region("wh3_main_ivory_road_end_node_value", region_name);
  end

  cm:apply_custom_effect_bundle_to_region(cargo_value_bundle, region);
end

