#!/usr/bin/env ruby

require 'fileutils'

# ============================================================================

def colorize(text, color_code)
  "\033#{color_code}#{text}\033[0m"
end

def red(text)
    colorize(text, "[31m")
end

def green(text)
    colorize(text, "[32m")
end

def blue(text)
    colorize(text, "[34m")
end

def guard()
    if !$?.success?
        puts red("FAILURE #{$?.to_i}")
        exit($?.to_i)
    end
end

def dir
    begin
        return File.readlink($0)
    rescue
        return $0
    end
end
DIR = File.dirname(dir)

# ============================================================================

PHARO_MAJOR_VERSION = ARGV[0]
PHARO_BUILD_VERSION = ARGV[1].to_i()

puts blue("Exporting Pharo Version #{PHARO_BUILD_VERSION}")

# ============================================================================
puts blue("Updating local git resources")

# assume that when we're in a git repository it is the phato-build one
if File.exist? DIR+'/../.git'
    SCRIPTS = DIR+'/../'
else 
   SCRIPTS = 'pharo-build/'
    system("test -e pharo-build || git clone --depth=1 git@gitorious.org:pharo-build/pharo-build.git")
    system("git --git-dir=pharo-build/.git pull")
end
 
puts REPOS="git@github.com:pharo-project/pharo-core.git"
system("test -e pharo-core || git clone --depth=1 -b #{PHARO_MAJOR_VERSION} --no-checkout #{REPOS}")
system("git --git-dir=pharo-core/.git pull")
system("rm -rf pharo-core/*")
guard()


puts REPOS="git://github.com/dalehenrich/filetree.git"
system("test -e filetree || git clone --depth=1 -b pharo#{PHARO_MAJOR_VERSION} --no-checkout #{REPOS}")
system("git --git-dir=filetree/.git pull")
guard()

# Loading the latest VM =======================================================

if !ENV.has_key? 'PHARO_VM'
  puts blue("$PHARO_VM is undefined, loading latest VM: ")
  system('wget --quiet -O - get.pharo.org/vm | bash')
  puts ENV['PHARO_VM'] = Dir.pwd+'/pharo'
end

# loading the proper image ====================================================
puts blue("Loading image version #{PHARO_BUILD_VERSION}")
system("#{SCRIPTS}/pharo-shell-scripts/fetchPharoVersion.rb #{PHARO_BUILD_VERSION}")
guard()

# exporting the pharo sources =================================================
puts blue("Updating the image and exporting all sources ")

exec("$PHARO_VM Pharo-#{PHARO_BUILD_VERSION}.image #{SCRIPTS}/scripts/pharo/pharo-#{PHARO_MAJOR_VERSION}-git-tracker.st")