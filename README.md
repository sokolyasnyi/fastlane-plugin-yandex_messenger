# yandex_messenger plugin

[![fastlane Plugin Badge](https://rawcdn.githack.com/fastlane/fastlane/master/fastlane/assets/plugin-badge.svg)](https://rubygems.org/gems/fastlane-plugin-yandex_messenger)

## Getting Started

This project is a [_fastlane_](https://github.com/fastlane/fastlane) plugin. To get started with `fastlane-plugin-yandex_messenger`, add it to your project by running:

```bash
fastlane add_plugin yandex_messenger
```

## About yandex_messenger

Allows post messages to Yandex Messenger channel

```ruby
yandex_messenger(
  token: ENV['YANDEX_MESSENGER_TOKEN'], # OAuth token for your bot
  chat_id: ENV['YANDEX_MESSENGER_CHAT_ID'], # Chat ID (mutually exclusive with login)
  # login: 'john.doe', # User login for direct messages (mutually exclusive with chat_id)
  text: "Hello world, Yandex Messenger!", # Required
  important: false # Optional. Mark message as important. Default: false
)
```

## Example

Check out the [example `Fastfile`](fastlane/Fastfile) to see how to use this plugin. Try it by cloning the repo, running `fastlane install_plugins` and `bundle exec fastlane test`.

## Run tests for this plugin

To run both the tests, and code style validation, run

```
rake
```

To automatically fix many of the styling issues, use
```
rubocop -a
```

## Issues and Feedback

For any other issues and feedback about this plugin, please submit it to this repository.

## Troubleshooting

If you have trouble using plugins, check out the [Plugins Troubleshooting](https://docs.fastlane.tools/plugins/plugins-troubleshooting/) guide.

## Using _fastlane_ Plugins

For more information about how the `fastlane` plugin system works, check out the [Plugins documentation](https://docs.fastlane.tools/plugins/create-plugin/).

## About _fastlane_

_fastlane_ is the easiest way to automate beta deployments and releases for your iOS and Android apps. To learn more, check out [fastlane.tools](https://fastlane.tools).
