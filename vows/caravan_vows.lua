Old_world_caravans_vows = {
  vow_max_points = {
    ["owc_trait_grail_vow_caravan_cargo"] = 2,
    ["owc_trait_grail_vow_caravan_lustria"] = 2,
    ["owc_trait_grail_vow_caravan_arabia"] = 2,
    ["owc_trait_knights_vow_caravan_units"] = 3,
    ["owc_trait_knights_vow_caravan_levels"] = 5,
    ["owc_trait_knights_vow_caravan_battles"] = 4,
    ["owc_trait_questing_vow_caravan_count"] = 3,
  },
  region_to_vow = {
    ["wh3_main_combi_region_temple_of_tlencan"] = "owc_trait_grail_vow_caravan_lustria",
    ["wh3_main_combi_region_temple_of_kara"] = "owc_trait_grail_vow_caravan_lustria",
    ["wh3_main_combi_region_copher"] = "owc_trait_grail_vow_caravan_arabia",
    ["wh3_main_combi_region_zandri"] = "owc_trait_grail_vow_caravan_arabia",
  }
}

---@param character CHARACTER_SCRIPT_INTERFACE
---@param trait string
function Old_world_caravans_vows:add_vow_progress(character, trait)
  if character:is_null_interface() then return end

  local faction = character:faction()
  local char_cqi = character:cqi()
  local faction_cqi = faction:command_queue_index()
  local points = character:trait_points(trait)
  local max_trait_points = self.vow_max_points[trait] or 6
  local incident = "wh_dlc07_incident_brt_vow_gained"

  if points > 0 and points < max_trait_points then
    cm:force_add_trait(cm:char_lookup_str(character), trait, false, 1)
    points = points + 1

    if points == max_trait_points then
      out.design("\tTriggering event: " .. char_cqi)
      ---@diagnostic disable-next-line: param-type-mismatch
      cm:trigger_incident_with_targets(faction_cqi, incident, 0, 0, char_cqi, 0, 0, 0)
    end
  end
end

---@param character CHARACTER_SCRIPT_INTERFACE
---@param trait string
function Old_world_caravans_vows:force_add_vow(character, trait)
  if character:is_null_interface() then return end

  local max_trait_points = self.vow_max_points[trait] or 6
  cm:force_add_trait(cm:char_lookup_str(character), trait, false, max_trait_points)
end

function Old_world_caravans_vows:add_vow_listeners()
  core:add_listener(
    "OWC_Vow_CharacterCreated",
    "CaravanRecruited",
    ---@param context CaravanRecruited
    function(context)
      local character = context:caravan_master():character()
      local faction = character:faction()

      return faction:is_human() and faction:culture() == "wh_main_brt_bretonnia"
    end,
    function(context)
      local character = context:caravan_master():character()
      local faction = character:faction()

      local active_effect = faction:pooled_resource_manager():resource("brt_chivalry"):active_effect(0)
      local char_str = cm:char_lookup_str(character)

      if active_effect == "wh_dlc07_bretonnia_chivalry_bar_801_1000" then
        self:force_add_vow(character, "owc_trait_knights_vow_caravan_levels")
        self:force_add_vow(character, "owc_trait_questing_vow_caravan_count")

        cm:callback(function()
          cm:force_remove_trait(char_str, "wh_dlc07_trait_brt_knights_vow_knowledge_pledge")
          cm:force_remove_trait(char_str, "wh_dlc07_trait_brt_questing_vow_protect_pledge")
        end, 0.5)
      elseif active_effect == "wh_dlc07_bretonnia_chivalry_bar_601_800" or active_effect == "wh_dlc07_bretonnia_chivalry_bar_401_600" then
        self:force_add_vow(character, "owc_trait_knights_vow_caravan_levels")

        cm:callback(function()
          cm:force_remove_trait(char_str, "wh_dlc07_trait_brt_knights_vow_knowledge_pledge")
        end, 0.5)
      end
    end,
    true
  )

  core:add_listener(
    "owc_postbattle_faction_cleanup",
    "BattleCompleted",
    ---@param context BattleCompleted
    function(context)
      local pb = context:model():pending_battle();
      local defender

      if pb:has_been_fought() then
        local defender_cqi = cm:pending_battle_cache_get_defender(1);
        local defender_char = cm:get_character_by_cqi(defender_cqi)
        if defender_char and not defender_char:is_null_interface() then
          defender = defender_char:character_subtype_key();
        end
      else
        defender = pb:defender():character_subtype_key();
      end

      return defender == "wh_main_brt_caravan_master"
    end,
    ---@param context BattleCompleted
    function(context)
      local pb = context:model():pending_battle();
      local defender ---@type CHARACTER_SCRIPT_INTERFACE

      if pb:has_been_fought() then
        local defender_cqi = cm:pending_battle_cache_get_defender(1);
        defender = cm:get_character_by_cqi(defender_cqi)
      else
        defender = pb:defender();
      end

      self:add_vow_progress(defender, "owc_trait_knights_vow_caravan_battles")
    end,
    true
  );

  core:add_listener(
    "owc_character_rank_up_pledge_to_chivalry",
    "CharacterRankUp",
    ---@param context CharacterRankUp
    ---@return boolean
    function(context)
      local agent_type = context:character():character_subtype_key()

      return agent_type == "wh_main_brt_caravan_master"
    end,
    function(context)
      local character = context:character()
      local ranks_gained = context:ranks_gained()

      for _ = 1, ranks_gained do
        self:add_vow_progress(character, "owc_trait_knights_vow_caravan_levels")
      end
    end,
    true
  )

  core:add_listener(
    "owc_vow_caravan_new_units",
    "ScriptEventOwcNewUnitsDilemma",
    ---@param context CharacterRankUp
    ---@return boolean
    function(context)
      local agent_type = context:character():character_subtype_key()

      return agent_type == "wh_main_brt_caravan_master"
    end,
    function(context)
      local character = context:character()

      self:add_vow_progress(character, "owc_trait_knights_vow_caravan_units")
    end,
    true
  )
  core:add_listener(
    "owc_vow_caravan_lose_cargo",
    "ScriptEventOwcLoseCargo",
    ---@param context CharacterRankUp
    ---@return boolean
    function(context)
      local agent_type = context:character():character_subtype_key()
      return agent_type == "wh_main_brt_caravan_master"
    end,
    function(context)
      local character = context:character()

      self:add_vow_progress(character, "owc_trait_grail_vow_caravan_cargo")
    end,
    true
  )

  core:add_listener(
    "owc_vow_caravan_new_hero",
    "ScriptEventOwcNewHeroDilemma",
    ---@param context CharacterRankUp
    ---@return boolean
    function(context)
      local agent_type = context:character():character_subtype_key()

      return agent_type == "wh_main_brt_caravan_master"
    end,
    function(context)
      local character = context:character()

      core:add_listener(
        "owc_vow_caravan_new_hero_choice",
        "DilemmaChoiceMadeEvent",
        true,
        ---@param dilemmaContext DilemmaChoiceMadeEvent
        function(dilemmaContext)
          if dilemmaContext:choice() ~= 0 then
            self:add_vow_progress(character, "owc_trait_knights_vow_caravan_units")
          end
        end,
        false
      );
    end,
    true
  )

  core:add_listener(
    "owc_CaravanCompleted",
    "CaravanCompleted",
    ---@param context CaravanCompleted
    function(context)
      local agent_type = context:caravan_master():character():character_subtype_key()
      return agent_type == "wh_main_brt_caravan_master"
    end,
    ---@param context CaravanCompleted
    function(context)
      local faction = context:faction()
      if not faction:is_human() then return end
      local character = context:caravan_master():character()
      self:add_vow_progress(character, "owc_trait_questing_vow_caravan_count")

      local node = context:complete_position():node()
      local region_name = node:region_key()
      local grail_vow_trait = self.region_to_vow[region_name];

      if grail_vow_trait then
        self:add_vow_progress(character, grail_vow_trait)
      end

    end,
    true
  )
end

Old_world_caravans_vows:add_vow_listeners()
