require_relative 'xcode_helper'

xcode = XcodeHelper.new

repository = nil
branch = nil
Dir.chdir xcode.project_root do
  `git remote -v`.strip.lines do |line|
    if line =~ %r{git@github.com:(.+)\.git \(fetch\)$} || line =~ %r{https://github.com/(.+)\.git \(fetch\)$}
      repository = $1
      break
    end
  end
  exit unless repository

  `git branch -r`.strip.lines do |line|
    if line =~ %r{.+/HEAD -> .+/(.+)$}
      branch = $1
      break
    end
  end
  exit unless branch
end

line = ARGV[0] || ""
unless line.empty?
  line = "#" + line
end

system "open 'https://github.com/#{repository}/blob/#{branch}/#{xcode.file_path}#{line}'"
