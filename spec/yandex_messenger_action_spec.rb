# frozen_string_literal: true

require 'spec_helper'

# rubocop:disable Metrics/BlockLength
describe Fastlane::Actions::YandexMessengerAction do
  let(:token) { 'test_oauth_token' }
  let(:text) { 'Build succeeded!' }

  # rubocop:disable Metrics/AbcSize
  def mock_http_response(code, body)
    response = instance_double(Net::HTTPResponse)
    allow(response).to receive(:is_a?).with(Net::HTTPSuccess).and_return(code.to_i < 400)
    allow(response).to receive(:code).and_return(code.to_s)
    allow(response).to receive(:body).and_return(body.to_json)
    response
  end
  # rubocop:enable Metrics/AbcSize

  def stub_http(response)
    http = instance_double(Net::HTTP)
    allow(Net::HTTP).to receive(:start).and_yield(http)
    allow(http).to receive(:request).and_return(response)
  end

  describe '#run' do
    context 'when sending to chat_id' do
      it 'sends the request and returns parsed response' do
        response_body = { 'message_id' => '123' }
        stub_http(mock_http_response(200, response_body))

        result = Fastlane::Actions::YandexMessengerAction.run(
          token: token,
          text: text,
          chat_id: 'chat_abc'
        )

        expect(result).to eq(response_body)
      end
    end

    context 'when sending to login' do
      it 'sends the request successfully' do
        stub_http(mock_http_response(200, { 'message_id' => '456' }))

        expect do
          Fastlane::Actions::YandexMessengerAction.run(
            token: token,
            text: text,
            login: 'john.doe'
          )
        end.not_to raise_error
      end
    end

    context 'when both chat_id and login are provided' do
      it 'raises an error' do
        expect do
          Fastlane::Helper::YandexMessengerHelper.send_text(
            token: token,
            text: text,
            chat_id: 'chat_abc',
            login: 'john.doe'
          )
        end.to raise_error(Fastlane::Helper::YandexMessengerHelper::Error, /exactly one/)
      end
    end

    context 'when neither chat_id nor login is provided' do
      it 'raises an error' do
        expect do
          Fastlane::Helper::YandexMessengerHelper.send_text(
            token: token,
            text: text
          )
        end.to raise_error(Fastlane::Helper::YandexMessengerHelper::Error, /exactly one/)
      end
    end

    context 'when API returns an error' do
      it 'raises an error with status code and body' do
        stub_http(mock_http_response(401, { 'error' => 'Unauthorized' }))

        expect do
          Fastlane::Actions::YandexMessengerAction.run(
            token: 'bad_token',
            text: text,
            chat_id: 'chat_abc'
          )
        end.to raise_error(Fastlane::Helper::YandexMessengerHelper::Error, /401/)
      end
    end

    context 'when important flag is set' do
      it 'passes important: true in request body' do
        response_body = { 'message_id' => '789' }
        http = instance_double(Net::HTTP)
        captured_request = nil

        allow(Net::HTTP).to receive(:start).and_yield(http)
        allow(http).to receive(:request) do |req|
          captured_request = req
          mock_http_response(200, response_body)
        end

        Fastlane::Actions::YandexMessengerAction.run(
          token: token,
          text: text,
          chat_id: 'chat_abc',
          important: true
        )

        body = JSON.parse(captured_request.body)
        expect(body['important']).to be(true)
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
