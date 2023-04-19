function Old_world_caravans:add_caravan_listeners()
  core:remove_listener("owc_add_inital_force")
  core:remove_listener("owc_caravan_spawned")
  core:remove_listener("owc_caravan_waylay_query_no_cathay")
  core:remove_listener("owc_caravan_waylaid_no_cathay")
  core:remove_listener("owc_SettlementSelected_caravan_test")
  core:remove_listener("owc_CaravanCompleted")
  core:remove_listener("owc_caravan_moved")
  core:remove_listener("owc_kill_ai_caravans")
  core:remove_listener("OWC_add_ai_effect")

  core:add_listener(
    "owc_add_inital_force",
    "CaravanRecruited",
    ---@param context CaravanRecruited
    ---@return boolean
    function(context)
      local faction = context:faction()
      return not self:faction_is_modded(faction);
    end,
    ---@param context CaravanRecruited
    function(context)
      local caravan = context:caravan();
      if caravan:caravan_force():unit_list():num_items() > 1 then return end

      local subculture = context:caravan():caravan_force():faction():subculture()
      
      if self.start_units[subculture] then
        self:add_start_force(caravan);
      else
        caravans:add_inital_force(caravan);
      end
    end,
    true
  );
  core:add_listener(
    "owc_caravan_spawned",
    "CaravanSpawned",
    ---@param context CaravanSpawned
    function(context)
      local faction = context:faction()
      return not self:faction_is_modded(faction);
    end,
    ---@param context CaravanSpawned
    function(context)
      if context:caravan():caravan_force():force_type():key() == "EMP_CARAVAN" then
        local caravan_force = context:caravan():caravan_force();
        self:remove_caravan_upkeep(caravan_force);
      end
      
      ---@diagnostic disable-next-line: undefined-field
      cm:set_character_excluded_from_trespassing(context:caravan():caravan_master():character(), true);
      local caravan = context:caravan();
      cm:set_saved_value("caravans_dispatched_" .. context:faction():name(), true);
      caravans:set_stance(caravan)
    end,
    true
  );


  core:add_listener(
    "owc_caravan_waylay_query_no_cathay",
    "QueryShouldWaylayCaravan",
    function(context)
      return context:faction():is_human() and not self:faction_is_modded(context:faction());
    end,
    ---comment
    ---@param context QueryShouldWaylayCaravan
    function(context)
      local subculture = context:caravan():caravan_force():faction():subculture()
      local faction_key = context:faction():name()
      self:log("My handler for QueryShouldWaylayCaravan")

      if self.start_units[subculture] or (subculture == "wh3_main_sc_cth_cathay" and cm:get_campaign_name() ~= "wh3_main_chaos") then
        self:generate_caravan_encounter(context)
      else
        if caravans.events_fired[faction_key] == nil or caravans.events_fired[faction_key] == false then
          if caravans:event_handler(context) == false then
            out.design("Caravan not valid for event");
          elseif caravans.events_fired[faction_key] ~= nil then
            caravans.events_fired[faction_key] = true
          end
          self:log("Generate Encounter for Chaos dwarfs or ROC Cathay")
        end
      end
    end,
    true
  );

  core:add_listener(
    "owc_caravan_waylaid_no_cathay",
    "CaravanWaylaid",
    function(context)
      return not self:faction_is_modded(context:faction())
    end,
    ---@param context CaravanWaylaid
    function(context)
      local subculture = context:faction():subculture();

      if self.start_units[subculture] or (subculture == "wh3_main_sc_cth_cathay" and cm:get_campaign_name() ~= "wh3_main_chaos") then
        self:handle_caravan_encounter(context);
      else
        caravans:waylaid_caravan_handler(context);
        self:log("Handle Encounter for Chaos dwarfs or ROC Cathay")
      end
      self:log("My handler for CaravanWaylaid")
    end,
    true
  );

  core:add_listener(
    "owc_SettlementSelected_caravan_test",
    "SettlementSelected",
    function()
      return self.debug_mode
    end,
    ---@param context SettlementSelected
    function(context)
      local settlement = context:garrison_residence():region():name();
      local banditry_level = cm:model():world():caravans_system():banditry_for_region_by_key(settlement);

      local faction = cm:get_local_faction()
      --self:give_caravan_award(faction, settlement)
      -- cm:move_caravan(cm:model():world():caravans_system():faction_caravans(faction):active_caravans()
      -- :item_at(0))

      self:log("banditry_level for " .. settlement .. " is " .. banditry_level);
    end,
    true
  )

  core:add_listener(
    "owc_CaravanCompleted",
    "CaravanCompleted",
    ---@param context CaravanCompleted
    function(context)
      return not self:faction_is_modded(context:faction());
    end,
    ---@param context CaravanCompleted
    function(context)
      --self:complete_caravans(context)
      local faction = context:faction()

      if not faction:is_human() then return end
      local node = context:complete_position():node()
      local region_name = node:region_key()
      self:give_caravan_award(faction, region_name);
    end,
    true
  )

  core:add_listener(
    "owc_caravan_moved",
    "CaravanMoved",
    function(context)
      return not context:caravan():is_null_interface() and not self:faction_is_modded(context:faction());
    end,
    function(context)
      self:teleport_caravan(context)
    end,
    true
  );

  core:add_listener(
    "owc_kill_ai_caravans",
    "FactionTurnEnd",
    ---@param context FactionTurnEnd
    ---@return boolean
    function(context)
      local faction = context:faction();
      local faction_sc = faction:subculture()
      return not faction:is_human() and self.ai_caravans[faction_sc] == false;
    end,
    ---@param context FactionTurnEnd
    function(context)
      self:disband_all_caravans(context:faction());
    end,
    true
  );

  core:add_listener(
    "OWC_add_ai_effect",
    "FactionTurnStart",
    ---@param context FactionTurnStart
    ---@return boolean
    function(context)
      local faction_name = context:faction():name();
      return self.access_to_caravans_on_first_turn[faction_name] ~= nil;
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
end
