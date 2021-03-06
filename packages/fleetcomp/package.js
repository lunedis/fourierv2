Package.describe({
  name: 'fleetcomp',
  version: '0.1.0',
  // Brief, one-line summary of the package.
  summary: 'lumpy fleet composition tools',
  // URL to the Git repository containing the source code for this package.
  git: '',
  // By default, Meteor will default to using README.md for documentation.
  // To avoid submitting documentation, set this field to null.
  documentation: 'README.md'
});

Package.onUse(function(api) {
  api.use('coffeescript');
  api.use('underscore');
  api.use('evesde', 'server');

  api.export('parseFleetcomp', 'server');
  
  api.addFiles('fleetcomps.coffee', 'server');
  //api.addFiles('routes.coffee', ['server', 'client']);
});

Package.onTest(function(api) {
  api.use('coffeescript');
  api.use('tinytest');
  api.use('fleetcomp');
  api.addFiles('fleetcomp-tests.coffee', 'server');
});
