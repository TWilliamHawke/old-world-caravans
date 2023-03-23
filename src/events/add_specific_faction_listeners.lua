function Old_world_caravans:add_specific_faction_listeners()
  core:add_listener(
    "karak_eight_peaks_occupied_caravan",
    "GarrisonOccupiedEvent",
    function(context)
      return context:garrison_residence():region():name() == self.k8p_region_name;
    end,
    ---@param context GarrisonOccupiedEvent
    function(context)
      local character = context:character();
      if character:is_null_interface() then return end
      local faction = character:faction();

      if faction:name() == self.belegar_faction then
        self:show_caravan_button();
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
      if faction:has_effect_bundle("wh_dlc06_belegar_karak_owned_false_first") then return end

      self:show_caravan_button();
    end,
    true
  );


  core:add_listener(
    "belegar_joins_confederation_caravan",
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

      local region = cm:get_region(self.k8p_region_name)
      if not region or region:is_null_interface() then return end

      local region_owner = region:owning_faction();

      if not region:is_abandoned() and region_owner:name() == self.belegar_faction then
        self:show_caravan_button()
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
      if not self:faction_has_caravans(faction) then return end
      if self:caravan_button_should_be_visible(faction) then return end
      if faction:name() == self.belegar_faction then return end

      local other_name = context:faction():name();

      if self.access_to_caravans_on_first_turn[other_name] then
        self:show_caravan_button()
        cm:set_saved_value(self.is_init_save_key..faction:name(), true)
      end
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
end
