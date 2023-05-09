function Old_world_caravans:add_mct_listeners()
  core:add_listener(
    "owc_mct_init",
    "MctInitialized",
    true,
    function(context)
      self:mct_init(context)
      self:logCore("MCT was INIT")
    end,
    true
  )

  core:add_listener(
    "owc_MctFinalized",
    "MctFinalized",
    true,
    function(context)
      self:finalize_mct(context)
      self:mct_init(context)
      --self:test_army_generator()
      self:logCore("MCT FINALIZED")
    end,
    true
  )

end;