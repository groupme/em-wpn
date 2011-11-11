# Windows Push Notification for EventMachine

Implements Windows Phone 7 push notifications as described on [MSDN](http://msdn.microsoft.com/en-us/library/hh202967.aspx).

## Usage

### Toast

    EM.run do
      toast = EM::WPN::Toast.new("http://live.net...",
        :text1 => "Hello",
        :text2 => "World"
      )
      EM::WPN.push(toast)
    end

### Tile

    EM.run do
      tile = EM::WPN::Tile.new("http://live.net...",
        :background_image => "/image.png",
        :count            => 5,
        :title            => "Hello World"
      )
      EM::WPN.push(tile)
    end
    
    
## TODO

* Raw notifications
* SSL request signing (see [this](http://csainty.blogspot.com/2011/01/wp7-authenticated-push-notifications.html))
* Yield deferrable for handling connection-level problems

## Credits

This is a direct clone of Dave Yeu's [em-apn](https://github.com/groupme/em-apn) gem.
