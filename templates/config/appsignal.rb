if defined?(Appsignal)
  Appsignal.configure do |config|
    %w[HTTP_REFERER HTTP_USER_AGENT HTTP_AUTHORIZATION REQUEST_URI].each do |header|
      config.request_headers << header
    end
    config.revision = ENV.fetch("DEPLOIO_GIT_REVISION")
  end
end
