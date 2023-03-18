---@diagnostic disable: undefined-field
function Old_world_caravans:recruit_start_caravan()
  local model = cm:model();
  local faction_list = model:world():faction_list();
  for i = 0, faction_list:num_items() - 1 do
    local faction = faction_list:item_at(i)
    local subculture = faction:subculture();

    local caravans_list = model:world():caravans_system():faction_caravans(faction);
    local faction_is_sutable = faction:is_human()
      and self.culture_to_trait[subculture]
      and subculture ~= "wh3_main_sc_cth_cathay"
      and faction:name() ~= "wh_main_dwf_karak_izor"
      and not caravans_list:is_null_interface();

    if faction_is_sutable then
      local available_caravans = caravans_list:available_caravan_recruitment_items();

      if not available_caravans:is_empty() then
        local temp_caravan = available_caravans:item_at(0);
        if temp_caravan:is_null_interface() then
          break
        end

        cm:recruit_caravan(faction, temp_caravan);
        cm:treasury_mod(faction:name(), 800);
        CampaignUI.ClearSelection();

      end
    end
  end

end
