Package.describe({
  name: 'lumpy-auth',
  version: '1.0.0',
  summary: 'Ldap login for lumpy auth, based on meteor-accounts-ldap',
  git: 'https://github.com/typ90/meteor-accounts-ldap',
  documentation: 'README.md'
});


Package.onUse(function(api) {
  api.versionsFrom('1.0.3.1');

  api.use('coffeescript', ['server','client']);
  api.use('underscore',  ['server','client']);

  api.use(['templating'], 'client');
  api.use(['typ:ldapjs@0.7.3'], 'server');


  api.use('accounts-base', 'server');
  api.imply('accounts-base', ['client', 'server']);
  api.imply('accounts-base', ['client', 'server']);

  api.use('check');

  api.addFiles(['ldap_client.coffee'], 'client');
  api.addFiles(['ldap_server.coffee'], 'server');

  api.export('LDAP', 'server');
});