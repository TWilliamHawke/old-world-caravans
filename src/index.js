const fs = require('fs');
const path = require("path");


const walkSync = function(dir, filelist) {
  const files = fs.readdirSync(dir);
  filelist = filelist || [];
  
  files.forEach(file => {
    if(file.includes(".js")) return;
    
    const filePath = path.join(dir, file);

    if (fs.statSync(filePath).isDirectory()) {
      filelist = walkSync(filePath, filelist);
    } else {
      filelist.push(filePath);
    }
  });
  return filelist;
};

const write = () => {
  const sourceDir = path.join(process.cwd(), "src");
  const files = walkSync(sourceDir);
  let data = ''
  for(file of files) {
    const fileBody = fs.readFileSync(file, { encoding: 'utf8' });
    data = data.concat("\n\n" + fileBody);
  }
//
  const targetDir = path.join(process.cwd(), "bundle.lua");
  fs.writeFileSync(targetDir, data);
}

write()