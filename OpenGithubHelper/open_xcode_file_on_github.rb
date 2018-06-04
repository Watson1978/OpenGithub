require_relative 'xcode_helper'

xcode = XcodeHelper.new

remote = nil
branch = nil
repository = nil
Dir.chdir xcode.project_root do
  `git branch -r`.strip.lines do |line|
    if line =~ %r{.+/HEAD -> (.+)/(.+)$}
      remote = $1
      branch = $2
      break
    end
  end
  exit unless remote
  exit unless branch

  `git remote -v`.strip.lines do |line|
    if line =~ %r{#{remote}\s+git@github.com:(.+)\.git \(fetch\)$} || line =~ %r{#{remote}\s+https://github.com/(.+)\.git \(fetch\)$}
      repository = $1
      break
    end
  end
  exit unless repository
end

line = ARGV[0] || ""
unless line.empty?
  line = "#" + line
end

system "open 'https://github.com/#{repository}/blob/#{branch}/#{xcode.file_path}#{line}'"
