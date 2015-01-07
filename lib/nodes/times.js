var runtime = require('../runtime')

function Times(count, body) {
  this.count = count;
  this.body = body;
}
exports.Times = Times

Times.prototype.eval = function(scope) {
  while (this.count.value > 0) {
    this.body.eval(scope);
    this.count.value--;
  }

  return runtime.empty
}
