//
//  StreamReader.swift
//  gherkin
//

// Not sure if we can use this. It was taken from http://stackoverflow.com/a/24648951
// and did not have any
import Foundation

class StreamReader  {
    
    let encoding : UInt
    let chunkSize : Int
    var atEof : Bool = false
    
    var fileHandle : NSFileHandle!
    let buffer : NSMutableData!
    let delimData : NSData!
    
    init?(path: String, delimiter: String = "\n", encoding: UInt = NSUTF8StringEncoding, chunkSize : Int = 4096) {
        self.chunkSize = chunkSize
        self.encoding = encoding
        
        do {
            self.fileHandle = try NSFileHandle(forReadingFromURL: NSURL(fileURLWithPath: path))
        } catch {
            print("more error handling!")
        }
        
        if self.fileHandle == nil {
            return nil
        }
        
        self.buffer = NSMutableData(capacity: chunkSize)!
        
        // Create NSData object containing the line delimiter:
        delimData = delimiter.dataUsingEncoding(NSUTF8StringEncoding)!
    }
    
    deinit {
        self.close()
    }
    
    /// Return next line, or nil on EOF.
    func nextLine() -> String? {
        
        if atEof {
            return nil
        }
        
        // Read data chunks from file until a line delimiter is found:
        var range = buffer.rangeOfData(delimData, options: NSDataSearchOptions(rawValue: 0), range: NSMakeRange(0, buffer.length))
        while range.location == NSNotFound {
            let tmpData = fileHandle.readDataOfLength(chunkSize)
            if tmpData.length == 0 {
                // EOF or read error.
                atEof = true
                if buffer.length > 0 {
                    // Buffer contains last line in file (not terminated by delimiter).
                    let line = NSString(data: buffer, encoding: encoding);
                    buffer.length = 0
                    return line as? String
                }
                // No more lines.
                return nil
            }
            buffer.appendData(tmpData)
            range = buffer.rangeOfData(delimData, options: NSDataSearchOptions(rawValue: 0), range: NSMakeRange(0, buffer.length))
        }
        
        // Convert complete line (excluding the delimiter) to a string:
        let line = NSString(data: buffer.subdataWithRange(NSMakeRange(0, range.location)),
            encoding: encoding)
        // Remove line (and the delimiter) from the buffer:
        buffer.replaceBytesInRange(NSMakeRange(0, range.location + range.length), withBytes: nil, length: 0)
        
        return line as? String
    }
    
    /// Start reading from the beginning of file.
    func rewind() -> Void {
        fileHandle.seekToFileOffset(0)
        buffer.length = 0
        atEof = false
    }
    
    /// Close the underlying file. No reading must be done after calling this method.
    func close() -> Void {
        if fileHandle != nil {
            fileHandle.closeFile()
            fileHandle = nil
        }
    }
}

extension StreamReader : SequenceType {
    func generate() -> AnyGenerator<String> {
        return anyGenerator {
            return self.nextLine()
        }
    }
}