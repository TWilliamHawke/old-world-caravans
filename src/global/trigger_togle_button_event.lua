---@param faction FACTION_SCRIPT_INTERFACE
---@param state boolean
function Old_world_caravans:trigger_toggle_button_event(faction, state)
  core:trigger_custom_event("ScriptEventOwcToggleCaravanButton", {
    faction = faction,
    state = state
  });
end
