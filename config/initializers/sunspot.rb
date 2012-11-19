module Sunspot
  module Rails
    class Server
      def solr_data_dir
        File.join(::PROPERTIES['solr_home_path'], 'solr', ::Rails.env)
      end
    end
  end
end

# Does not raise exceptions when writing to solr
Sunspot.session = Sunspot::SessionProxy::SilentFailSessionProxy.new(Sunspot.session)