var runtime = require('../runtime')

function If(condition, body, optional) {
  this.condition = condition
  this.body = body
  this.optional = optional
}
exports.If = If

If.prototype.eval = function(scope) {
  if (this.condition.eval(scope).value) {
    this.body.eval(scope)
  } else {
    if(this.optional){ this.optional.eval(scope) }
  }

  return runtime.empty
}
