=begin
    Copyright 2010-2022 Ecsypno <http://www.ecsypno.com>

    This file is part of the Arachni Framework project and is subject to
    redistribution and commercial restrictions. Please see the Arachni Framework
    web site for more information on licensing and terms of use.
=end

module Arachni
module Platform::Fingerprinters

#
# Identifies IIS web servers.
#
# @author Tasos "Zapotek" Laskos <tasos.laskos@arachni-scanner.com>
#
# @version 0.1
#
class IIS < Platform::Fingerprinter

    def run
        platforms << :windows << :iis if server_or_powered_by_include? 'microsoft-iis'
        platforms << :windows << :iis if server_or_powered_by_include? 'microsoft-httpapi'
        platforms << :windows << :iis if !headers['microsoftofficewebserver'].nil?
    end

end

end
end
