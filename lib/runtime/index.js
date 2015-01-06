require('../utils').requireAllInto(__dirname, exports)
var kbd = require('kbd')

var runtime = exports,
    root = runtime.root = new runtime.Scope()

// The null object
runtime.empty = new runtime.Object()
runtime.true = new runtime.Object(true)
runtime.false = new runtime.Object(false)

runtime.bool = function(value) {
  return value ? runtime.true : runtime.false
}

root.this = root

root.set('write', function(what) {
  console.log(what.value)
})

root.set('between', function(bounds) {
    var lower = parseInt(bounds.value.split(" ")[0])
    var upper = parseInt(bounds.value.split(" ")[1])
    return new runtime.Object(Math.floor(Math.random() * (upper+1 - lower)) + lower)
})

root.set('ask', function(question) {
    process.stdout.write(question.value + " ")
    return new runtime.Object(kbd.getLineSync())
})
