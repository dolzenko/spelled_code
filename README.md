## SpelledCode - Fine Machinery To Spell Check Your Codes

Probably not that fine but I was able to use it to spell check whole Rails
source and make patch in this ticket
https://rails.lighthouseapp.com/projects/8994-ruby-on-rails/tickets/4796-patch-fix-a-bunch-of-minor-spelling-mistakes
in just a few hours 

## Hacking

    > bundle install
    > rbdev (see http://gist.github.com/361451#gistcomment-948)
    ./lib on $RUBYLIB
    > rackup -p 4567 -s thin 
    
Navigate to http://localhost:4567/summary`<folder with ruby sources to spell check>`
    
For example http://localhost:4567/summary/mnt/hgfs/ubuntu\_shared/spelled\_code/
will spell check all the ruby sources under `/mnt/hgfs/ubuntu_shared/spelled_code/`
and output summary table of files with spelling errors.

Navigate to http://localhost:4567/check`<ruby file to spell check>`

For example http://localhost:4567/check/mnt/hgfs/ubuntu_shared/spelled\_code/vendor/rhunspell/setup.rb
will output source of `vendor/rhunspell/setup.rb` file
with spelling errors highlighted.