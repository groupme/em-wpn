# Windows Push Notification for EventMachine

Implements Windows Phone 7 push notifications as described on [MSDN](http://msdn.microsoft.com/en-us/library/hh202967.aspx).

## Usage

Only "Toast" notifications are implemented, but others will follow.

    require "em-wpn"

    EM.run do
      notification = EM::WPN::Toast.new("http://live.net...", :text1 => "Hi")
      EM::APN.push(notification)
    end
    
## Script

You can also use the provided `toast` script for fast testing:

    $ script/toast http://live.net... "hello" "world"
    
## TODO

* Tile notifications
* Raw notifications
* SSL request signing (see [this](http://csainty.blogspot.com/2011/01/wp7-authenticated-push-notifications.html))

## Credits

This is a direct clone of Dave Yeu's [em-apn](https://github.com/groupme/em-apn) gem.
