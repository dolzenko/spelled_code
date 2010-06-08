require "sinatra/base"
require "sinatra/reloader" if ENV["SINATRA_RELOADER"]
require "sinatra_more/markup_plugin"

require "coderay"
require "coderay/encoder"
require "coderay/encoders/html"

require "dolzenko/core_ext/kernel/in"

require "spelled_code/coderay_ruby_scanner"
require "spelled_code/coderay_html_encoder"
require "spelled_code/spelled_code_ripper"

require File.expand_path("../../../vendor/rhunspell/lib/rhunspell.rb", __FILE__)

# Properly spelled comment

if ENV["SINATRA_RELOADER"]
  require "pp"
  
  module ::Kernel
    def r(*args)
      raise((args.size == 1 ? args[0] : args).inspect)
    end
  end
end

module SpelledCode
  class Application < Sinatra::Base
    register SinatraMore::MarkupPlugin
    
    configure(:development) do
      if ENV["SINATRA_RELOADER"]
        register Sinatra::Reloader
        also_reload "lib/**/*.rb"
      end
    end    

    class << self
      def root
        require "pathname"
        Pathname("../../../").expand_path(__FILE__)
      end
    end

    set :public, self.root + "public"
    set :views, self.root + "views"

    CODERAY_ENCODER_OPTIONS = {
      :wrap => :div,
      :css => :class,
      :line_numbers => :inline
    }.freeze

    get "/check*" do
      @path = params[:splat][0]
      source = IO.read(@path)
      tokens = CodeRayRubyScanner.new(source).tokenize

      options = {}
      options = CODERAY_ENCODER_OPTIONS.merge(options)
      encoder = CodeRayHtmlEncoder.new(options.merge(:path => @path))

      @source = encoder.encode_tokens(tokens)
      
      erb :check
    end

    get "/summary*" do
      @dir = params[:splat][0]
      @files_with_spelling_errors = {}
      Dir[File.join(@dir, "**/*.rb")].each do |path|
        source = IO.read(path)
        scanner = CodeRayRubyScanner.new(source)
        scanner.tokenize
        @files_with_spelling_errors[path] = scanner.spelling_errors_detected
      end

      erb :summary
    end

    protected

    error(404) { @app.call(env) if @app }
  end
end