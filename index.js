
"use strict";

var program     = require('commander');


var storedProcedure = require('./components/storedProcedure');

program
  .version('0.0.1');

program
  .command('spbackup')
  .description('backup stored procedure')
  .option("-d, --dump", "dump stored procedure from mysql database")
  .option("-s, --separate", "depart dumped .sql file to separete stored procedure")
  .option("-i, --infile [infile]", "input sql file, default is backup.sql")
  .option("-o, --outdir [outdir]", "output folder, default is .")
  .action(function(options) {
    var isDump = options.dump;
    var isSeparate = options.separate;
    var infile = options.infile || "backup.sql"
    var outdir = options.outdir || "./stored-procedures"
    storedProcedure.process(isDump, isSeparate, infile, outdir);
    // console.log('options', options);
  })


program.parse(process.argv);
