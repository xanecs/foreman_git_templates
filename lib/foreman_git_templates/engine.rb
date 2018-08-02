# frozen_string_literal: true

module ForemanGitTemplates
  class Engine < ::Rails::Engine
    engine_name 'foreman_git_templates'

    config.autoload_paths += Dir["#{config.root}/app/lib"]
    config.autoload_paths += Dir["#{config.root}/app/services"]

    initializer 'foreman_git_templates.register_plugin', before: :finisher_hook do |_app|
      Foreman::Plugin.register :foreman_git_templates do
        requires_foreman '>= 1.20'
      end
    end

    # Include concerns in this config.to_prepare block
    config.to_prepare do
      begin
        Foreman::Renderer.singleton_class.prepend(ForemanGitTemplates::Renderer)
        Host::Managed.include(ForemanGitTemplates::Hostext::OperatingSystem)
      rescue StandardError => e
        Rails.logger.warn "ForemanGitTemplates: skipping engine hook (#{e})"
      end
    end

    initializer 'foreman_git_templates.register_gettext', after: :load_config_initializers do |_app|
      locale_dir = File.join(File.expand_path('../..', __dir__), 'locale')
      locale_domain = 'foreman_git_templates'
      Foreman::Gettext::Support.add_text_domain locale_domain, locale_dir
    end
  end
end
