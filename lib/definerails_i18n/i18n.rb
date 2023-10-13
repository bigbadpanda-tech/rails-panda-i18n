module DefineRails
  module Internationalization
    extend ActiveSupport::Concern

    require "http_accept_language"

    module ClassMethods

      def use_definerails_i18n(options = {})
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
        end

        if options[:enable_param_support]
          mattr_accessor :ui_language_param_name
          self.ui_language_param_name = options[:param_name].to_sym

          if options[:setup_default_url_options] &&
             options[:setup_class_default_url_options]
            include DefineRails::Internationalization::MethodClassDefaultUrlOptions
          end

          if options[:setup_default_url_options] &&
             options[:setup_instance_default_url_options]
            include DefineRails::Internationalization::MethodInstanceDefaultUrlOptions
          end

        end

        before_action :definerails__set_locale if options[:setup_locale_on_before_action]

        include DefineRails::Internationalization::Methods
      end

    end

    module MethodClassDefaultUrlOptions
      extend ActiveSupport::Concern

      module ClassMethods

        def default_url_options(options={})
          definerails__add_ui_language_to options
        end

      end

    end

    module MethodInstanceDefaultUrlOptions
      extend ActiveSupport::Concern

      def default_url_options(options={})
        definerails__add_ui_language_to options
      end

    end

    module Methods
      extend ActiveSupport::Concern

      module ClassMethods

        def definerails__add_ui_language_to(options={})
          options.merge(ui_language_param_name => I18n.locale)
        end

      end

      def definerails__add_ui_language_to(options={})
        options.merge(ui_language_param_name => I18n.locale)
      end

      def definerails__set_locale
        new_locale = definerails__get_user_locale || I18n.default_locale

        I18n.locale = new_locale

        lang_cookie_name = ui_language_cookie_name
        return unless lang_cookie_name

        cookie_lang = cookies[lang_cookie_name]
        cookies[lang_cookie_name] = {
          value: new_locale,
          expires: 1.year.from_now
        } if cookie_lang != new_locale
      end

      def definerails__get_user_locale
        available_langs = I18n.available_locales

        lang_cookie_name = ui_language_cookie_name
        lang_param_name = ui_language_param_name

        params_lang = params[lang_param_name] if lang_param_name
        cookie_lang = cookies[lang_cookie_name] if lang_cookie_name

        if params_lang && available_langs.include?(params_lang.to_sym)
          params_lang
        elsif cookie_lang && available_langs.include?(cookie_lang.to_sym)
          cookie_lang
        else
          http_accept_language.compatible_language_from available_langs
        end
      end

    end

  end
end

ActiveSupport.on_load(:action_controller) { include DefineRails::Internationalization }
