---@diagnostic disable: param-type-mismatch
---@param faction FACTION_SCRIPT_INTERFACE
---@param region_name string
function Old_world_caravans:give_caravan_award(faction, region_name)
  local faction_sc = faction:subculture();
  local award = self.awards[faction_sc] and self.awards[faction_sc][region_name];

  if not award then return end

  if self.award_types[faction_sc] == "item" then
    self:log("get item ")

    if faction:ancillary_exists(award) then return end

    local incident_payload = cm:create_payload();
    incident_payload:faction_ancillary_gain(faction, award);
    cm:trigger_custom_incident(faction:name(), "emp_caravan_completed", true, incident_payload);
  elseif self.award_types[faction_sc] == "resource" then
    self:log("get resource ")
    cm:faction_add_pooled_resource(faction:name(), award, "missions", 1);
  end
  self:log("award is " .. award)
end
