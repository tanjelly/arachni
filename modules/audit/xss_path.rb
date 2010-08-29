=begin
  $Id: xss.rb 371 2010-08-18 10:18:09Z zapotek $

                  Arachni
  Copyright (c) 2010 Anastasios Laskos <tasos.laskos@gmail.com>

  This is free software; you can copy and distribute and modify
  this program under the term of the GPL v2.0 License
  (See LICENSE file for details)

=end

module Arachni

module Modules
module Audit

#
# XSS in path audit module.
#
# @author: Anastasios "Zapotek" Laskos
#                                      <tasos.laskos@gmail.com>
#                                      <zapotek@segfault.gr>
# @version: $Rev: 371 $
#
# @see http://cwe.mitre.org/data/definitions/79.html    
# @see http://ha.ckers.org/xss.html
# @see http://secunia.com/advisories/9716/
#
class XSSPath < Arachni::Module::Base

    include Arachni::Module::Registrar
    include Arachni::UI::Output

    def initialize( page )
        super( page )

        @results    = []
    end
    
    def prepare( )
        @__injection_strs = [
            '<ScRIPT>a=/RANDOMIZE/<ScRipT>',
            '?>"\'><ScRIPT>a=/RANDOMIZE/<ScRipT>',
            '?=>"\'><ScRIPT>a=/RANDOMIZE/<ScRipT>'
        ]
    end

    def run( )

        # ugly crap but it works, as far as I can tell...
        path = __get_path( @page.url )
        
        @__injection_strs.each {
            |str|
            
            url  = path + str
            res  = @http.get( url )

            __log_results( res, str, url )
        }

        
        # register our results with the system
        register_results( @results )
    end

    
    def self.info
        {
            'Name'           => 'XSSPath',
            'Description'    => %q{Cross-Site Scripting module for path injection},
            'Elements'       => [ ],
            'Author'         => 'zapotek',
            'Version'        => '$Rev: 371 $',
            'References'     => {
                'ha.ckers' => 'http://ha.ckers.org/xss.html',
                'Secunia'  => 'http://secunia.com/advisories/9716/'
            },
            'Targets'        => { 'Generic' => 'all' },
                
            'Vulnerability'   => {
                'Name'        => %q{Cross-Site Scripting (XSS) in path},
                'Description' => %q{Client-side code, like JavaScript, can
                    be injected into the web application.},
                'CWE'         => '79',
                'Severity'    => Vulnerability::Severity::HIGH,
                'CVSSV2'       => '9.0',
                'Remedy_Guidance'    => '',
                'Remedy_Code' => '',
            }

        }
    end
    
    def __get_path( url )
      
        splits = []
        tmp = ''
        
        url.each_char {
            |c|
            if( c != '/' )
                tmp += c
            else
                splits << tmp
                tmp = ''
            end
        }
        
        if( !tmp =~ /\./ )
          splits << tmp
        end
        
        return splits.join( "/" ) + '/'
    end

    def __log_results( res, id, url )
        
        if ( id && res.body.scan( Regexp.escape( id ) )[0] == id ) ||
           ( !id && res.body.scan( Regexp.escape( id ) )[0].size > 0 )

        
            # append the result to the results hash
            @results << Vulnerability.new( {
                'var'          => 'n/a',
                'url'          => url,
                'injected'     => filename,
                'id'           => filename,
                'regexp'       => 'n/a',
                'regexp_match' => 'n/a',
                'elem'         => Vulnerability::Element::LINK,
                'response'     => res.body,
                'headers'      => {
                    'request'    => 'n/a',
                    'response'   => 'n/a',    
                }
            }.merge( self.class.info ) )
                    
            # inform the user that we have a match
            print_ok( self.class.info['Name'] +
                " named #{filename} at\t" + url )
                
        end
    end


end
end
end
end