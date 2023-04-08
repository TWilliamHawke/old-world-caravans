function initalise_end_node_values()

  --randomise the end node values
  local end_nodes = {}

  if cm:get_campaign_name() == "main_warhammer" then
    end_nodes = {
      ["wh3_main_combi_region_frozen_landing"]       = 75 - cm:random_number(50, 0),
      ["wh3_main_combi_region_myrmidens"]            = 75 - cm:random_number(50, 0),
      ["wh3_main_combi_region_erengrad"]             = cm:random_number(150, 60),
      ["wh3_main_combi_region_karaz_a_karak"]        = 75 - cm:random_number(50, 0),
      ["wh3_main_combi_region_castle_drakenhof"]     = cm:random_number(150, 60),
      ["wh3_main_combi_region_altdorf"]              = cm:random_number(150, 60),
      ["wh3_main_combi_region_marienburg"]           = cm:random_number(150, 60),
      ["wh3_main_combi_region_kislev"]               = 75 - cm:random_number(50, 0),
      ["wh3_main_combi_region_kraka_drak"]           = cm:random_number(150, 60),
      ["wh3_main_combi_region_karak_kadrin"]         = 75 - cm:random_number(50, 0),
      ["wh3_main_combi_region_zhufbar"]              = 75 - cm:random_number(50, 0),
      ["wh3_main_combi_region_kings_glade"]          = 75 - cm:random_number(50, 0),
      ["wh3_main_combi_region_miragliano"]           = 75 - cm:random_number(50, 0),
      ["wh3_main_combi_region_lothern"]              = cm:random_number(150, 60),
      ["wh3_main_combi_region_gaean_vale"]           = cm:random_number(150, 60),
      ["wh3_main_combi_region_monument_of_the_moon"] = cm:random_number(150, 60),
      ["wh3_main_combi_region_temple_of_kara"]       = cm:random_number(150, 60),
      ["wh3_main_combi_region_magritta"]             = cm:random_number(150, 60),
      ["wh3_main_combi_region_khemri"]             = cm:random_number(150, 60),
      ["wh3_main_combi_region_vulture_mountain"]             = cm:random_number(150, 60),
      ["wh3_main_combi_region_karak_zorn"]             = cm:random_number(150, 60),
      ["wh3_main_combi_region_karak_azorn"]             = 75 - cm:random_number(50, 0),
      ["wh3_main_combi_region_karak_krakaten"]             = cm:random_number(150, 60),
      ["wh3_main_combi_region_karak_dum"]             = 75 - cm:random_number(50, 0),
      ["wh3_main_combi_region_lahmia"]             = 75 - cm:random_number(50, 0),
      ["wh3_main_combi_region_massif_orcal"]             = 75 - cm:random_number(50, 0),
      ["wh3_main_combi_region_bordeleaux"]             = cm:random_number(150, 60),
      ["wh3_main_combi_region_karak_ziflin"]             = cm:random_number(150, 60),
      ["wh3_main_combi_region_sudenburg"] = cm:random_number(150, 60),
      ["wh3_main_combi_region_couronne"] = cm:random_number(150, 60),
      ["wh3_main_combi_region_castle_carcassonne"] = cm:random_number(150, 60),
      ["wh3_main_combi_region_waterfall_palace"] = 75 - cm:random_number(50, 0),
      ["wh3_main_combi_region_copher"] = cm:random_number(150, 60),
      ["wh3_main_combi_region_zandri"] = cm:random_number(150, 60),
      ["wh3_main_combi_region_temple_of_tlencan"] = 75 - cm:random_number(50, 0),
      ["wh3_main_combi_region_the_star_tower"]       = 75 - cm:random_number(50, 0),
      ["wh3_main_combi_region_shang_yang"]           = cm:random_number(150, 60),
      ["wh3_main_combi_region_mousillon"]            = 75 - cm:random_number(50, 0),
    };
  elseif cm:get_campaign_name() == "wh3_main_chaos" then
    end_nodes = {
      ["wh3_main_chaos_region_frozen_landing"]      = 75 - cm:random_number(50, 0),
      ["wh3_main_chaos_region_shattered_stone_bay"] = 75 - cm:random_number(50, 0),
      ["wh3_main_chaos_region_novchozy"]            = 75 - cm:random_number(50, 0),
      ["wh3_main_chaos_region_erengrad"]            = cm:random_number(150, 60),
      ["wh3_main_chaos_region_castle_drakenhof"]    = cm:random_number(150, 60),
      ["wh3_main_chaos_region_altdorf"]             = cm:random_number(150, 60),
      ["wh3_main_chaos_region_marienburg"]          = cm:random_number(150, 60)
    };
  end

  --save them
  cm:set_saved_value("ivory_road_demand", end_nodes);
  local temp_end_nodes = safe_get_saved_value_ivory_road_demand()

  --apply the effect bundles
  for key, val in pairs(temp_end_nodes) do
    out.design("Key: " .. key .. " and value: " .. val)
    adjust_end_node_value(key, val, "replace")
  end
end
