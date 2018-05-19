import Foundation
import XcodeKit

class SourceEditorCommand: NSObject, XCSourceEditorCommand {
    
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {
        // Implement your command here, invoking the completion handler when done. Pass it nil on success, and an NSError on failure.
        let connection = NSXPCConnection(serviceName: "jp.cat-soft.OpenGithubHelper")
        connection.remoteObjectInterface = NSXPCInterface(with: OpenGithubHelperProtocol.self)
        connection.resume()
        let helper = connection.remoteObjectProxy as! OpenGithubHelperProtocol
        
        let semaphore = DispatchSemaphore(value: 0)
        helper.open() {
            semaphore.signal()
        }
        _ = semaphore.wait(timeout: .now() + 5)
        completionHandler(nil)
    }
    
}
