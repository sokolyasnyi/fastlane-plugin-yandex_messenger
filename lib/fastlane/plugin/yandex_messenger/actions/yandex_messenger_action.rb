require 'fastlane/action'
require_relative '../helper/yandex_messenger_helper'

module Fastlane
  module Actions
    class YandexMessengerAction < Action
      def self.run(params)
        Helper::YandexMessengerHelper.send_text(
          token: params[:token],
          text: params[:text],
          chat_id: params[:chat_id],
          login: params[:login],
          important: params[:important]
        )
      end

      def self.description
        "Allows post messages to Yandex Messenger channel"
      end

      def self.authors
        ["Stanislav Sokolov"]
      end

      def self.return_value
        "Parsed JSON response from Yandex Messenger API"
      end

      def self.details
        'Sends text messages to Yandex Messenger via the bot API. ' \
        'Provide either chat_id (for group chats) or login (for direct messages), but not both.'
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(
            key: :token,
            env_name: 'YANDEX_MESSENGER_TOKEN',
            description: 'OAuth token for Yandex Messenger bot',
            sensitive: true,
            type: String,
            optional: false
          ),
          FastlaneCore::ConfigItem.new(
            key: :text,
            env_name: 'YANDEX_MESSENGER_TEXT',
            description: 'Message text',
            type: String,
            optional: false
          ),
          FastlaneCore::ConfigItem.new(
            key: :chat_id,
            env_name: 'YANDEX_MESSENGER_CHAT_ID',
            description: 'Chat ID (mutually exclusive with login)',
            type: String,
            optional: true,
            verify_block: proc do |value|
              UI.user_error!("chat_id cannot be blank") if value.to_s.strip.empty?
            end
          ),
          FastlaneCore::ConfigItem.new(
            key: :login,
            env_name: 'YANDEX_MESSENGER_LOGIN',
            description: 'User login for direct messages (mutually exclusive with chat_id)',
            type: String,
            optional: true,
            verify_block: proc do |value|
              UI.user_error!("login cannot be blank") if value.to_s.strip.empty?
            end
          ),
          FastlaneCore::ConfigItem.new(
            key: :important,
            env_name: 'YANDEX_MESSENGER_IMPORTANT',
            description: 'Mark message as important',
            type: FastlaneCore::Boolean,
            optional: true,
            default_value: false
          )
        ]
      end

      def self.is_supported?(platform)
        true
      end
    end
  end
end
