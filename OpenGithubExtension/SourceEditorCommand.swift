import Foundation
import XcodeKit

class SourceEditorCommand: NSObject, XCSourceEditorCommand {
    
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {
        // Implement your command here, invoking the completion handler when done. Pass it nil on success, and an NSError on failure.
        let connection = NSXPCConnection(serviceName: "jp.cat-soft.OpenGithubHelper")
        connection.remoteObjectInterface = NSXPCInterface(with: OpenGithubHelperProtocol.self)
        connection.resume()
        let helper = connection.remoteObjectProxy as! OpenGithubHelperProtocol
        
        var line: String = ""
        let selections: [XCSourceTextRange]? = invocation.buffer.selections as? [XCSourceTextRange]
        if let selections = selections {
            if selections[0].start.line != selections[0].end.line ||
                selections[0].start.column != selections[0].end.column {
                let start = selections[0].start.line + 1
                let end = selections[0].end.column > 0 ? selections[0].end.line + 1 : selections[0].end.line
                line = (start != end) ? "L\(start)-L\(end)" : "L\(start)"
            }
        }
        
        let semaphore = DispatchSemaphore(value: 0)
        helper.open(with: line) {
            semaphore.signal()
        }
        _ = semaphore.wait(timeout: .now() + 5)
        completionHandler(nil)
    }
    
}
