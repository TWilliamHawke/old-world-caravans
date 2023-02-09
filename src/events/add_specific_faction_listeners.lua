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
      "karak_faction_joins_confederation",
      "FactionJoinsConfederation",
      function(context)
        local faction_name = context:faction():name();
        local confederation_name = context:confederation():name();

        return faction_name == self.belegar_faction or confederation_name == self.belegar_faction;
      end,
      ---@param context FactionJoinsConfederation
      function(context)
        if not cm:get_local_faction():name() == self.belegar_faction then return end

        local region = cm:get_region(self.k8p_region_name)
        if not region or region:is_abandoned() then return end

        local region_owner = region:owning_faction();
        if region_owner == self.belegar_faction then
          self:show_caravan_button()
        end
      end,
      true);
end
