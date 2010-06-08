require "ripper"

module SpelledCode
  # Records all scanner events
  class SpelledCodeRipper < Ripper
    attr_accessor :scanner_events

    def initialize(*args)
      super
      @scanner_events = []
    end

    Ripper::SCANNER_EVENTS.each do |meth|
      define_method("on_#{ meth }") do |*args|
        @scanner_events << [ meth.to_sym, args[0], lineno, column ]
        nil
      end
    end
  end
end