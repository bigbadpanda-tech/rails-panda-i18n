require "rails_helper"

RSpec.describe RailsPanda::I18n do
  let(:controller_class) do
    Class.new(ApplicationController) do
      include RailsPanda::I18n

      def self.name = "TestController"
    end
  end

  it "includes the module in ActionController::Base via ActiveSupport.on_load" do
    # This ensures line 121 (ActiveSupport.on_load) is covered
    # The callback executes when ActionController loads, which happens before tests
    expect(ActionController::Base.included_modules).to include(described_class)

    # Explicitly trigger the callback to ensure coverage
    # Since ActionController is already loaded, this will execute immediately
    ActiveSupport.run_load_hooks(:action_controller, ActionController::Base)
  end

  describe ".use_rails_panda_i18n" do
    context "with default options" do
      before do
        controller_class.use_rails_panda_i18n
      end

      it "sets up cookie support with default name" do
        expect(controller_class.ui_language_cookie_name).to eq(:hl)
      end

      it "sets up param support with default name" do
        expect(controller_class.ui_language_param_name).to eq(:hl)
      end

      it "includes Methods module" do
        expect(controller_class.included_modules).to include(RailsPanda::I18n::Methods)
      end

      it "includes MethodClassDefaultUrlOptions module" do
        expect(controller_class.included_modules).to include(RailsPanda::I18n::MethodClassDefaultUrlOptions)
      end

      it "includes MethodInstanceDefaultUrlOptions module" do
        expect(controller_class.included_modules).to include(RailsPanda::I18n::MethodInstanceDefaultUrlOptions)
      end

      it "adds before_action callback for locale setting" do
        callbacks = controller_class._process_action_callbacks.select { |c| c.filter == :rails_panda__set_locale }
        expect(callbacks).not_to be_empty
      end
    end

    context "with custom cookie name" do
      before do
        controller_class.use_rails_panda_i18n(cookie_name: :language)
      end

      it "uses the custom cookie name" do
        expect(controller_class.ui_language_cookie_name).to eq(:language)
      end
    end

    context "with custom param name" do
      before do
        controller_class.use_rails_panda_i18n(param_name: :lang)
      end

      it "uses the custom param name" do
        expect(controller_class.ui_language_param_name).to eq(:lang)
      end
    end

    context "with cookie support disabled" do
      before do
        controller_class.use_rails_panda_i18n(enable_cookie_support: false)
      end

      it "does not set cookie name" do
        expect(controller_class.ui_language_cookie_name).to be_nil
      end

      it "defines mattr_reader for ui_language_cookie_name" do
        expect(controller_class).to respond_to(:ui_language_cookie_name)
        expect(controller_class).not_to respond_to(:ui_language_cookie_name=)

        expect(controller_class.ui_language_cookie_name).to be_nil
      end
    end

    context "with param support disabled" do
      before do
        controller_class.use_rails_panda_i18n(enable_param_support: false)
      end

      it "does not set param name" do
        expect(controller_class.ui_language_param_name).to be_nil
      end

      it "defines mattr_reader for ui_language_param_name" do
        expect(controller_class).to respond_to(:ui_language_param_name)
        expect(controller_class).not_to respond_to(:ui_language_param_name=)

        expect(controller_class.ui_language_param_name).to be_nil
      end

      it "does not include URL options modules" do
        expect(controller_class.included_modules).not_to include(RailsPanda::I18n::MethodClassDefaultUrlOptions)
        expect(controller_class.included_modules).not_to include(RailsPanda::I18n::MethodInstanceDefaultUrlOptions)
      end
    end

    context "with both supports disabled" do
      before do
        controller_class.use_rails_panda_i18n(enable_cookie_support: false, enable_param_support: false)
      end

      it "does not set cookie name" do
        expect(controller_class.ui_language_cookie_name).to be_nil
      end

      it "does not set param name" do
        expect(controller_class.ui_language_param_name).to be_nil
      end
    end

    context "with setup_default_url_options disabled" do
      before do
        controller_class.use_rails_panda_i18n(setup_default_url_options: false)
      end

      it "does not include URL options modules" do
        expect(controller_class.included_modules).not_to include(RailsPanda::I18n::MethodClassDefaultUrlOptions)
        expect(controller_class.included_modules).not_to include(RailsPanda::I18n::MethodInstanceDefaultUrlOptions)
      end
    end

    context "with setup_class_default_url_options disabled" do
      before do
        controller_class.use_rails_panda_i18n(setup_class_default_url_options: false)
      end

      it "does not include MethodClassDefaultUrlOptions module" do
        expect(controller_class.included_modules).not_to include(RailsPanda::I18n::MethodClassDefaultUrlOptions)
      end

      it "still includes MethodInstanceDefaultUrlOptions module" do
        expect(controller_class.included_modules).to include(RailsPanda::I18n::MethodInstanceDefaultUrlOptions)
      end
    end

    context "with setup_instance_default_url_options disabled" do
      before do
        controller_class.use_rails_panda_i18n(setup_instance_default_url_options: false)
      end

      it "does not include MethodInstanceDefaultUrlOptions module" do
        expect(controller_class.included_modules).not_to include(RailsPanda::I18n::MethodInstanceDefaultUrlOptions)
      end

      it "still includes MethodClassDefaultUrlOptions module" do
        expect(controller_class.included_modules).to include(RailsPanda::I18n::MethodClassDefaultUrlOptions)
      end
    end

    context "with setup_locale_on_before_action disabled" do
      before do
        controller_class.use_rails_panda_i18n(setup_locale_on_before_action: false)
      end

      it "does not add before_action callback" do
        # Check that the callback is not in the _process_action_callbacks
        callbacks = controller_class._process_action_callbacks.select { |c| c.filter == :rails_panda__set_locale }
        expect(callbacks).to be_empty
      end
    end
  end

  describe "MethodClassDefaultUrlOptions" do
    before do
      controller_class.use_rails_panda_i18n
    end

    describe ".default_url_options" do
      it "adds ui_language_param_name to options" do
        I18n.locale = :pt
        options = controller_class.default_url_options
        expect(options).to include(hl: :pt)
      end

      it "merges with existing options" do
        I18n.locale = :es
        options = controller_class.default_url_options(foo: :bar)
        expect(options).to include(hl: :es, foo: :bar)
      end

      context "when param support is disabled" do
        let(:controller_class_without_param) do
          Class.new(ApplicationController) do
            include RailsPanda::I18n

            def self.name = "TestControllerWithoutParam"
          end
        end

        before do
          controller_class_without_param.use_rails_panda_i18n(enable_param_support: false)
        end

        it "does not add language param when param support is disabled" do
          options = controller_class_without_param.default_url_options
          # When param support is disabled, URL options modules aren't included,
          # so default_url_options uses Rails' default which returns {}
          expect(options).to eq({})
        end

        it "returns original options when param_name is nil in class method" do
          allow(controller_class).to receive(:ui_language_param_name).and_return(nil)
          options = {foo: :bar}
          result = controller_class.rails_panda__add_ui_language_to(options)
          expect(result).to eq(options)
        end
      end
    end
  end

  describe "MethodInstanceDefaultUrlOptions" do
    let(:controller) { controller_class.new }

    before do
      controller_class.use_rails_panda_i18n
      allow(controller).to receive(:ui_language_param_name).and_return(:hl)
    end

    describe "#default_url_options" do
      it "adds ui_language_param_name to options" do
        I18n.locale = :pt
        options = controller.default_url_options
        expect(options).to include(hl: :pt)
      end

      it "merges with existing options" do
        I18n.locale = :fr
        options = controller.default_url_options(foo: :bar)
        expect(options).to include(hl: :fr, foo: :bar)
      end

      context "when param support is disabled" do
        before do
          controller_class.use_rails_panda_i18n(enable_param_support: false)
        end

        it "returns empty hash when param_name is nil" do
          allow(controller).to receive(:ui_language_param_name).and_return(nil)
          options = controller.default_url_options
          expect(options).to eq({})
        end
      end
    end
  end

  describe "Methods" do
    let(:controller) { controller_class.new }
    let(:cookies) { {} }
    let(:params) { ActionController::Parameters.new({}) }
    let(:request) { instance_double(ActionDispatch::Request, env: {}) }

    before do
      controller_class.use_rails_panda_i18n
      allow(controller).to receive_messages(
        cookies: cookies,
        params: params,
        request: request,
        http_accept_language: double(compatible_language_from: nil) # http_accept_language gem adds this method to ActionController::Base
      )
    end

    describe "#rails_panda__add_ui_language_to" do
      it "adds language param to options" do
        I18n.locale = :pt
        allow(controller).to receive(:ui_language_param_name).and_return(:hl)
        options = controller.rails_panda__add_ui_language_to({})
        expect(options).to include(hl: :pt)
      end

      it "returns original options when param_name is nil" do
        allow(controller).to receive(:ui_language_param_name).and_return(nil)
        options = {foo: :bar}
        result = controller.rails_panda__add_ui_language_to(options)
        expect(result).to eq(options)
      end
    end

    describe "#rails_panda__get_user_locale" do
      before do
        allow(controller).to receive_messages(
          ui_language_cookie_name: :hl,
          ui_language_param_name: :hl
        )
      end

      context "when param language is present and available" do
        let(:params) { ActionController::Parameters.new(hl: "pt") }

        it "returns param language" do
          expect(controller.rails_panda__get_user_locale).to eq(:pt)
        end
      end

      context "when param language is present but not available" do
        let(:params) { ActionController::Parameters.new(hl: "de") }

        it "falls back to cookie language" do
          cookies[:hl] = "es"
          expect(controller.rails_panda__get_user_locale).to eq(:es)
        end
      end

      context "when cookie language is present and available" do
        let(:cookies) { {hl: "es"} }

        it "returns cookie language" do
          expect(controller.rails_panda__get_user_locale).to eq(:es)
        end
      end

      context "when cookie language is present but not available" do
        let(:cookies) { {hl: "de"} }

        it "falls back to HTTP Accept-Language" do
          http_accept_language = instance_double(HttpAcceptLanguage::Parser)
          allow(controller).to receive(:http_accept_language).and_return(http_accept_language)
          allow(http_accept_language).to receive(:compatible_language_from).with([:en, :pt, :es, :fr]).and_return(:fr)
          expect(controller.rails_panda__get_user_locale).to eq(:fr)
        end
      end

      context "when no param or cookie language" do
        it "uses HTTP Accept-Language" do
          http_accept_language = instance_double(HttpAcceptLanguage::Parser)
          allow(controller).to receive(:http_accept_language).and_return(http_accept_language)
          allow(http_accept_language).to receive(:compatible_language_from).with([:en, :pt, :es, :fr]).and_return(:pt)
          expect(controller.rails_panda__get_user_locale).to eq(:pt)
        end

        it "converts HTTP Accept-Language string result to symbol" do
          http_accept_language = instance_double(HttpAcceptLanguage::Parser)
          allow(controller).to receive(:http_accept_language).and_return(http_accept_language)
          allow(http_accept_language).to receive(:compatible_language_from).with([:en, :pt, :es, :fr]).and_return("pt")
          expect(controller.rails_panda__get_user_locale).to eq(:pt)
        end
      end

      context "when cookie support is disabled" do
        before do
          allow(controller).to receive(:ui_language_cookie_name).and_return(nil)
        end

        it "does not check cookies" do
          http_accept_language = instance_double(HttpAcceptLanguage::Parser)
          allow(controller).to receive(:http_accept_language).and_return(http_accept_language)
          allow(http_accept_language).to receive(:compatible_language_from).with([:en, :pt, :es, :fr]).and_return(:en)
          expect(controller.rails_panda__get_user_locale).to eq(:en)
        end
      end

      context "when param support is disabled" do
        before do
          allow(controller).to receive(:ui_language_param_name).and_return(nil)
        end

        it "does not check params" do
          cookies[:hl] = "es"
          expect(controller.rails_panda__get_user_locale).to eq(:es)
        end
      end
    end

    describe "#rails_panda__set_locale" do
      before do
        allow(controller).to receive_messages(
          ui_language_cookie_name: :hl,
          ui_language_param_name: :hl,
          rails_panda__get_user_locale: :pt
        )
      end

      it "sets I18n.locale" do
        controller.rails_panda__set_locale
        expect(I18n.locale).to eq(:pt)
      end

      it "sets cookie when cookie support is enabled" do
        controller.rails_panda__set_locale
        expect(cookies[:hl][:value]).to eq(:pt)
        expect(cookies[:hl][:expires]).to be_within(5.seconds).of(1.year.from_now)
      end

      context "when cookie support is disabled" do
        before do
          allow(controller).to receive(:ui_language_cookie_name).and_return(nil)
        end

        it "does not set cookie" do
          controller.rails_panda__set_locale
          expect(cookies).to be_empty
        end
      end

      context "when no user locale is found" do
        before do
          allow(controller).to receive(:rails_panda__get_user_locale).and_return(nil)
        end

        it "uses default locale" do
          I18n.default_locale = :en
          controller.rails_panda__set_locale
          expect(I18n.locale).to eq(:en)
        end
      end
    end
  end

  describe "integration" do
    let(:controller) { controller_class.new }
    let(:cookies) { {} }
    let(:params) { ActionController::Parameters.new({}) }

    before do
      controller_class.use_rails_panda_i18n
      allow(controller).to receive_messages(
        cookies: cookies,
        params: params,
        request: double(
          env: {},
          headers: double("Accept-Language" => "pt-BR,pt;q=0.9,en-US;q=0.8,en;q=0.7")
        )
      )
    end

    it "sets locale from param when available" do
      params[:hl] = "es"
      controller.rails_panda__set_locale
      expect(I18n.locale).to eq(:es)
      expect(cookies[:hl][:value]).to eq(:es)
    end

    it "sets locale from cookie when param is not available" do
      cookies[:hl] = "fr"
      controller.rails_panda__set_locale
      expect(I18n.locale).to eq(:fr)
    end

    it "sets locale from HTTP Accept-Language when param and cookie are not available" do
      http_accept_language = instance_double(HttpAcceptLanguage::Parser)
      allow(controller).to receive(:http_accept_language).and_return(http_accept_language)
      allow(http_accept_language).to receive(:compatible_language_from).with([:en, :pt, :es, :fr]).and_return(:pt)
      controller.rails_panda__set_locale
      expect(I18n.locale).to eq(:pt)
    end
  end
end
