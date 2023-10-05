Old_world_caravans_teb = {
  ritual_to_effect = {
    owc_teb_caravan_ritual_empire = true,
    owc_teb_caravan_ritual_colonies = true,
  }
}

function Old_world_caravans_teb:add_listeners()
  core:add_listener(
    "owc_teb_ritual",
    "RitualCompletedEvent",
    ---@param context RitualCompletedEvent
    ---@return boolean
    function(context)
      local ritual = context:ritual():ritual_key() or "empty";
      local effect = self.ritual_to_effect[ritual];

      return not not effect
    end,
    ---@param context RitualCompletedEvent
    function(context)
      local faction = context:performing_faction();
      if not faction:is_human() then return end
      local ritual = context:ritual():ritual_key();

      if ritual == "owc_teb_caravan_ritual_empire" then
        ---@diagnostic disable-next-line: param-type-mismatch
        cm:add_unit_to_faction_mercenary_pool(faction, "owc_teb_veh_steam_tank_ror_0", "renown", 1, 100, 1, 0.1, "", "",
          ---@diagnostic disable-next-line: param-type-mismatch, redundant-parameter
          "", true, "owc_teb_veh_steam_tank_ror_0");
      elseif ritual == "owc_teb_caravan_ritual_colonies" then
        cm:spawn_unique_agent(faction:command_queue_index(), "owc_teb_hunter_jorek_grimm", true)
      end
    end,
    true
  )
end

Old_world_caravans_teb:add_listeners()
