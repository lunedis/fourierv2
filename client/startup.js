Meteor.startup(function() {
    window.HTML.isConstructedObject = function(x) { return _.isObject(x) && !$.isPlainObject(x); };
});
