module.exports = ({ env }) => ({
  sync: {
    enabled: true,
    type: "file",
    importOnBootstrap: env.bool("STRAPI_IMPORT_ON_BOOTSTRAP", false),
    customTypes: [],
    excludedTypes: [],
    excludedConfig: [
      "core-store.plugin_users-permissions_grant",
      "core-store.plugin_content_manager_configuration_content_types",
    ],
  },
});
