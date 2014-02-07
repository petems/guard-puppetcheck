require 'guard'
require 'guard/plugin'
require 'puppet'
require 'puppet-lint'

module Guard
  class PuppetCheck < Plugin

    attr_accessor :reactor, :options

    def initialize(options = {})
      super
      @options = {
        :syntax_check => true,
        }.merge(options)
      end

    # Calls #run_all if the :all_on_start option is present.
    def start
      run_all if options[:all_on_start]
    end

    # Call #run_on_change for all files which match this guard.
    def run_all
      run_on_change(Watcher.match_files(self, Dir.glob('{,**/}*{,.*}').uniq))
    end

    def prepend_filename(msg, file)
      if msg
        msg.map {|x| "#{file}: #{x}"}
      else
        []
      end
    end

    # Print the result of the command(s), if there are results to be printed.
    def run_on_change(res)
      @linter = PuppetLint.new

      messages = []
      res.each do |file|
        file = File.join( options[:watchdir].to_s,file ) if options[:watchdir]

        if options[:syntax_check]
          UI.info "Guard::PuppetCheck is running a syntax check..."
          Puppet.initialize_settings unless Puppet.settings.app_defaults_initialized?
          UI.info "Parsing with Puppet Version: #{Puppet.version}"

          begin
            parser = Puppet::Parser::Parser.new("PuppetCheckParser")
            parser.import(file)
            puts "No error found on #{file}"
          rescue Puppet::ParseError => e
            messages << "Parser Error! File: #{file} - Error: #{e}"
          end
        end

        @linter.file = file
        @linter.clear_messages
        @linter.run
        linter_msg = @linter.messages.reject { |s| !options[:show_warnings] && s =~ /WARNING/ }
        messages += prepend_filename(linter_msg, file)
      end
      if messages.empty?
        messages = ["Files are ok:"] + res
        image = :success
      else
        image = :failed
      end
      Notifier.notify( messages.join("\n"), :title => "Puppet lint", :image => image )
    end

  end
end
