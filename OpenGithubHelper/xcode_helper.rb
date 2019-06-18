class XcodeHelper
  def full_path
    @full_path ||= `osascript<<END
      tell application "Xcode"
        set num to index of front window
        set file_path to ""

        try
          set file_path to path of source document (num - 1)
        end try

        return file_path
      end tell
    END`.strip
  end

  def project_root
    if @project_root.nil?
      @project_root = File.dirname(full_path)

      loop do
        return @project_root if File.exist?(File.join(@project_root, ".git"))

        @project_root = File.dirname(@project_root)
        if @project_root == "/"
          @project_root = nil
          return @project_root
        end
      end
    end

    @project_root
  end

  def file_path
    full_path.sub("#{project_root}/", '')
  end
end
