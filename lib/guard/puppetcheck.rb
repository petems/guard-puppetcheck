require 'guard'
require 'guard/plugin'

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
      errors = 0
      res.each do |file|
        file = File.join( options[:watchdir].to_s,file ) if options[:watchdir]

        if options[:syntax_check]
          puts "Guard::PuppetLint: Syntax Check Enabled - Running on #{file}"
          maybe_bundle_with_env do
            @parser_messages = `puppet parser validate #{file} --color=false 2>&1`.split("\n")
          end
        end

        UI.info "Guard::PuppetLint: Running Lint on #{file}"
        
        @lint_messages = `puppet-lint #{file} --no-autoloader_layout-check`    

        if @parser_messages.nil? && @lint_messages.nil?
          UI.info "Guard::PuppetLint: No Issues Found, Hooray!"
          image = :success
        else
          UI.error "Guard::PuppetLint: Issues Found!"
          UI.error "Parser Errors: #{@parser_messages}" unless @parser_messages.empty?
          UI.error "Lint Errors:\n#{@lint_messages}" unless @lint_messages.empty?
          image = :failed
        end
        Notifier.notify( 'Guard::PuppetLint', :title => "Puppet lint", :image => image )
        Notifier.notify( "Parser Errors:\n#{@parser_messages}", :title => "Puppet lint", :image => image ) unless @parser_messages.empty?
        Notifier.notify( "Lint Errors:\n#{@lint_messages}", :title => "Puppet lint", :image => image ) unless @lint_messages.empty?
      end
    end

    private
    def maybe_bundle_with_env(&block)
      if defined?(::Bundler)
        Bundler.with_clean_env(&block)
      else
        yield
      end
    end

  end
end
