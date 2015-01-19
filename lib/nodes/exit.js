var runtime = require('../runtime')

function Exit() {}
exports.Exit = Exit

Exit.prototype.eval = function(scope) {
    process.exit(0)
}
