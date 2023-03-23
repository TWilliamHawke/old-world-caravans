---ugly hack because adding caravan master to pool causes crash
---@param faction_name string
function Old_world_caravans:unlock_caravan_recruitment(faction_name)
  if cm:get_campaign_name() ~= "main_warhammer" then return end
  local agent_subtype = self.faction_to_caravan_master[faction_name];
  if not agent_subtype then return end

  local faction = cm:get_faction(faction_name);
  if not faction or not self:faction_has_caravans(faction) then return end

  self:logCore("unlock caravans for "..faction_name)

  local region = "wh3_main_combi_region_altdorf"
  local faction_regions = faction:region_list();

  --avoid the trespassing
  if faction_regions:num_items() > 0 then
    region = faction_regions:item_at(0):name();
  end

  local x, y = self:find_position_for_spawn(faction_name, region);

  cm:create_force_with_general(faction_name, "", region,
    x, y, "general", agent_subtype, "", "", "", "", false,
    function(char_cqi)
      cm:disable_event_feed_events(true, "wh_event_category_character", "", "");

      cm:callback(function()
        cm:callback(function()
          cm:disable_event_feed_events(false, "wh_event_category_character", "", "");
        end, 0.2);
        cm:kill_character(char_cqi, true);
      end, 0.2)
    end);
end
