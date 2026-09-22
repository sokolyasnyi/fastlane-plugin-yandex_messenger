# frozen_string_literal: true

require 'fastlane_core/ui/ui'
require 'net/http'
require 'uri'
require 'json'

# Fastlane namespace.
module Fastlane
  UI = FastlaneCore::UI unless Fastlane.const_defined?(:UI)

  module Helper
    # Helper methods for interacting with the Yandex Messenger bot API.
    module YandexMessengerHelper
      class Error < StandardError; end

      ENDPOINT = 'https://botapi.messenger.yandex.net/bot/v1/messages/sendText/'

      module_function

      # rubocop:disable Metrics/MethodLength
      def send_text(token:, text:, chat_id: nil, login: nil, important: false)
        raise Error, 'Provide exactly one of chat_id or login' if [chat_id, login].compact.size != 1

        uri = URI(ENDPOINT)
        opts = { token: token, text: text, chat_id: chat_id, login: login, important: important }
        request = build_request(uri, opts)

        UI.message('Sending message to Yandex Messenger...')

        response = Net::HTTP.start(
          uri.hostname,
          uri.port,
          use_ssl: true,
          open_timeout: 10,
          read_timeout: 30
        ) do |http|
          http.request(request)
        end

        handle_response(response)
      end
      # rubocop:enable Metrics/MethodLength

      def build_request(uri, opts)
        request = Net::HTTP::Post.new(uri)
        request['Authorization'] = "OAuth #{opts[:token]}"
        request['Content-Type'] = 'application/json'

        body = { text: opts[:text], important: opts[:important] }
        body[:chat_id] = opts[:chat_id] if opts[:chat_id]
        body[:login] = opts[:login] if opts[:login]
        request.body = JSON.generate(body)
        request
      end

      def handle_response(response)
        unless response.is_a?(Net::HTTPSuccess)
          UI.error("Yandex Messenger API error: #{response.code} #{response.body}")
          raise Error, "Yandex Messenger API error: #{response.code} #{response.body}"
        end

        UI.success('Message sent successfully!')
        JSON.parse(response.body)
      end
    end
  end
end
