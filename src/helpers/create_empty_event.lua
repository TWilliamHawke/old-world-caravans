function Old_world_caravans:create_empty_event(culture)
  caravans.event_tables[culture] = {};
  caravans.event_tables[culture].owc = {
    function()
      return { 0 }
    end,
    function()
    end
  }

end