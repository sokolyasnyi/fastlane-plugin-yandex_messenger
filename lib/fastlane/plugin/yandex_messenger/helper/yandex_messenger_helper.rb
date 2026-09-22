require 'fastlane_core/ui/ui'
require 'net/http'
require 'uri'
require 'json'

module Fastlane
  UI = FastlaneCore::UI unless Fastlane.const_defined?(:UI)

  module Helper
    module YandexMessengerHelper
      class Error < StandardError; end

      ENDPOINT = 'https://botapi.messenger.yandex.net/bot/v1/messages/sendText/'.freeze

      module_function

      def send_text(token:, text:, chat_id: nil, login: nil, important: false)
        raise Error, 'Provide exactly one of chat_id or login' if [chat_id, login].compact.size != 1

        uri = URI(ENDPOINT)
        request = Net::HTTP::Post.new(uri)
        request['Authorization'] = "OAuth #{token}"
        request['Content-Type'] = 'application/json'

        body = { text: text, important: important }
        body[:chat_id] = chat_id if chat_id
        body[:login] = login if login
        request.body = JSON.generate(body)

        UI.message("Sending message to Yandex Messenger...")

        response = Net::HTTP.start(
          uri.hostname,
          uri.port,
          use_ssl: true,
          open_timeout: 10,
          read_timeout: 30
        ) do |http|
          http.request(request)
        end

        unless response.is_a?(Net::HTTPSuccess)
          UI.error("Yandex Messenger API error: #{response.code} #{response.body}")
          raise Error, "Yandex Messenger API error: #{response.code} #{response.body}"
        end

        UI.success("Message sent successfully!")
        JSON.parse(response.body)
      end
    end
  end
end
