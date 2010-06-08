require "coderay"
require "spelled_code/spelled_code_ripper"

module SpelledCode

  # TODO Heredocs in args are royally screwed
  class CodeRayRubyScanner < ::CodeRay::Scanners::Scanner
    attr_reader :spelling_errors_detected
    SCANNER_EVENT_TO_CODERAY_TOKEN =
            {
                    :kw => :reserved,
                    :nl => :space,
                    :sp => :space,
                    :ignored_nl => :space,
                    # :tstring_beg => :delimiter,
                    # :tstring_end => :delimiter,
                    :tstring_content => :content,
                    # Кipper reports rbrace always, CodeRay differentiates
                    # between blocks, and rbraces in string interpol
                    # :embexpr_beg => :inline_delimiter,
                    :lbrace => :operator,
                    :rbrace => :operator,
                    :lparen => :operator,
                    :rparen => :operator,
                    :lbracket => :operator,
                    :rbracket => :operator,
                    :comma => :operator,
                    :op => :operator,
                    :int => :integer,
                    :period => :operator,
                    :const => :constant,
                    :cvar => :class_variable,
                    :ivar => :instance_variable,
                    :gvar => :global_variable,
                    :embvar => :escape, # ?
                    :embdoc_beg => :comment,
                    :embdoc => :comment,
                    :embdoc_end => :comment,
                    :qwords_beg => :content,
                    :words_sep => :content,
                    :CHAR => :integer,
                    # * :constant => :class, CodeRay reports `class` token for
                    #   class def, we report just `const` always
                    # * Ripper doesn't have `char` event
                    # * `42 if true` - CodeRay reports `pre_constant`
            }

    def initialize(*args)
      @spelling_errors_detected = 0
      super
    end

    def check_word(word)
      @dict ||= Hunspell.new("/usr/share/hunspell/en_US.aff",
                             "/usr/share/hunspell/en_US.dic")
      

      return true if word.size == 1 || word.size == 2
      return true if word =~ /\A\d+\z/
      downcased_word = word.downcase
      return true if downcased_word.in?(DICT)
      @dict.check(word)
    end

    SEPARATOR = /[\s_\/\/.*@#:=,"'()><{}\[\]?+-;!`&$%^]+/

    DICT = (<<-DICT).split("\n").map(&:strip).map(&:downcase)
zlib
sprintf
programmatically
composable
signup
railtie
railties
configs
reloadable
unloadable
autoloadable
uncountables
titleize
titlecase
middleware
middlewares
orm
unserialized
serializable
wiki
rdoc
crc
meth
procs
regexp
regexps
stdin
stdout
stderr
stringio
dir
basename
teardown
backtrace
ssl
charset
utf
klasses
ddl
msg
migrator
cpu
preloading
joe
nonreloadables
schemas
varchar
cancelled
lifecycle
proc
gravatar
asc
desc
truthy
unassignable
taggings
singularized
usd
struct
addressables
mixin
mixins
taggable
uncached
plugins
downcase
mattr
const
downcased
rubyonrails
google
www
csv
testcases
strftime
myisam
innodb
reginald
george
phusion
param
stringify
timestamp
Heinemeier
Hansson
eql
unfreezed
typecasted
callstack
fixnum
datetime
fallback
autosave
autoload
autoloads
ivar
habtm
uniq
sym
doesn
demodulize
didn
instantiator
eval
idx
scopings
uniqued
dup
constantize
unshift
foo
attrs
ary
arity
gsub
id
undefine
unscoped
activerecord
jamie
jeremy
url
urls
dave
inflector
english
singularize
Firebird
postgresql
postgres
camelize
username
usernames
colour
auth
ryan
Daigle
matz
gemfile
init
autoloaded
undef
config
yml
sqlite
prepended
prepend
basecamp
namespace
organising
rakefile
utc
sti
preload
readonly
mysql
meetup
quentin
cattr
accessor
multiparameter
klass
admin
isn
harvey
37signals
benchmarkable
attr
sanitization
sql
http
david
readme
env
params
args
erb
sinatra
plugin
coderay
html
ext
dolzenko
rhunspell
lib
rb
tokenize
io
css
inline
app
todo
heredoc
heredocs
dict
concat
yaml
arel
nodoc
timestamping
sybase
kcode
dsl
metadata
arg
diff
xml
bigint
smallint
mediumint
tinyint
bigdecimal
rdbms
savepoint
savepoints
guid
backend
backends
checkin
prefetch
mutex
autoincrement
sublicense
noninfringement
activesupport
activemodel
validator
validators
unserialize
unserializable
deserialization
bignum
multibyte
wikipedia
json
dirname
nullable
localhost
tmp
serializer
serializers
dasherize
startdoc
stopdoc
async
savepoint
unicode
multipart
pdf
smtp
actionmailer
api
sendmail
actionpack
javascripts
stylesheet
stylesheets
inferrable
readlines
wildcard
behaviour
etag
javascript
gzip
src
href
favicon
favicons
screenshot
extname
uri
mtime
mkdir
utime
util
utils
filesystem
textilize
textilized
textiled
CGI
unescape
unescaped
unescapeHTML
escapeHTML
restful
textarea
checkbox
referer
ajax
xhtml
dropdown
tos
eula
png
jpg
fieldset
namespaces
namespaced
dom
csrf
rhtml
upcase
rss
scriptaculous
draggable
droppable
https
tokenizer
equivalency
jpeg
rfc
hostname
renderer
renderers
pre
str
addr
rjs
refactor
unprocessable
httponly
xhr
iphone
transcode
finalizer
memoizable
memoize
memoizes
metaprogramming
memoizing 
unmemoize
unmemoized
argv
warmup
benchmarker
chdir
memoized
fallbacks
regex
memcached
github
ret
rescuable
unkept
cdata
weblog
numericality
gif
robert
subclassed
tableize
activeresource
endian
codepoint
codepoints
rindex
rstrip
lstrip
rjust
ljust
tzinfo
memcache
incr
decr
deserialize
xmlschema
unsubscribe
ordinalize
instantized
indices
rubygems
grep
multiline
localtime
getutc
cloneable
hardcode
dups
builtin
usec
unmarshalled
instrumenter
encryptor
    DICT

    #  http://ubuntu.localdomain:4567/check/mnt/hgfs/ubuntu_shared/rails/activerecord/lib/active_record/test_case.rb "\nQueries:\n#{$queries_executed.join("\n")}"}"
# http://ubuntu.localdomain:4567/check/mnt/hgfs/ubuntu_shared/rails/activerecord/lib/active_record/schema.rb  #     create_table :authors do |t|
    # http://ubuntu.localdomain:4567/check/mnt/hgfs/ubuntu_shared/rails/activerecord/lib/active_record/dynamic_finder_match.rb
    # http://ubuntu.localdomain:4567/check/mnt/hgfs/ubuntu_shared/rails/activerecord/lib/active_record/associations/has_many_through_association.rb hasn't
    # http://ubuntu.localdomain:4567/check/mnt/hgfs/ubuntu_shared/rails/activerecord/lib/active_record/associations/association_proxy.rb
    
    

    def checked_word(word, lineno, column)
      check_word(word) ? word : "<e l=#{lineno} c=#{column}>#{ word }</e>"
    end

    def camel_cased_word_parts(word)
      cased_parts = word.scan(/[A-Z]*[a-z]+/)
      if cased_parts.join("") == word
        cased_parts
      else
        [word]
      end
    end

    def checked_camel_case_word(word, lineno, column)
      cased_parts = word.scan(/[A-Z]*[a-z]+/)
      if cased_parts.join("") == word
        # proper camel cased word
        cased_parts.map { |word| checked_word(word, lineno, column) }.join("")
      else
        checked_word(word, lineno, column)
      end
    end

    def append_spell_checked_event(events, event, word, lineno, column)
      camel_cased_word_parts(word).each do |word_part|
        if check_word(word_part)
          if events.size > 0 && events[-1][1] != :close_spelling_error
            events[-1][1] << word_part
          else
            events << [ event, word_part ]
          end
        else
          events << [ [lineno, column], :open_spelling_error ]
          @spelling_errors_detected += 1
          events << [ event, word_part ]
          events << [ nil, :close_spelling_error ]
        end
      end
    end

    def append_separator(events, event, separator)
      if events.size > 0 && events[-1][1] != :close_spelling_error
        events[-1][1] << separator
      else
        events << [ event, separator ]
      end
    end

    def spell_check(event, value, lineno, column)
      events = []

      offset = 0
      max_offset = value.size - 1
      while offset <= max_offset
        if m = value.match(SEPARATOR, offset)
          separator_begin, separator_end = m.offset(0)
          # puts "matched at #{ [separator_begin, separator_end ].inspect}"
          separator = m[0]
          if separator_begin - offset > 0
            word = value[offset .. separator_begin - 1]
            append_spell_checked_event(events, event, word, lineno, column)
          end
          append_separator(events, event, separator)
          offset = separator_end 
        else
          word = value[offset .. max_offset]
          append_spell_checked_event(events, event, word, lineno, column)
          # r(new_value)
          break
        end
      end

      events
    end

    def coderay_tokens(scanner_events)
      @coderay_tokens = []
      in_backtick = false
      in_symbol = false
      in_embexpr_nesting = 0

      # puts scanner_events.inspect

      checked_scanner_events = []

      scanner_events.each do |event, value, lineno, column|
        if event.in?([:ident, :tstring_content, :const, :cvar, :ivar, :gvar, :embdoc, :comment])
          checked_scanner_events.concat spell_check(event, value, lineno, column)
        else
          checked_scanner_events << [ event, value ]
        end
      end


      checked_scanner_events.each do |scanner_event|
        event, token_val = scanner_event.values_at(0, 1)

        if token_val.in?([:open_spelling_error, :close_spelling_error]) 
          @coderay_tokens << [event, token_val]
          next
        end
        
        ripper_token = SCANNER_EVENT_TO_CODERAY_TOKEN[event.to_sym] || event.to_sym
        if in_backtick && event == :lparen
          @coderay_tokens.pop # remove [:open, :shell], [token_val, :delimiter]
          @coderay_tokens.pop # and replace with method declaration
          @coderay_tokens << ["`", :method]
          @coderay_tokens << ["(", :operator]
        elsif in_embexpr_nesting > 0 && event == :rbrace
          @coderay_tokens << [token_val, :inline_delimiter]
          @coderay_tokens << [:close, :inline]
          in_embexpr_nesting -= 1
        elsif event == :embexpr_beg
          @coderay_tokens << [:open, :inline]
          @coderay_tokens << [token_val, :inline_delimiter]
          in_embexpr_nesting += 1
        elsif in_symbol && [:ident, :const, :ivar, :cvar, :gvar, :op, :kw].include?(event)
          # parse.y
          #
          # symbol		: tSYMBEG sym
          #
          #          sym		: fname
          #              | tIVAR
          #              | tGVAR
          #              | tCVAR
          #              ;
          #
          #          fname		: tIDENTIFIER
          #              | tCONSTANT
          #              | tFID
          #              | op
          #                  {
          #                lex_state = EXPR_ENDFN;
          #                $$ = $1;
          #                  }
          #              | reswords
          #                  {
          #                lex_state = EXPR_ENDFN;
          #                  /*%%%*/
          #                $$ = $<id>1;
          #                  /*%
          #                $$ = $1;
          #                  %*/
          #                  }
          #              ;
          @coderay_tokens << [token_val, :content]
          @coderay_tokens << [:close, :symbol]
          in_symbol = false
        elsif ripper_token == :regexp_beg
          @coderay_tokens << [:open, :regexp]
          @coderay_tokens << [token_val, :delimiter]
        elsif ripper_token == :regexp_end
          @coderay_tokens << [token_val, :delimiter]
          @coderay_tokens << [:close, :regexp]
        elsif ripper_token == :tstring_beg
          @coderay_tokens << [:open, :string]
          @coderay_tokens << [token_val, :delimiter]
        elsif ripper_token == :tstring_end
          @coderay_tokens << [token_val, :delimiter]
          if in_backtick
            @coderay_tokens << [:close, :shell]
            in_backtick = false
          elsif in_symbol
            @coderay_tokens << [:close, :symbol]
            in_symbol = false
          else
            @coderay_tokens << [:close, :string]
          end
        elsif ripper_token == :symbeg
          if in_symbol # nesting not supported
            @coderay_tokens << [token_val, :symbol]
          else
            @coderay_tokens << [:open, :symbol]
            @coderay_tokens << [token_val, :delimiter]
            in_symbol = true
          end
        elsif ripper_token == :backtick
          if in_backtick # nesting not supported 
            @coderay_tokens << [token_val, :operator]
          else
            @coderay_tokens << [:open, :shell]
            @coderay_tokens << [token_val, :delimiter]
            in_backtick = true
          end
        else
          @coderay_tokens << [token_val, ripper_token]
        end
      end

      tokens = @coderay_tokens

      tokens
    end

    def scan_tokens(tokens, options)
      parser = SpelledCodeRipper.new(code)
      parser.parse
      tokens.replace(coderay_tokens(parser.scanner_events))
      tokens
    end
  end
end