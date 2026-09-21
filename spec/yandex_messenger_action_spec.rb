describe Fastlane::Actions::YandexMessengerAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The yandex_messenger plugin is working!")

      Fastlane::Actions::YandexMessengerAction.run(nil)
    end
  end
end
