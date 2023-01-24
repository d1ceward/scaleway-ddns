crystal_doc_search_index_callback({"repository_name":"scaleway-ddns","body":"# scaleway-ddns (v1.2.6)\n![GitHub Workflow Status (main)](https://github.com/d1ceward/scaleway-ddns/actions/workflows/main.yml/badge.svg?branch=master)\n[![Docker Pulls](https://img.shields.io/docker/pulls/d1ceward/scaleway-ddns.svg)](https://hub.docker.com/r/d1ceward/scaleway-ddns)\n[![GitHub issues](https://img.shields.io/github/issues/d1ceward/scaleway-ddns)](https://github.com/d1ceward/scaleway-ddns/issues)\n[![GitHub license](https://img.shields.io/github/license/d1ceward/scaleway-ddns)](https://github.com/d1ceward/scaleway-ddns/blob/master/LICENSE)\n\nSimple Scaleway dynamic DNS service by API written in Crystal.\n\n:rocket: Suggestions for new improvements are welcome in the issue tracker.\n\n## Installation and Usage\n\n### Docker\n\nWith `docker run` command :\n```shell\ndocker run -d \\\n  -e SCW_SECRET_KEY=\"super-secret-from-scaleway\" \\\n  -e IDLE_MINUTES=\"10\" \\\n  -e DOMAIN_LIST=\"myfirstdomain.com,anotherone.com\" \\\n  d1ceward/scaleway-ddns:latest\n```\n\nWith docker-compose file :\n```yaml\n---\nversion: \"3\"\n\nservices:\n  scaleway_ddns:\n    image: d1ceward/scaleway-ddns:latest\n    restart: unless-stopped\n    environment:\n      - SCW_SECRET_KEY=super-secret-from-scaleway\n      - IDLE_MINUTES=10\n      - DOMAIN_LIST=myfirstdomain.com,anotherone.com\n```\n\n### Linux\n\nDownload the executable file :\n```shell\nwget --no-verbose -O scaleway-ddns https://github.com/d1ceward/scaleway-ddns/releases/download/v1.2.6/scaleway-ddns-linux-amd64\n```\n\nModify the executable's permissions :\n```shell\nchmod +x scaleway-ddns\n```\n\nExecution example :\n```shell\nscaleway-ddns run\n```\n\nDocumentation available here : https://d1ceward.github.io/scaleway-ddns/\n\n## Contributing\n\nBug reports and pull requests are welcome on GitHub at https://github.com/d1ceward/scaleway-ddns. By contributing you agree to abide by the Code of Merit.\n\n1. Fork it (<https://github.com/d1ceward/scaleway-ddns/fork>)\n2. Create your feature branch (`git checkout -b my-new-feature`)\n3. Commit your changes (`git commit -am 'Add some feature'`)\n4. Push to the branch (`git push origin my-new-feature`)\n5. Create a new Pull Request\n\n## Development building and running\n\n1. Install corresponding version of Crystal lang (cf: `.crystal-version` file)\n2. Install Crystal dependencies with `shards install`\n3. Build with `shards build`\n\nThe newly created binary should be at `bin/scaleway-ddns`\n\n### Running tests\n\n```shell\ncrystal spec\n```\n\n## Contributors\n\n- [d1ceward](https://github.com/d1ceward) - creator and maintainer\n","program":{"html_id":"scaleway-ddns/toplevel","path":"toplevel.html","kind":"module","full_name":"Top Level Namespace","name":"Top Level Namespace","abstract":false,"locations":[],"repository_name":"scaleway-ddns","program":true,"enum":false,"alias":false,"const":false,"types":[{"html_id":"scaleway-ddns/ScalewayDDNS","path":"ScalewayDDNS.html","kind":"module","full_name":"ScalewayDDNS","name":"ScalewayDDNS","abstract":false,"locations":[{"filename":"src/scaleway_ddns/cli.cr","line_number":1,"url":null},{"filename":"src/scaleway_ddns/config.cr","line_number":1,"url":null},{"filename":"src/scaleway_ddns/errors.cr","line_number":1,"url":null},{"filename":"src/scaleway_ddns/ip.cr","line_number":1,"url":null},{"filename":"src/scaleway_ddns/request.cr","line_number":1,"url":null},{"filename":"src/scaleway_ddns/updater.cr","line_number":1,"url":null},{"filename":"src/version.cr","line_number":1,"url":null}],"repository_name":"scaleway-ddns","program":false,"enum":false,"alias":false,"const":false,"constants":[{"id":"VERSION","name":"VERSION","value":"\"1.2.6\""}],"types":[{"html_id":"scaleway-ddns/ScalewayDDNS/CLI","path":"ScalewayDDNS/CLI.html","kind":"class","full_name":"ScalewayDDNS::CLI","name":"CLI","abstract":false,"superclass":{"html_id":"scaleway-ddns/Reference","kind":"class","full_name":"Reference","name":"Reference"},"ancestors":[{"html_id":"scaleway-ddns/Reference","kind":"class","full_name":"Reference","name":"Reference"},{"html_id":"scaleway-ddns/Object","kind":"class","full_name":"Object","name":"Object"}],"locations":[{"filename":"src/scaleway_ddns/cli.cr","line_number":2,"url":null}],"repository_name":"scaleway-ddns","program":false,"enum":false,"alias":false,"const":false,"namespace":{"html_id":"scaleway-ddns/ScalewayDDNS","kind":"module","full_name":"ScalewayDDNS","name":"ScalewayDDNS"},"constructors":[{"html_id":"new-class-method","name":"new","abstract":false,"location":{"filename":"src/scaleway_ddns/cli.cr","line_number":6,"url":null},"def":{"name":"new","visibility":"Public","body":"_ = allocate\n_.initialize\nif _.responds_to?(:finalize)\n  ::GC.add_finalizer(_)\nend\n_\n"}}],"instance_methods":[{"html_id":"config:Config-instance-method","name":"config","abstract":false,"location":{"filename":"src/scaleway_ddns/cli.cr","line_number":3,"url":null},"def":{"name":"config","return_type":"Config","visibility":"Public","body":"@config"}},{"html_id":"config=(config:Config)-instance-method","name":"config=","abstract":false,"args":[{"name":"config","external_name":"config","restriction":"Config"}],"args_string":"(config : Config)","args_html":"(config : <a href=\"../ScalewayDDNS/Config.html\">Config</a>)","location":{"filename":"src/scaleway_ddns/cli.cr","line_number":3,"url":null},"def":{"name":"config=","args":[{"name":"config","external_name":"config","restriction":"Config"}],"visibility":"Public","body":"@config = config"}},{"html_id":"run_server:Bool-instance-method","name":"run_server","abstract":false,"location":{"filename":"src/scaleway_ddns/cli.cr","line_number":4,"url":null},"def":{"name":"run_server","return_type":"Bool","visibility":"Public","body":"@run_server"}},{"html_id":"run_server=(run_server:Bool)-instance-method","name":"run_server=","abstract":false,"args":[{"name":"run_server","external_name":"run_server","restriction":"Bool"}],"args_string":"(run_server : Bool)","args_html":"(run_server : Bool)","location":{"filename":"src/scaleway_ddns/cli.cr","line_number":4,"url":null},"def":{"name":"run_server=","args":[{"name":"run_server","external_name":"run_server","restriction":"Bool"}],"visibility":"Public","body":"@run_server = run_server"}}]},{"html_id":"scaleway-ddns/ScalewayDDNS/Config","path":"ScalewayDDNS/Config.html","kind":"class","full_name":"ScalewayDDNS::Config","name":"Config","abstract":false,"superclass":{"html_id":"scaleway-ddns/Reference","kind":"class","full_name":"Reference","name":"Reference"},"ancestors":[{"html_id":"scaleway-ddns/Reference","kind":"class","full_name":"Reference","name":"Reference"},{"html_id":"scaleway-ddns/Object","kind":"class","full_name":"Object","name":"Object"}],"locations":[{"filename":"src/scaleway_ddns/config.cr","line_number":10,"url":null}],"repository_name":"scaleway-ddns","program":false,"enum":false,"alias":false,"const":false,"namespace":{"html_id":"scaleway-ddns/ScalewayDDNS","kind":"module","full_name":"ScalewayDDNS","name":"ScalewayDDNS"},"doc":"A configuration entry for the pogram.\n\nConfig can be loaded from environment variables and adjusted.\n\n```\nconfig = ScalewayDDNS::Config.new\nconfig.idle_minutes = my_idle_minutes\n```","summary":"<p>A configuration entry for the pogram.</p>","constructors":[{"html_id":"new-class-method","name":"new","doc":"Creates a new instance of `ScalewayDDNS::Config` based on environment variables.","summary":"<p>Creates a new instance of <code><a href=\"../ScalewayDDNS/Config.html\">ScalewayDDNS::Config</a></code> based on environment variables.</p>","abstract":false,"location":{"filename":"src/scaleway_ddns/config.cr","line_number":26,"url":null},"def":{"name":"new","visibility":"Public","body":"_ = allocate\n_.initialize\nif _.responds_to?(:finalize)\n  ::GC.add_finalizer(_)\nend\n_\n"}}],"instance_methods":[{"html_id":"domain_list:Array(String)-instance-method","name":"domain_list","doc":"Represents a list of domains whose address record needs to be updated.\n\n```\nconfig = ScalewayDDNS::Config.new\nconfig.domain_list = [\"example.com\", \"another.com\"]\n```","summary":"<p>Represents a list of domains whose address record needs to be updated.</p>","abstract":false,"location":{"filename":"src/scaleway_ddns/config.cr","line_number":23,"url":null},"def":{"name":"domain_list","return_type":"Array(String)","visibility":"Public","body":"@domain_list"}},{"html_id":"domain_list=(domain_list:Array(String))-instance-method","name":"domain_list=","doc":"Represents a list of domains whose address record needs to be updated.\n\n```\nconfig = ScalewayDDNS::Config.new\nconfig.domain_list = [\"example.com\", \"another.com\"]\n```","summary":"<p>Represents a list of domains whose address record needs to be updated.</p>","abstract":false,"args":[{"name":"domain_list","external_name":"domain_list","restriction":"Array(String)"}],"args_string":"(domain_list : Array(String))","args_html":"(domain_list : Array(String))","location":{"filename":"src/scaleway_ddns/config.cr","line_number":23,"url":null},"def":{"name":"domain_list=","args":[{"name":"domain_list","external_name":"domain_list","restriction":"Array(String)"}],"visibility":"Public","body":"@domain_list = domain_list"}},{"html_id":"idle_minutes:Int32-instance-method","name":"idle_minutes","doc":"Number of minutes of inactivity between IP checks.","summary":"<p>Number of minutes of inactivity between IP checks.</p>","abstract":false,"location":{"filename":"src/scaleway_ddns/config.cr","line_number":15,"url":null},"def":{"name":"idle_minutes","return_type":"Int32","visibility":"Public","body":"@idle_minutes"}},{"html_id":"idle_minutes=(idle_minutes:Int32)-instance-method","name":"idle_minutes=","doc":"Number of minutes of inactivity between IP checks.","summary":"<p>Number of minutes of inactivity between IP checks.</p>","abstract":false,"args":[{"name":"idle_minutes","external_name":"idle_minutes","restriction":"Int32"}],"args_string":"(idle_minutes : Int32)","args_html":"(idle_minutes : Int32)","location":{"filename":"src/scaleway_ddns/config.cr","line_number":15,"url":null},"def":{"name":"idle_minutes=","args":[{"name":"idle_minutes","external_name":"idle_minutes","restriction":"Int32"}],"visibility":"Public","body":"@idle_minutes = idle_minutes"}},{"html_id":"scw_secret_key:String-instance-method","name":"scw_secret_key","doc":"Secret key from Scaleway required for IP update.","summary":"<p>Secret key from Scaleway required for IP update.</p>","abstract":false,"location":{"filename":"src/scaleway_ddns/config.cr","line_number":12,"url":null},"def":{"name":"scw_secret_key","return_type":"String","visibility":"Public","body":"@scw_secret_key"}},{"html_id":"scw_secret_key=(scw_secret_key:String)-instance-method","name":"scw_secret_key=","doc":"Secret key from Scaleway required for IP update.","summary":"<p>Secret key from Scaleway required for IP update.</p>","abstract":false,"args":[{"name":"scw_secret_key","external_name":"scw_secret_key","restriction":"String"}],"args_string":"(scw_secret_key : String)","args_html":"(scw_secret_key : String)","location":{"filename":"src/scaleway_ddns/config.cr","line_number":12,"url":null},"def":{"name":"scw_secret_key=","args":[{"name":"scw_secret_key","external_name":"scw_secret_key","restriction":"String"}],"visibility":"Public","body":"@scw_secret_key = scw_secret_key"}}]},{"html_id":"scaleway-ddns/ScalewayDDNS/GlobalError","path":"ScalewayDDNS/GlobalError.html","kind":"class","full_name":"ScalewayDDNS::GlobalError","name":"GlobalError","abstract":false,"superclass":{"html_id":"scaleway-ddns/Exception","kind":"class","full_name":"Exception","name":"Exception"},"ancestors":[{"html_id":"scaleway-ddns/Exception","kind":"class","full_name":"Exception","name":"Exception"},{"html_id":"scaleway-ddns/Reference","kind":"class","full_name":"Reference","name":"Reference"},{"html_id":"scaleway-ddns/Object","kind":"class","full_name":"Object","name":"Object"}],"locations":[{"filename":"src/scaleway_ddns/errors.cr","line_number":2,"url":null}],"repository_name":"scaleway-ddns","program":false,"enum":false,"alias":false,"const":false,"namespace":{"html_id":"scaleway-ddns/ScalewayDDNS","kind":"module","full_name":"ScalewayDDNS","name":"ScalewayDDNS"}},{"html_id":"scaleway-ddns/ScalewayDDNS/IP","path":"ScalewayDDNS/IP.html","kind":"class","full_name":"ScalewayDDNS::IP","name":"IP","abstract":false,"superclass":{"html_id":"scaleway-ddns/Reference","kind":"class","full_name":"Reference","name":"Reference"},"ancestors":[{"html_id":"scaleway-ddns/Reference","kind":"class","full_name":"Reference","name":"Reference"},{"html_id":"scaleway-ddns/Object","kind":"class","full_name":"Object","name":"Object"}],"locations":[{"filename":"src/scaleway_ddns/ip.cr","line_number":2,"url":null}],"repository_name":"scaleway-ddns","program":false,"enum":false,"alias":false,"const":false,"constants":[{"id":"IP_API_HOST","name":"IP_API_HOST","value":"\"api.ipify.org\""}],"namespace":{"html_id":"scaleway-ddns/ScalewayDDNS","kind":"module","full_name":"ScalewayDDNS","name":"ScalewayDDNS"},"class_methods":[{"html_id":"current_ip:String-class-method","name":"current_ip","doc":"Return current IP address from external API as string.\n\n```\nScalewayDDNS::IP.current_ip # => \"127.0.0.1\"\n\n# External API give an invalid response\nScalewayDDNS::IP.current_ip # => IPError: IP API: Invalid IP from external.api.com\n```","summary":"<p>Return current IP address from external API as string.</p>","abstract":false,"location":{"filename":"src/scaleway_ddns/ip.cr","line_number":13,"url":null},"def":{"name":"current_ip","return_type":"String","visibility":"Public","body":"begin\n  Log.info do\n    \"IP API: Getting current IP...\"\n  end\n  ip_string = \"\"\n  elapsed_time = Time.measure do\n    ip_string = (parse_response(execute_request)).to_s\n  end\n  ip_address = Socket::IPAddress.new(ip_string, 0)\n  Log.info do\n    \"IP API: Current IP is #{ip_address.address} and took #{elapsed_time.total_seconds}s\"\n  end\n  ip_address.address\nrescue Socket::Error\n  raise(IPError.new(\"IP API: Invalid IP from #{IP_API_HOST}\"))\nend"}}]},{"html_id":"scaleway-ddns/ScalewayDDNS/IPError","path":"ScalewayDDNS/IPError.html","kind":"class","full_name":"ScalewayDDNS::IPError","name":"IPError","abstract":false,"superclass":{"html_id":"scaleway-ddns/Exception","kind":"class","full_name":"Exception","name":"Exception"},"ancestors":[{"html_id":"scaleway-ddns/Exception","kind":"class","full_name":"Exception","name":"Exception"},{"html_id":"scaleway-ddns/Reference","kind":"class","full_name":"Reference","name":"Reference"},{"html_id":"scaleway-ddns/Object","kind":"class","full_name":"Object","name":"Object"}],"locations":[{"filename":"src/scaleway_ddns/errors.cr","line_number":3,"url":null}],"repository_name":"scaleway-ddns","program":false,"enum":false,"alias":false,"const":false,"namespace":{"html_id":"scaleway-ddns/ScalewayDDNS","kind":"module","full_name":"ScalewayDDNS","name":"ScalewayDDNS"}},{"html_id":"scaleway-ddns/ScalewayDDNS/Request","path":"ScalewayDDNS/Request.html","kind":"class","full_name":"ScalewayDDNS::Request","name":"Request","abstract":false,"superclass":{"html_id":"scaleway-ddns/Reference","kind":"class","full_name":"Reference","name":"Reference"},"ancestors":[{"html_id":"scaleway-ddns/Reference","kind":"class","full_name":"Reference","name":"Reference"},{"html_id":"scaleway-ddns/Object","kind":"class","full_name":"Object","name":"Object"}],"locations":[{"filename":"src/scaleway_ddns/request.cr","line_number":2,"url":null}],"repository_name":"scaleway-ddns","program":false,"enum":false,"alias":false,"const":false,"constants":[{"id":"SCW_API_HOST","name":"SCW_API_HOST","value":"\"api.scaleway.com\""}],"namespace":{"html_id":"scaleway-ddns/ScalewayDDNS","kind":"module","full_name":"ScalewayDDNS","name":"ScalewayDDNS"},"constructors":[{"html_id":"new(scw_secret_key:String)-class-method","name":"new","doc":"Creates a new instance of `ScalewayDDNS::Request` with given Scaleway secret key.","summary":"<p>Creates a new instance of <code><a href=\"../ScalewayDDNS/Request.html\">ScalewayDDNS::Request</a></code> with given Scaleway secret key.</p>","abstract":false,"args":[{"name":"scw_secret_key","external_name":"scw_secret_key","restriction":"String"}],"args_string":"(scw_secret_key : String)","args_html":"(scw_secret_key : String)","location":{"filename":"src/scaleway_ddns/request.cr","line_number":6,"url":null},"def":{"name":"new","args":[{"name":"scw_secret_key","external_name":"scw_secret_key","restriction":"String"}],"visibility":"Public","body":"_ = allocate\n_.initialize(scw_secret_key)\nif _.responds_to?(:finalize)\n  ::GC.add_finalizer(_)\nend\n_\n"}}],"instance_methods":[{"html_id":"address_record_list(domain:String):Array(Hash(Symbol,String|Int32))-instance-method","name":"address_record_list","doc":"Get a list of A (address) record from the Scaleway API for a given domain.\n\n```\nScalewayDDNS::Request.address_record_list(\"example.com\")\n# => [{ :id => 1, :name => \"\" :ttl => 60 }, { :id => 2, :name => \"mail\" :ttl => 120 }]\n\nScalewayDDNS::Request.address_record_list(\"invalid.com\")\n# => Scaleway API: Unauthorized, please check configuration variables.\n```","summary":"<p>Get a list of A (address) record from the Scaleway API for a given domain.</p>","abstract":false,"args":[{"name":"domain","external_name":"domain","restriction":"String"}],"args_string":"(domain : String) : Array(Hash(Symbol, String | Int32))","args_html":"(domain : String) : Array(Hash(Symbol, String | Int32))","location":{"filename":"src/scaleway_ddns/request.cr","line_number":17,"url":null},"def":{"name":"address_record_list","args":[{"name":"domain","external_name":"domain","restriction":"String"}],"return_type":"Array(Hash(Symbol, String | Int32))","visibility":"Public","body":"Log.info do\n  \"Scaleway API: Getting A record for #{domain}\"\nend\nresponse = execute_request(\"GET\", \"/domain/v2beta1/dns-zones/#{domain}/records?type=A\")\nrecords = (parse_response(response))[\"records\"]?.try(&.as_a?) || ([] of Hash(String, JSON::Any))\nrecords.map do |record|\n  {:id => record[\"id\"]?.to_s, :data => record[\"data\"]?.to_s, :name => record[\"name\"]?.to_s, :ttl => record[\"ttl\"]?.try(&.as_i) || 60}\nend\n"}},{"html_id":"update_address_record(domain:String,ip:String,record:Hash(Symbol,String|Int32))-instance-method","name":"update_address_record","abstract":false,"args":[{"name":"domain","external_name":"domain","restriction":"String"},{"name":"ip","external_name":"ip","restriction":"String"},{"name":"record","external_name":"record","restriction":"Hash(Symbol, String | Int32)"}],"args_string":"(domain : String, ip : String, record : Hash(Symbol, String | Int32))","args_html":"(domain : String, ip : String, record : Hash(Symbol, String | Int32))","location":{"filename":"src/scaleway_ddns/request.cr","line_number":33,"url":null},"def":{"name":"update_address_record","args":[{"name":"domain","external_name":"domain","restriction":"String"},{"name":"ip","external_name":"ip","restriction":"String"},{"name":"record","external_name":"record","restriction":"Hash(Symbol, String | Int32)"}],"visibility":"Public","body":"Log.info do\n  \"Scaleway API: Updating A record for #{domain}\"\nend\nbody_string = {changes: [{set: {id: \"#{record[:id]}\", records: [{data: \"#{ip}\", name: \"#{record[:name]}\", ttl: \"#{record[:ttl]}\", type: \"A\"}]}}]}.to_json\nparse_response(execute_request(\"PATCH\", \"/domain/v2beta1/dns-zones/#{domain}/records\", body_string))\n"}}]},{"html_id":"scaleway-ddns/ScalewayDDNS/RequestError","path":"ScalewayDDNS/RequestError.html","kind":"class","full_name":"ScalewayDDNS::RequestError","name":"RequestError","abstract":false,"superclass":{"html_id":"scaleway-ddns/Exception","kind":"class","full_name":"Exception","name":"Exception"},"ancestors":[{"html_id":"scaleway-ddns/Exception","kind":"class","full_name":"Exception","name":"Exception"},{"html_id":"scaleway-ddns/Reference","kind":"class","full_name":"Reference","name":"Reference"},{"html_id":"scaleway-ddns/Object","kind":"class","full_name":"Object","name":"Object"}],"locations":[{"filename":"src/scaleway_ddns/errors.cr","line_number":5,"url":null}],"repository_name":"scaleway-ddns","program":false,"enum":false,"alias":false,"const":false,"namespace":{"html_id":"scaleway-ddns/ScalewayDDNS","kind":"module","full_name":"ScalewayDDNS","name":"ScalewayDDNS"},"constructors":[{"html_id":"new(http_status:Int32)-class-method","name":"new","abstract":false,"args":[{"name":"http_status","external_name":"http_status","restriction":"Int32"}],"args_string":"(http_status : Int32)","args_html":"(http_status : Int32)","location":{"filename":"src/scaleway_ddns/errors.cr","line_number":6,"url":null},"def":{"name":"new","args":[{"name":"http_status","external_name":"http_status","restriction":"Int32"}],"visibility":"Public","body":"_ = allocate\n_.initialize(http_status)\nif _.responds_to?(:finalize)\n  ::GC.add_finalizer(_)\nend\n_\n"}}]},{"html_id":"scaleway-ddns/ScalewayDDNS/Updater","path":"ScalewayDDNS/Updater.html","kind":"class","full_name":"ScalewayDDNS::Updater","name":"Updater","abstract":false,"superclass":{"html_id":"scaleway-ddns/Reference","kind":"class","full_name":"Reference","name":"Reference"},"ancestors":[{"html_id":"scaleway-ddns/Reference","kind":"class","full_name":"Reference","name":"Reference"},{"html_id":"scaleway-ddns/Object","kind":"class","full_name":"Object","name":"Object"}],"locations":[{"filename":"src/scaleway_ddns/updater.cr","line_number":2,"url":null}],"repository_name":"scaleway-ddns","program":false,"enum":false,"alias":false,"const":false,"namespace":{"html_id":"scaleway-ddns/ScalewayDDNS","kind":"module","full_name":"ScalewayDDNS","name":"ScalewayDDNS"},"constructors":[{"html_id":"new(config:Config)-class-method","name":"new","abstract":false,"args":[{"name":"config","external_name":"config","restriction":"Config"}],"args_string":"(config : Config)","args_html":"(config : <a href=\"../ScalewayDDNS/Config.html\">Config</a>)","location":{"filename":"src/scaleway_ddns/updater.cr","line_number":3,"url":null},"def":{"name":"new","args":[{"name":"config","external_name":"config","restriction":"Config"}],"visibility":"Public","body":"_ = allocate\n_.initialize(config)\nif _.responds_to?(:finalize)\n  ::GC.add_finalizer(_)\nend\n_\n"}}],"instance_methods":[{"html_id":"run-instance-method","name":"run","abstract":false,"location":{"filename":"src/scaleway_ddns/updater.cr","line_number":7,"url":null},"def":{"name":"run","visibility":"Public","body":"begin\n  if @config.domain_list.none?\n    raise(GlobalError.new(\"Empty domain list, please check configuration variables.\"))\n  end\n  loop do\n    Log.info do\n      \"Starting DNS update...\"\n    end\n    begin\n      current_ip = IP.current_ip\n      @config.domain_list.each do |domain|\n        update_single_domain(domain, current_ip)\n      end\n    rescue exception : IPError\n      Log.error do\n        exception.message\n      end\n    end\n    Log.info do\n      \"DNS update finished, sleeping...\"\n    end\n    sleep(@config.idle_minutes * 60)\n  end\nrescue exception : GlobalError\n  Log.error do\n    exception.message\n  end\n  Log.info do\n    \"Exiting...\"\n  end\n  exit(1)\nend"}}]}]}]}})