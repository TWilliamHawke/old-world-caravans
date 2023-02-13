function Old_world_caravans:add_caravan_listeners()

  core:add_listener(
    "add_inital_force",
    "CaravanRecruited",
    ---@param context CaravanRecruited
    ---@return boolean
    function(context)
      return context:caravan():caravan_force():faction():subculture() ~= "wh3_main_sc_cth_cathay";
    end,
    ---@param context CaravanRecruited
    function(context)
      local caravan = context:caravan();
      self:add_start_force(caravan);
    end,
    true
  );

  core:add_listener(
    "caravan_waylay_query_no_cathay",
    "QueryShouldWaylayCaravan",
    function(context)
      return context:faction():is_human() and
          context:caravan():caravan_force():faction():subculture() ~= "wh3_main_sc_cth_cathay";
    end,
    ---comment
    ---@param context QueryShouldWaylayCaravan
    function(context)
      self:generate_caravan_event(context)
      self:logCore("My handler for QueryShouldWaylayCaravan")
    end,
    true
  );

  core:add_listener(
    "caravan_waylaid_no_cathay",
    "CaravanWaylaid",
    function(context)
      return context:caravan():caravan_force():faction():subculture() ~= "wh3_main_sc_cth_cathay";
    end,
    function(context)
      self:logCore("My handler for CaravanWaylaid")
    end,
    true
  );

  core:add_listener(
    "caravan_moved_no_cathay",
    "CaravanMoved",
    function(context)
      return context:caravan():caravan_force():faction():subculture() ~= "wh3_main_sc_cth_cathay";
    end,
    ---comment
    ---@param context CaravanMoved
    function(context)
      self:generate_caravan_event(context)
      self:logCore("My handler for CaravanMoved")
    end,
    true
  );

  core:add_listener(
    "progressive_ai_MctFinalized",
    "SettlementSelected",
    function()
      return self.debug_mode
    end,
    ---comment
    ---@param context SettlementSelected
    function(context)
      local settlement = context:garrison_residence():region():name();
      local player_faction = cm:get_local_faction();

      local caravan_system = cm:model():world():caravans_system():faction_caravans(player_faction)

      if not caravan_system:is_null_interface() then
        local active_caravans = caravan_system:active_caravans()
        if active_caravans:is_empty() then return end

        ---@diagnostic disable-next-line: undefined-field
        cm:move_caravan(active_caravans:item_at(0))

      end

      local banditry_level = cm:model():world():caravans_system():banditry_for_region_by_key(settlement);

      self:logCore("banditry_level for " .. settlement .. " is " .. banditry_level)
    end,
    true
  )

  core:add_listener(
    "owc_encounter_faction_cleanup",
    "BattleCompleted",
    function()
      return cm:get_saved_value(self.encounter_faction_save_key);
    end,
    function()
      cm:callback(
        function()
          self:cleanup_encounter()
        end, 0.5, self.cleaup_encounter_debounce_key
      )
    end,
    true
  );

  core:add_listener(
    "owc_EndOfRound_encounter_faction_cleanup",
    "EndOfRound",
    function()
      return cm:get_saved_value(self.encounter_faction_save_key);
    end,
    function()
      self:cleanup_encounter();
    end,
    true
  );


  core:add_listener(
    "OWC_add_ai_effect",
    "FactionTurnStart",
    ---@param context FactionTurnStart
    ---@return boolean
    function(context)
      return context:faction():culture() == "wh_main_sc_emp_empire"
    end,
    ---@param context FactionTurnStart
    function(context)
      local faction = context:faction();
      if faction:is_human() then return end
      local effect_key = "wh3_main_caravan_AI_threat_reduction";

      if not faction:has_effect_bundle(effect_key) then
        cm:apply_effect_bundle(effect_key, faction:name(), 0)

      end
    end,
    true
  );



  -- core:add_listener(
  --   "caravan_waylaid_replacer",
  --   "CaravanWaylaid",
  --   true,
  --   ---@param context CaravanWaylaid
  --   function(context)
  --     local caravan_subculture = context:caravan():caravan_force():faction():subculture();
  --     if caravan_subculture ~= "wh3_main_sc_cth_cathay" then
  --       local event_name_formatted = context:context();
  --       self:logCore("my event handler for "..event_name_formatted)
  --       waylaid_caravan_handler(context);
  --       self:logCore(" not my event handler ")
  --     else

  --       local caravan_handle = context:caravan();
  --       local AorB = { "A", "B" };
  --       local choice = AorB[cm:random_number(#AorB, 1)]

  --       local dilemma_name = "wh3_main_dilemma_cth_caravan_3" .. choice;

  --       local hero_list = { "wh3_main_ogr_cha_hunter_0", "wh_main_emp_cha_captain_0", "wh2_main_hef_cha_noble_0" };

  --       local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
  --       local payload_builder = cm:create_payload();

  --       dilemma_builder:add_choice_payload("FIRST", payload_builder);

  --       if choice == "B" then
  --         payload_builder:treasury_adjustment(-500);
  --       end
  --       payload_builder:add_unit(caravan_handle:caravan_force(), hero_list[cm:random_number(#hero_list, 1)], 1, 0);
  --       dilemma_builder:add_choice_payload("SECOND", payload_builder);
  --       payload_builder:clear();

  --       dilemma_builder:add_target("default", caravan_handle:caravan_force());

  --       out.design("Triggering dilemma:" .. dilemma_name)
  --       cm:launch_custom_dilemma_from_builder(dilemma_builder, caravan_handle:caravan_force():faction());
  --     end
  --   end,
  --   true
  -- );



end
