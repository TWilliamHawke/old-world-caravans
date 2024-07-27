function Old_world_caravans:add_specific_faction_listeners()
  core:remove_listener("owc_karak_eight_peaks_occupied")
  core:remove_listener("owc_belegar_turn_start")
  core:remove_listener("owc_belegar_joins_confederation")
  core:remove_listener("owc_CaravanTargetClick")
  core:remove_listener("owc_brt_caravan_new_units")
  core:remove_listener("owc_toggle_caravan_button")

  core:add_listener(
    "owc_karak_eight_peaks_occupied",
    "GarrisonOccupiedEvent",
    function(context)
      --wh3_main_combi_region_karak_bhufdar for tests
      return context:garrison_residence():region():name() == self.k8p_region_name;
    end,
    ---@param context GarrisonOccupiedEvent
    function(context)
      local character = context:character();
      local faction = character:faction();
      if character:is_null_interface() then return end
      if not faction:is_human() then return end
      local faction_name = faction:name();

      if faction_name == self.belegar_faction then
        cm:set_saved_value(self.is_init_save_key .. faction_name, true)
        self:trigger_toggle_button_event(character:faction(), true);
      end
    end,
    true
  );

  core:add_listener(
    "owc_belegar_turn_start",
    "FactionTurnStart",
    ---@param context FactionTurnStart
    ---@return boolean
    function(context)
      local faction_name = context:faction():name();
      return faction_name == self.belegar_faction;
    end,
    ---@param context FactionTurnStart
    function(context)
      if self.disable_player_caravans then return end
      local faction = context:faction()
      if not faction:is_human() then return end
      local region = cm:get_region(self.k8p_region_name)
      if not region or region:is_null_interface() then return end

      local region_owner = region:owning_faction():name();

      if region_owner == self.belegar_faction then
        self:trigger_toggle_button_event(faction, true);
        if not cm:get_saved_value(self.is_init_save_key .. region_owner) then
          cm:set_saved_value(self.is_init_save_key .. region_owner, true)
        end
      end
    end,
    true
  );


  core:add_listener(
    "owc_belegar_joins_confederation",
    "FactionJoinsConfederation",
    function(context)
      local faction_name = context:confederation():name();
      return faction_name == self.belegar_faction;
    end,
    ---@param context FactionJoinsConfederation
    function(context)
      local belegar_faction = cm:get_faction(self.belegar_faction)
      if not belegar_faction or not belegar_faction:is_human() then return end
      if cm:get_saved_value(self.is_init_save_key .. self.belegar_faction) then return end
      local region = cm:get_region(self.k8p_region_name)
      if not region or region:is_null_interface() then return end
      if region:is_abandoned() then return end

      if region:owning_faction():name() == self.belegar_faction then
        self:trigger_toggle_button_event(belegar_faction, true);
        cm:set_saved_value(self.is_init_save_key .. self.belegar_faction, true)
      end
    end,
    true);

  core:add_listener(
    "owc_joins_confederation_caravan",
    "FactionJoinsConfederation",
    ---@param context FactionJoinsConfederation
    function(context)
      return context:confederation():is_human();
    end,
    ---@param context FactionJoinsConfederation
    function(context)
      local faction = context:confederation();
      local other_faction = context:faction();
      self:unlock_caravans_by_confederation(faction, other_faction)
    end,
    true);


  core:add_listener(
    "owc_CaravanTargetClick",
    "ComponentLClickUp",
    function(context)
      return not not self.pooled_resource_to_region[context.string];
    end,
    function(context)
      local crafting_panel_close = find_uicomponent("mortuary_cult", "button_ok")

      if not crafting_panel_close then return end

      crafting_panel_close:SimulateLClick()
      local region = cm:get_region(self.pooled_resource_to_region[context.string])

      if region then
        cm:scroll_camera_from_current(true, 3,
          { region:settlement():display_position_x(), region:settlement():display_position_y(), 10.5,
            0.0, 6.8 })
      end
    end,
    true
  )

  core:add_listener(
    "owc_gelt_return_to_empire",
    "RegionFactionChangeEvent",
    ---@param context RegionFactionChangeEvent
    function(context)
      local faction = context:region():owning_faction();

      return faction:is_human() and self.access_to_caravans_on_first_turn[faction:name()] == false and faction:subculture() == "wh_main_sc_emp_empire";
    end,
    ---@param context RegionFactionChangeEvent
    function(context)
      local faction = context:region():owning_faction();
      local region_key = context:region():name();

      if not self:faction_has_caravans(faction) then return end
      if not self:caravan_button_should_be_hidden(faction) then return end

      local is_empire_region = false;

      ---@diagnostic disable-next-line: undefined-global
			for _, empire_region_key in ipairs(imperial_authority.empire_regions) do
				if(region_key == empire_region_key) then
					is_empire_region = true;
          break
				end
      end

      if not is_empire_region then return end

      cm:callback(function()
        self:trigger_toggle_button_event(faction, true);
        cm:set_saved_value(self.is_init_save_key .. faction:name(), true)
      end, 0.5)
    end,
    true
  );


  core:add_listener(
    "owc_brt_caravan_new_units",
    "ScriptEventOwcNewUnitsDilemma",
    ---@param context CharacterRankUp
    ---@return boolean
    function(context)
      local agent_type = context:character():character_subtype_key()

      return self.peasant_economy and agent_type == "wh_main_brt_caravan_master"
    end,
    ---@param context CharacterRankUp
    function(context)
      local faction = context:character():faction()
      core:add_listener(
        "owc_brt_caravan_new_unit_choice",
        "DilemmaChoiceMadeEvent",
        true,
        function()
          cm:callback(function()
            Calculate_Economy_Penalty(faction)
          end, 0.5)
        end,
        false
      );
    end,
    true
  );

  core:add_listener(
    "owc_toggle_caravan_button",
    "ScriptEventOwcToggleCaravanButton",
    function(context)
      return true
    end,
    function(context)
      local faction = context:faction();
      local state = context:state();
      self:try_toggle_caravan_button(faction, state);
    end,
    true
  );
end
