# Windows Push Notification for EventMachine

Implements Windows Phone 7.1 and 8.0 push notifications as described on [MSDN][1].

## Usage

### Toast

    EM.run do
      toast = EM::WPN::Windows71::Toast.new("http://live.net...",
        :text1 => "Hello",
        :text2 => "World"
      )
      response = EM::WPN.push(toast)
    end

### Tile

    EM.run do
      tile = EM::WPN::Windows71::Tile.new("http://live.net...",
        :background_image => "/image.png",
        :count            => 5,
        :title            => "Hello World"
      )
      response = EM::WPN.push(tile)
    end

Windows Phone 8 tiles are available in additional classes:
- `EM::WPN::Windows8::IconicTile`
- `EM::WPN::Windows8::FlipTile`

### Responses

Responses are implemented as EM deferrables. Callbacks are invoked whenever a
tile or toast is successfully delivered:

    response = EM::WPN.push(toast)
    response.callback do |response|
      response.status      # => 200
      response.duration    # => ms
      response.http        # => EM::HttpClient
    end

Errbacks are invoked for any non-200 response as well as network errors:

    response = EM::WPN.push(tile)
    response.errback do |response|
      response.status      # => e.g. 404 (nil for connection errors)
      response.error       # => Notification status or connection error
    end

## TODO

* Raw notifications
* SSL request signing (see [this](http://csainty.blogspot.com/2011/01/wp7-authenticated-push-notifications.html))

## Credits

This is a direct clone of Dave Yeu's [em-apn](https://github.com/groupme/em-apn) gem.

[1]: http://msdn.microsoft.com/en-us/library/windowsphone/develop/hh202945(v=vs.105).aspx
