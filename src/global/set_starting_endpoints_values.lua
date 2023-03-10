function Old_world_caravans:set_starting_endpoints_values()
  local effect_name = "wh3_main_ivory_road_end_node_value";
  local end_nodes = {
    ["wh3_main_combi_region_frozen_landing"]       = cm:random_number(75, 25),
    ["wh3_main_combi_region_myrmidens"]            = cm:random_number(75, 25),
    ["wh3_main_combi_region_erengrad"]             = cm:random_number(150, 60),
    ["wh3_main_combi_region_karaz_a_karak"]        = cm:random_number(75, 25),
    ["wh3_main_combi_region_castle_drakenhof"]     = cm:random_number(150, 60),
    ["wh3_main_combi_region_altdorf"]              = cm:random_number(150, 60),
    ["wh3_main_combi_region_marienburg"]           = cm:random_number(150, 60),
    ["wh3_main_combi_region_kislev"]               = cm:random_number(75, 25),
    ["wh3_main_combi_region_kraka_drak"]           = cm:random_number(150, 60),
    ["wh3_main_combi_region_karak_kadrin"]         = cm:random_number(75, 25),
    ["wh3_main_combi_region_zhufbar"]              = cm:random_number(75, 25),
    ["wh3_main_combi_region_kings_glade"]          = cm:random_number(75, 25),
    ["wh3_main_combi_region_miragliano"]           = cm:random_number(75, 25),
    ["wh3_main_combi_region_lothern"]              = cm:random_number(150, 60),
    ["wh3_main_combi_region_gaean_vale"]           = cm:random_number(150, 60),
    ["wh3_main_combi_region_monument_of_the_moon"] = cm:random_number(150, 60),
    ["wh3_main_combi_region_temple_of_kara"]       = cm:random_number(150, 60),
    ["wh3_main_combi_region_magritta"]             = cm:random_number(150, 60),
    ["wh3_main_combi_region_khemri"]               = cm:random_number(150, 60),
    ["wh3_main_combi_region_vulture_mountain"]     = cm:random_number(150, 60),
    ["wh3_main_combi_region_karak_zorn"]           = cm:random_number(150, 60),
    ["wh3_main_combi_region_karak_azorn"]          = cm:random_number(75, 25),
    ["wh3_main_combi_region_karak_krakaten"]       = cm:random_number(150, 60),
    ["wh3_main_combi_region_karak_dum"]            = cm:random_number(75, 25),
    ["wh3_main_combi_region_lahmia"]               = cm:random_number(75, 25),
    ["wh3_main_combi_region_massif_orcal"]         = cm:random_number(75, 25),
    ["wh3_main_combi_region_bordeleaux"]           = cm:random_number(150, 60),
    ["wh3_main_combi_region_karak_ziflin"]         = cm:random_number(150, 60),
  };

  for region_name, value in pairs(end_nodes) do
    local region = cm:get_region(region_name);
    local cargo_value_bundle = cm:create_new_custom_effect_bundle(effect_name);
    cargo_value_bundle:set_duration(0);
    cargo_value_bundle:add_effect("wh3_main_effect_caravan_cargo_value_regions", "region_to_region_own", value);

    if region:has_effect_bundle(effect_name) then
      cm:remove_effect_bundle_from_region(effect_name, region_name);
    end

    cm:apply_custom_effect_bundle_to_region(cargo_value_bundle, region);
  end

  cm:set_saved_value("ivory_road_demand", end_nodes);
end
