module EventMachine
  module WPN
    module Windows71

      # Toast notifications for Windows Phone OS 7.1 apps.
      #
      # MSDN docs: http://msdn.microsoft.com/en-us/library/windowsphone/develop/jj662938(v=vs.105).aspx
      class Toast < Notification
        def headers
          {
            "X-MessageID"           => uuid,
            "ContentType"           => "text/xml",
            "ContentLength"         => body.size,
            "X-WindowsPhone-Target" => "toast",
            "X-NotificationClass"   => "2" # immediate
          }
        end

        def generate_body
          builder = Nokogiri::XML::Builder.new(:encoding => "utf-8")

          builder.Notification("xmlns:wp" => "WPNotification") do |notification|
            builder.parent.namespace = builder.parent.namespace_definitions.last

            notification.Toast do |toast|
              toast.Text1 properties[:text1] if properties[:text1]
              toast.Text2 properties[:text2] if properties[:text2]

              if properties[:param]
                toast.Param properties[:param]
              elsif params = properties[:params]
                params_string = "?#{params.to_query}"
                params_string = "/#{properties[:xaml]}#{params_string}" if properties[:xaml]

                toast.Param params_string
              end
            end
          end

          builder.to_xml
        end
      end

    end
  end
end
