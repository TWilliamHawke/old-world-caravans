function Old_world_caravans:add_first_tick_callbacks()
  cm:add_first_tick_callback_new(
    function()
      self:recruit_start_caravan();
      cm:set_saved_value(self.is_init_save_key, true);
    end
  );

  cm:add_first_tick_callback(
    function()
      Old_world_caravans:hide_caravan_button_for_belegar();

      local items = {
        "wh2_dlc10_anc_arcane_item_scroll_of_the_amber_trance",
        "wh2_dlc15_anc_follower_mandelour",
        "wh_dlc07_anc_arcane_item_sacrament_of_the_lady",
        "wh_dlc07_anc_armour_armour_of_the_midsummer_sun",
        "wh_dlc07_anc_armour_cuirass_of_fortune",
        "wh_dlc07_anc_armour_gilded_cuirass",
        "wh_dlc07_anc_armour_the_grail_shield",
        "wh_dlc07_anc_enchanted_item_holy_icon",
        "wh_dlc07_anc_enchanted_item_mane_of_the_purebreed",
        "wh_dlc07_anc_magic_standard_banner_of_defence",
        "wh_dlc07_anc_magic_standard_errantry_banner",
        "wh_dlc07_anc_magic_standard_twilight_banner",
        "wh_dlc07_anc_magic_standard_valorous_standard",
        "wh_dlc07_anc_talisman_dragons_claw",
        "wh_dlc07_anc_talisman_siriennes_locket",
        "wh_dlc07_anc_weapon_sword_of_the_ladys_champion",
        "wh_dlc07_anc_weapon_sword_of_the_quest",
        "wh_dlc07_anc_weapon_the_silver_lance_of_the_blessed",
        "wh_dlc07_anc_weapon_the_wyrmlance",
        "wh_main_anc_follower_all_hedge_wizard",
        "wh_main_anc_follower_all_men_bailiff",
        "wh_main_anc_follower_all_men_boatman",
        "wh_main_anc_follower_all_men_bodyguard",
        "wh_main_anc_follower_all_men_bounty_hunter",
        "wh_main_anc_follower_all_men_grave_robber",
        "wh_main_anc_follower_all_men_initiate",
        "wh_main_anc_follower_all_men_kislevite_kossar",
        "wh_main_anc_follower_all_men_mercenary",
        "wh_main_anc_follower_all_men_militiaman",
        "wh_main_anc_follower_all_men_ogres_pit_fighter",
        "wh_main_anc_follower_all_men_outlaw",
        "wh_main_anc_follower_all_men_protagonist",
        "wh_main_anc_follower_all_men_rogue",
        "wh_main_anc_follower_all_men_servant",
        "wh_main_anc_follower_all_men_smuggler",
        "wh_main_anc_follower_all_men_soldier",
        "wh_main_anc_follower_all_men_thug",
        "wh_main_anc_follower_all_men_tollkeeper",
        "wh_main_anc_follower_all_men_tomb_robber",
        "wh_main_anc_follower_all_men_vagabond",
        "wh_main_anc_follower_all_men_valet",
        "wh_main_anc_follower_all_men_zealot",
        "wh_main_anc_follower_all_student",
        "wh_main_anc_follower_bretonnia_court_jester",
        "wh_main_anc_follower_bretonnia_squire",
        "wh_main_anc_follower_empire_estalian_diestro",
        "wh_main_anc_talisman_seed_of_rebirth",
      }

      

      for _, item in pairs(items) do
        cm:add_ancillary_to_faction(cm:get_local_faction(), item, true)
      end

      if cm:is_new_game() or cm:get_saved_value(self.is_init_save_key) then return end

      self:set_starting_endpoints_values();

      local human_factions = cm:get_human_factions();

      for i = 1, #human_factions do
        self:unlock_caravan_recruitment(human_factions[i]);
      end

      cm:set_saved_value(self.is_init_save_key, true);
    end
  );
end
