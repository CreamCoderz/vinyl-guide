module Sunspot
  module Rails
    class Server < Sunspot::Server
      def solr_data_dir
        File.join(::PROPERTIES['solr_home_path'], 'solr', ::Rails.env)
      end
    end
  end
end