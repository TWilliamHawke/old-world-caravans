function Old_world_caravans:add_cleanup_listeners()
  core:remove_listener("owc_postbattle_faction_cleanup")
  core:remove_listener("owc_EndOfRound_encounter_faction_cleanup")
  core:remove_listener("owc_clean_up_attacker")
  core:remove_listener("owc_quest_item_triggered")

  core:add_listener(
    "owc_postbattle_faction_cleanup",
    "BattleCompleted",
    ---@param context BattleCompleted
    function(context)
      local pb = context:model():pending_battle();
      local attacker

      if pb:has_been_fought() then
        local attacker_name = cm:pending_battle_cache_get_attacker_faction_name(1);
        attacker = cm:get_faction(attacker_name)
      else
        attacker = pb:attacker():faction();
      end

      if not attacker or attacker:is_null_interface() then return false end

      local faction_sc = attacker:subculture();
      return self.culture_to_enemy_faction[faction_sc] == attacker:name();
    end,
    ---@param context BattleCompleted
    function(context)
      local pb = context:model():pending_battle();
      local defender

      if pb:has_been_fought() then
        local defender_name = cm:pending_battle_cache_get_defender_faction_name(1);
        defender = cm:get_faction(defender_name)
      else
        defender = pb:defender():faction();
      end

      if not defender or defender:is_null_interface() then return end
      if self:faction_is_modded(defender) then return end

      local defender_sc = defender:subculture();
      if self.culture_to_trait[defender_sc] == nil then return end

      self:cleanup_encounter_for_faction(defender:name());
    end,
    true
  );

  core:add_listener(
    "owc_EndOfRound_encounter_faction_cleanup",
    "FactionTurnEnd",
    ---@param context FactionTurnEnd
    function(context)
      local faction = context:faction();
      return self:faction_is_supported(faction) and faction:is_human();
    end,
    ---@param context FactionTurnEnd
    function(context)
      local faction_name = context:faction():name();
      self:cleanup_encounter_for_faction(faction_name);
    end,
    true
  );

  core:add_listener(
    "owc_clean_up_attacker",
    "FactionTurnStart",
    ---@param context FactionTurnStart
    ---@return boolean
    function(context)
      local faction_name = context:faction():name();
      local faction_sc = context:faction():subculture();
      return self.culture_to_enemy_faction[faction_sc] == faction_name;
    end,
    ---@param context FactionTurnStart
    function(context)
      cm:disable_event_feed_events(true, "", "", "diplomacy_faction_destroyed");

      local human_factions = cm:get_human_factions();

      for i = 1, #human_factions do
        local faction = human_factions[i]
        if cm:get_saved_value(self.encounter_faction_save_key .. faction) then
          self:cleanup_encounter_for_faction(faction);
        end
      end
    end,
    true
  );

  core:add_listener("owc_quest_item_triggered",
    "ScriptEventTriggerQuestChain",
    true,
    function()
      self:log("ScriptEventTriggerQuestChain")
      self.encounter_should_be_canceled = true
    end,
    true);

  core:add_listener(
    "owc_caravan_event_update",
    "WorldStartRound",
    true,
    function(context)
      self.events_fired = {};
    end,
    true
  );

  core:add_listener(
    "owc_caravan_complete_battle",
    "CharacterCompletedBattle",
    ---@param context CharacterCompletedBattle
    function(context)
      local character = context:character();
      local force_type = character:military_force():force_type():key();

      return character:faction():is_human() and character:has_military_force() and
      force_type == "CARAVAN" or force_type == "EMP_CARAVAN";
    end,
    function(context)
      local character = context:character();
      if not self:faction_is_supported(character:faction()) then return end
      local caravan_system = cm:model():world():caravans_system():faction_caravans(character:faction());

      if caravan_system:is_null_interface() then return end
      local active_caravans = caravan_system:active_caravans();
      if active_caravans:is_empty() then return end

      for i = 0, active_caravans:num_items() - 1 do
        if character:command_queue_index() == active_caravans:item_at(i):caravan_master():character():command_queue_index() then
          ---@diagnostic disable-next-line: undefined-field
          cm:move_caravan(active_caravans:item_at(i));
          uim:override("retreat"):unlock();
        end
      end
    end,
    true
  );

end;
