require 'faraday'

# @private
module Faraday
  # @private
  class Response::RaiseHttp5xx < Response::Middleware
    def on_complete(response)
      case response[:status].to_i
      when 500
        raise Twitter::InternalServerError, error_message(response, "Something is technically wrong.")
      when 502
        raise Twitter::BadGateway, error_message(response, "Twitter is down or being upgraded.")
      when 503
        raise Twitter::ServiceUnavailable, error_message(response, "(__-){ Twitter is over capacity.")
      end
    end

    private

    def error_message(response, body=nil)
      "#{response[:method].to_s.upcase} #{response[:url].to_s}: #{[response[:status].to_s + ':', body].compact.join(' ')} Check http://status.twitter.com/ for updates on the status of the Twitter service."
    end
  end
end
