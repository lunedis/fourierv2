Package.describe({
  name: 'evesde',
  version: '0.2.0',
  // Brief, one-line summary of the package.
  summary: 'evesde',
  // URL to the Git repository containing the source code for this package.
  git: '',
  // By default, Meteor will default to using README.md for documentation.
  // To avoid submitting documentation, set this field to null.
  documentation: 'README.md'
});

Package.onUse(function(api) {
  api.use('coffeescript', ['server', 'client']);
  api.use('underscore', ['server', 'client']);
  api.use('livedata', 'server');

  api.export('InvTypes', 'server');
  api.export('MapSolarSystems', 'server');

  api.addFiles('invtypes.coffee', 'server');
  api.addFiles('mapsolarsystems.coffee', 'server');
});

Package.onTest(function(api) {
  api.use('coffeescript');
  api.use('tinytest');
  api.use('evesde');

  api.addFiles('evesde-tests.coffee', 'server');
});