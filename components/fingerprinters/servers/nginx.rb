=begin
    Copyright 2010-2022 Ecsypno <http://www.ecsypno.com>

    This file is part of the Arachni Framework project and is subject to
    redistribution and commercial restrictions. Please see the Arachni Framework
    web site for more information on licensing and terms of use.
=end

module Arachni
module Platform::Fingerprinters

#
# Identifies Nginx web servers.
#
# @author Tasos "Zapotek" Laskos <tasos.laskos@arachni-scanner.com>
#
# @version 0.1
#
class Nginx < Platform::Fingerprinter

    def run
        # Example: Server: nginx/1.1.12
        # Example: Server: openresty/1.5.0
        platforms << :nginx if server_or_powered_by_include?( 'nginx' ) or server.include?( 'openresty' )
        # Example: <hr><center>nginx/1.20.1</center>
        # Example: <hr><center>openresty/1.19.9.1</center>
        platforms << :nginx if page.response.body.to_s.include? '<hr><center>nginx' or page.response.body.to_s.include? '<hr><center>openresty'
    end

end

end
end
