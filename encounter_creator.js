const path = require("path");
const fs = require("fs/promises");

const encountersPath = path.join(process.cwd(), "src", "encounters");

const encounter_creator = async (name) => {
  const newPath = path.join(encountersPath, name);
  await fs.mkdir(newPath);

  const creator = path.join(newPath, `${name}_creator.lua`);
  const handler = path.join(newPath, `${name}_handler.lua`);

  const creator_data = `---@param context Encounter_creator_context
---@return integer encounter_probability
function Old_world_caravans:${name}_creator(context)
\treturn 1
end`;

  const handlerData = `---@param context CaravanWaylaid
function Old_world_caravans:${name}_handler(context)

end`;

  await fs.writeFile(creator, creator_data);
  await fs.writeFile(handler, handlerData);
};

encounter_creator("daemons_attack");
