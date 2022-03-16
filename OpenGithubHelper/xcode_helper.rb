class XcodeHelper
  def full_path
    script = <<~SCRIPT
      let app = Application("Xcode");
      let windowTitle = app.windows[0].name().replace(" — Edited", "");

      for (let i = 0; i < app.documents.length; i++) {
        let path = app.documents[i].path();
        if (path.includes(windowTitle)) {
          path;
        }
      }
    SCRIPT

    @full_path ||= `osascript -l JavaScript<<END
#{script}
END`.strip
  end

  def project_root
    if @project_root.nil?
      raise "Can't detect project root path" if full_path.empty?
      @project_root = File.dirname(full_path)

      loop do
        return @project_root if File.exist?(File.join(@project_root, ".git"))

        @project_root = File.dirname(@project_root)
        if @project_root == "/" || @project_root == "."
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
