# PATH
export PATH="/usr/local/bin:$PATH"

# make sure system is up-to-date
softwareupdate --install --all

# install homebrew
ruby -e "$(curl -fsSL
https://raw.githubusercontent.com/Homebrew/install/master/install)"

# python environment
brew install python
# install some eggs
#pip install asciinema livestreamer subliminal

# ruby environment
brew install ruby
# install some gems
export GEM_HOME="$(brew --prefix)"
gem install --no-ri --no-rdoc bundler chromedriver2-helper csscss did_you_mean
jekyll pry redcarpet ronn site_validator watir-webdriver

# nodejs environment
brew install node
# install some packages
npm install --global browser-sync gulp bower vtop divshot-cli gitignore grunt-cli harp
html2jade imageoptim-cli nightmare pageres puer tldr
