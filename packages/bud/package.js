Package.describe({
  name: 'bud',
  version: '0.1.0',
  // Brief, one-line summary of the package.
  summary: 'lumpy slack bot',
  // URL to the Git repository containing the source code for this package.
  git: '',
  // By default, Meteor will default to using README.md for documentation.
  // To avoid submitting documentation, set this field to null.
  documentation: 'README.md'
});

Package.onUse(function(api) {
  api.use('coffeescript', ['server']);
  api.use('underscore', ['server', 'client']);
  api.use('iron:router', ['server']);
  api.use('meteorhacks:async',['server']);
  api.addFiles('routes.coffee', 'server');
  api.addFiles('mapsolarsystems.coffee', 'server');
  api.addFiles('theraholes.coffee', 'server')
  api.addFiles('routing.coffee', 'server');
});

Package.onTest(function(api) {
  api.use('coffeescript');
  api.use('tinytest');
  api.use('underscore');
  api.use('bud');
  api.addFiles('bud-tests.coffee', 'server');
});

Npm.depends({
  "request": "2.67.0",
  "cheerio": "0.19.0",
  "neo4j": "2.0.0-RC2"
});
