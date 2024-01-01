---@diagnostic disable: undefined-field
---@param faction_name string
function Old_world_caravans:recruit_start_caravan(faction_name)
  local faction = cm:get_faction(faction_name);
  if not faction then return end;
  if not self:faction_is_supported(faction) then return end

  local caravans_list = cm:model():world():caravans_system():faction_caravans(faction);
  if not caravans_list then return end
  if caravans_list:is_null_interface() then return end
  if not self:caravan_button_should_be_visible(faction) then return end
  local available_caravans = caravans_list:available_caravan_recruitment_items();

  if available_caravans:is_empty() then return end
  local temp_caravan = available_caravans:item_at(0);
  if not temp_caravan then return end
  if temp_caravan:is_null_interface() then return end

  cm:recruit_caravan(faction, temp_caravan);
  cm:treasury_mod(faction:name(), 800);
  CampaignUI.ClearSelection();
end
