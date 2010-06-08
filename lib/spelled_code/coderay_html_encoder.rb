require "reflexive/routing_helpers"

require "English"

require "coderay"
require "coderay/encoder"
require "coderay/encoders/html"

module SpelledCode
  class CodeRayHtmlEncoder < ::CodeRay::Encoders::HTML
    def initialize(*args)
      super
      @path = args[-1][:path]
    end

    def token(text, type = :plain)
      if type == :open_spelling_error
        lineno, column = text
        @out << "<a class='serr' href='txmt://open?url=file://#{ @path }&line=#{ lineno }&column=#{ column }'>"
      elsif type == :close_spelling_error
        @out << "</a>"
      else
        super(text, type)
      end
    end

    def compile(tokens, options)
      for token in tokens
        token(*token)
      end
    end
  end
end