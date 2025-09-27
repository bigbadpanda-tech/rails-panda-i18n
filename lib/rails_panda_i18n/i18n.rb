module RailsPanda
  module Internationalization
    extend ActiveSupport::Concern

    require "http_accept_language"

    module ClassMethods
      def use_rails_panda_i18n(options = {})
        options = {
          setup_default_url_options: true,
          setup_class_default_url_options: true,
          setup_instance_default_url_options: true,
          setup_locale_on_before_action: true,
          enable_cookie_support: true,
          cookie_name: :hl,
          enable_param_support: true,
          param_name: :hl
        }.merge(options)

        if options[:enable_cookie_support]
          mattr_accessor :ui_language_cookie_name
          self.ui_language_cookie_name = options[:cookie_name].to_sym
        else
          mattr_reader :ui_language_cookie_name
        end

        if options[:enable_param_support]
          mattr_accessor :ui_language_param_name
          self.ui_language_param_name = options[:param_name].to_sym

          if options[:setup_default_url_options] && options[:setup_class_default_url_options]
            include RailsPanda::Internationalization::MethodClassDefaultUrlOptions
          end

          if options[:setup_default_url_options] && options[:setup_instance_default_url_options]
            include RailsPanda::Internationalization::MethodInstanceDefaultUrlOptions
          end

        else
          mattr_reader :ui_language_param_name
        end

        before_action :rails_panda__set_locale if options[:setup_locale_on_before_action]

        include RailsPanda::Internationalization::Methods
      end
    end

    module MethodClassDefaultUrlOptions
      extend ActiveSupport::Concern

      module ClassMethods
        def default_url_options(options = {})
          rails_panda__add_ui_language_to options
        end
      end
    end

    module MethodInstanceDefaultUrlOptions
      extend ActiveSupport::Concern

      def default_url_options(options = {})
        rails_panda__add_ui_language_to options
      end
    end

    module Methods
      extend ActiveSupport::Concern

      module ClassMethods
        def rails_panda__add_ui_language_to(options = {})
          options.merge(ui_language_param_name => I18n.locale) unless ui_language_param_name.nil?
        end
      end

      def rails_panda__add_ui_language_to(options = {})
        options.merge(ui_language_param_name => I18n.locale) unless ui_language_param_name.nil?
      end

      def rails_panda__set_locale
        new_locale = rails_panda__get_user_locale || I18n.default_locale

        I18n.locale = new_locale

        unless ui_language_cookie_name.nil?
          cookies[ui_language_cookie_name] = {
            value: new_locale,
            expires: 1.year.from_now
          }
        end
      end

      def rails_panda__get_user_locale
        available_langs = I18n.available_locales

        cookie_lang = cookies[ui_language_cookie_name] unless ui_language_cookie_name.nil?
        params_lang = params[ui_language_param_name] unless ui_language_param_name.nil?

        if params_lang.present? && available_langs.include?(params_lang.to_sym)
          params_lang
        elsif cookie_lang.present? && available_langs.include?(cookie_lang.to_sym)
          cookie_lang
        else
          http_accept_language.compatible_language_from available_langs
        end
      end
    end
  end
end

ActiveSupport.on_load(:action_controller) { include RailsPanda::Internationalization }
