class XcodeHelper
  def full_path
    @full_path ||= `osascript<<END
      tell application "Xcode"
        set file_name to name of front window
        set file_name to replace(file_name, " — Edited", "") of me
        
        set num to number of source document
        
        repeat with index from 0 to num
          set file_path to path of source document index
          set pos to offset of file_name in file_path
          
          if pos is greater than 0 then
            return file_path
          end if
        end repeat
      end tell

      on replace(orgStr, tgtStr, newStr)
        
        local orgDelim, rtn
        
        set orgDelim to AppleScript's text item delimiters
        set AppleScript's text item delimiters to {tgtStr}
        set rtn to every text item of orgStr
        set AppleScript's text item delimiters to {newStr}
        set rtn to rtn as string
        set AppleScript's text item delimiters to orgDelim
        return rtn
        
      end replace
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
