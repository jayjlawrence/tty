# encoding: utf-8

require 'pastel'

require_relative '../cmd'
require 'open3'

module TTY
  module Commands
    class New < Cmd

      attr_reader :app_name

      def initialize(app_name, options)
        @app_name = app_name
        @options = options
        @pastel = Pastel.new
      end

      def template_source_path
      end

      # Execute the command
      #
      # @api public
      def execute
        # cli_name = ::File.basename(app_name)
        puts "OPTS: #{@options}" if @options['debug']

        coc_opt = @options['coc'] ? '--coc' : '--no-coc'
        test_opt = @options['test']
        command = "bundle gem #{app_name} --no-mit --no-exe #{coc_opt} -t #{test_opt}"

        #out, _  = run(command)
        out, _, _ = Open3.capture3(command)

        if !@options['no-color']
          out = out.gsub(/^(\s+)(create)/, '\1' + @pastel.green('\2')).
                    gsub(/^(\s+)(identical)/, '\1' + @pastel.yellow('\2'))
        end

        puts out
      end
    end # New
  end # Commands
end # TTY
