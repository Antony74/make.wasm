const fsp = require('fs/promises');

const [_program, _script, resultFilename, inputFilename] = process.argv;

fsp.readFile(inputFilename, { encoding: 'utf-8' }).then((raw) => {
    const result = JSON.parse(raw).reverse();
    fsp.writeFile(resultFilename, JSON.stringify(result));
});