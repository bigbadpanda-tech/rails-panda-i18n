module ControllerHelpers
  def setup_controller(controller_class, options = {})
    controller = controller_class.new

    allow(controller).to receive_messages(
      params: ActionController::Parameters.new(options[:params] || {}),
      cookies: options[:cookies] || {},
      request: double(
        env: options[:env] || {},
        headers: double(
          "Accept-Language" => options[:accept_language] || ""
        )
      )
    )

    controller
  end
end

RSpec.configure do |config|
  config.include ControllerHelpers
end
