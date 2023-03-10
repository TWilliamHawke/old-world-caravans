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
    "belegar_joins_confederation_caravan",
    "FactionJoinsConfederation",
    function(context)
      local faction_name = context:faction():name();

      return faction_name == self.belegar_faction;
    end,
    ---@param context FactionJoinsConfederation
    function(context)
      local faction = context:faction();
      if not cm:get_faction(self.belegar_faction):is_human() then return end

      local region = cm:get_region(self.k8p_region_name)
      if not region or region:is_null_interface()then return end

      local region_owner = region:owning_faction();

      if not region:is_abandoned() and region_owner == self.belegar_faction then
        self:show_caravan_button()
      else
        self:disband_all_caravans(faction)
      end
    end,
    true);

  core:add_listener(
    "CaravanTargetClick",
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
