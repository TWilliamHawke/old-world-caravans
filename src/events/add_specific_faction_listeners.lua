function Old_world_caravans:add_specific_faction_listeners()
  core:remove_listener("owc_karak_eight_peaks_occupied")
  core:remove_listener("owc_belegar_turn_start")
  core:remove_listener("owc_belegar_joins_confederation")
  core:remove_listener("owc_CaravanTargetClick")
  core:remove_listener("owc_brt_caravan_new_units")

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
      if character:is_null_interface() then return end
      local faction_name = character:faction():name();

      if faction_name == self.belegar_faction then
        cm:set_saved_value(self.is_init_save_key .. faction_name, true)
        if cm:get_local_faction(true):name() == faction_name then
          self:show_caravan_button();
        end
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
      local faction = context:faction()
      if not faction:is_human() then return end
      local region = cm:get_region(self.k8p_region_name)
      if not region or region:is_null_interface() then return end

      local region_owner = region:owning_faction():name();

      if region_owner == self.belegar_faction then
        if cm:get_local_faction(true):name() == region_owner then
          self:show_caravan_button();
        end
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
      local faction = context:confederation();
      local belegar_faction = cm:get_faction(self.belegar_faction)
      if not belegar_faction or not belegar_faction:is_human() then return end
      if self:caravan_button_should_be_visible(belegar_faction) then return end
      --wh3_main_combi_region_karak_hirn
      local region = cm:get_region(self.k8p_region_name)
      if not region or region:is_null_interface() then return end

      local region_owner_key = region:owning_faction():name();

      if not region:is_abandoned() and region_owner_key == self.belegar_faction then
        if cm:get_local_faction(true):name() == region_owner_key then
          self:show_caravan_button();
        end
        cm:set_saved_value(self.is_init_save_key .. faction:name(), true)
      else
        self:disband_all_caravans(faction)
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
      local other_faction = context:faction()
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
  )
end
