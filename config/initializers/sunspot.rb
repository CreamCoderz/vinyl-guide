module Sunspot
  module Rails
    class Server
      def solr_data_dir
        File.join(::PROPERTIES['solr_home_path'], 'solr', ::Rails.env)
      end

      def run
        bootstrap

        command = ['java']
        command << "-Xms#{min_memory}" if min_memory
        command << "-Xmx#{max_memory}" if max_memory
        command << "-Djetty.port=#{port}" if port
        command << "-Djetty.host=#{bind_address}" if bind_address
        command << "-Dsolr.data.dir=#{solr_data_dir}" if solr_data_dir
        command << "-Dsolr.solr.home=#{solr_home}" if solr_home
        command << "-Djava.util.logging.config.file=#{logging_config_path}" if logging_config_path
        command << '-jar' << File.basename(solr_jar)
        FileUtils.cd(File.dirname(solr_jar)) do
          if ::PROPERTIES['solr_error_output'].present? && ::PROPERTIES['solr_standard_output'].present?
            exec("#{Shellwords.shelljoin(command)} 1> #{File.join(::PROPERTIES['solr_home_path'], ::PROPERTIES['solr_standard_output'])} 2> #{File.join(::PROPERTIES['solr_home_path'], ::PROPERTIES['solr_error_output'])}")
          else
            exec(Shellwords.shelljoin(command))
          end
        end
      end
    end
  end
end

# Does not raise exceptions when writing to solr
Sunspot.session = Sunspot::SessionProxy::SilentFailSessionProxy.new(Sunspot.session)