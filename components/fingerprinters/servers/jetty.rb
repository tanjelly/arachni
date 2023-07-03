=begin
    Copyright 2010-2022 Ecsypno <http://www.ecsypno.com>

    This file is part of the Arachni Framework project and is subject to
    redistribution and commercial restrictions. Please see the Arachni Framework
    web site for more information on licensing and terms of use.
=end

module Arachni
module Platform::Fingerprinters

#
# Identifies Jetty web servers.
#
# @author Tasos "Zapotek" Laskos <tasos.laskos@arachni-scanner.com>
#
# @version 0.1
#
class Jetty < Platform::Fingerprinter

    def run
        platforms << :java << :jetty if server_or_powered_by_include? 'jetty'
        
        # Example: <hr><a href="http://eclipse.org/jetty">Powered by Jetty:// 9.4.31.v20200723</a><hr/>
        platforms << :java << :jetty if page.response.body.to_s.include? '>Powered by Jetty'
    end

end

end
end
