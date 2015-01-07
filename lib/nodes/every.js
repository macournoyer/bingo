var runtime = require('../runtime')

function Every(count, body) {
  this.count = count;
  this.body = body;
}
exports.Every = Every

Every.prototype.eval = function(scope) {
  var self = this;
  setInterval(function() {
    self.body.eval(scope);
  }, this.count.value);

  return runtime.empty
}
