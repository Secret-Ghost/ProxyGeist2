require 'rubygems'
require 'net/ping'
require 'socksify/http'
require 'nokogiri'
require 'colorize'



#use like:   ruby scanner.rb 8 proxylist.txt 
 

$timeout = ARGV[0].to_i
file= ARGV[1].to_s 

threads = []
out_file = File.new('out.txt', "w")
 
 

 

def icanhazconnect?(proxy)
  host, port = proxy.split(':')
  return Net::Ping::TCP.new(host, port, $timeout).ping
end


puts'                      :::!~!!!!!:.'
puts'                  .xUHWH!! !!?M88WHX:.'
puts'                .X*#M@$!!  !X!M$$$$$$WWx:.'
puts'               :!!!!!!?H! :!$!$$$$$$$$$$8X:'
puts'              !!~  ~:~!! :~!$!#$$$$$$$$$$8X:'
puts'             :!~::!H!<   ~.U$X!?R$$$$$$$$MM!'
puts'             ~!~!!!!~~ .:XW$$$U!!?$$$$$$RMM!'
puts'               !:~~~ .:!M"T#$$$$WX??#MRRMMM!'
puts'               ~?WuxiW*`   `"#$$$$8!!!!??!!!'
puts'             :X- M$$$$       `"T#$T~!8$WUXU~'
puts'            :%`  ~#$$$m:        ~!~ ?$$$$$$'
puts'          :!`.-   ~T$$$$8xx.  .xWW- ~""##*"'
puts'.....   -~~:<` !    ~?T#$$@@W@*?$$      /`'
puts'W$@@M!!! .!~~ !!     .:XUW$W!~ `"~:    :'
puts'#"~~`.:x%`!!  !H:   !WM$$$$Ti.: .!WUn+!`'
puts':::~:!!`:X~ .: ?H.!u "$$$B$$$!W:U!T$$M~'
puts'.~~   :X@!.-~   ?@WTWo("*$$$W$TH$! `'
puts'Wi.~!X$?!-~    : ?$$$B$Wu("**$RM!'
puts'$R@i.~~ !     :   ~$$$$$B$$en:``'
puts'?MXT@Wx.~    :     ~"##*$$$$M~'
puts'Proxygeist by: Ghost @ vaughlive.tv'
puts 'Please wait, harvesting...'








File.readlines(file).each do |item|

     sleep 0.1
    threads << Thread.new do
     
      if icanhazconnect?(item.strip)
         
         proxy_addr, proxy_port = item.strip.split(':')
  
         begin

           http = Net::HTTP::SOCKSProxy(proxy_addr, proxy_port)
           html = http.get(URI('https://packetstormsecurity.com/'))
           html_doc = Nokogiri::HTML(html).to_s


           if html_doc.include? "Register"
               puts 'Good: '.green + item.to_s.green
               proxy = /[0-9]+(?:\.[0-9]+){3}:[0-9]+/.match(item)
               out_file.puts( proxy)
           else
               puts 'Bad: ' + item.to_s.red
           end

         rescue
           puts 'Bad: ' + item.to_s.red
         end

      end

    end

end



 
threads.map(&:join)


out_file.close
puts 'Harvesting Finished. Have a nice day :)'

