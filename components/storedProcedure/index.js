
var CLI = require('clui');
var Spinner = CLI.Spinner;
var fs = require('fs');
var path = require('path');
var childProcess = require('child_process');

exports.dump = function (infile) {
//mysqldump -u root -proot -h 33.33.33.1 --routines --no-create-info --no-data --no-create-db --skip-opt test > outputfile.sql
console.log(infile)
  childProcess.execSync("mysqldump -u root -proot -h 33.33.33.1 --routines --no-create-info --no-data --no-create-db --skip-opt test > outputfile.sql");
}

var getFileName = function (script) {
  const regex = /(FUNCTION `|PROCEDURE `)(.*?)(`)/;
  filename = "";
  if ((m = regex.exec(script)) !== null) {
    // The result can be accessed through the `m`-variable.
    m.forEach((match, groupIndex) => {
      if (groupIndex == 2) {
        filename = match + '.sql';
      }
    });
  }
  return filename;
}

var removeAllSql = function (dirPath, includeChildren = false, removeFolders = false) {
  try {
    var files = fs.readdirSync(dirPath);
  }
  catch (e) {
    return;
  }
  if (files.length > 0) {
    for (var i = 0; i < files.length; i++) {
      var filePath = path.join(dirPath, files[i]);
      if (fs.statSync(filePath).isFile()) {
        fs.unlinkSync(filePath);
      }
      else if (includeChildren) {
        removeAllSql(filePath);
      }
    }
  }
  if (removeFolders) {
    fs.rmdirSync(dirPath);
  }
};

exports.separate = function (infile, outdir) {
  console.log('Read from:', infile);
  console.log('Write to', outdir);
  fs.readFile(infile, 'utf8', function (err, data) {
    if (err) {
      return console.error(err);
    }
    removeAllSql(outdir);
    const regex = /(DELIMITER ;;)((.|\n)*?)(DELIMITER ;)/g;

    data = data.replace(/\r\n/g, "\n");

    let m;

    while ((m = regex.exec(data)) !== null) {
      // This is necessary to avoid infinite loops with zero-width matches
      if (m.index === regex.lastIndex) {
        regex.lastIndex++;
      }

      m.forEach((match, groupIndex) => {
        if (groupIndex == 2) {
          var filename = path.join(outdir, getFileName(match));
          console.log('Creating', filename);
          try {
            fs.writeFileSync(filename, match);
            console.log(filename, 'created');
          }
          catch (e) {
            console.log('Error on create', filename, match);
          }

        }
      });
    }

    console.log('Separate stored procedures finished');

  });
}

exports.process = function (isDump, isSeparate, infile, outdir) {
  if (isDump) {
    this.dump(infile)
  }
  if (isSeparate) {
    this.separate(infile, outdir)
  }
}
