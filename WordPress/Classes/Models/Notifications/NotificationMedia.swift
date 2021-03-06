import Foundation



// MARK: - NotificationMedia Entity
//
class NotificationMedia
{
    /// Kind of the current Media.
    ///
    let kind: Kind

    /// Text Range Associated!
    ///
    let range: NSRange

    /// Resource URL, if any.
    ///
    private(set) var mediaURL: NSURL?

    /// Resource Size, if any.
    ///
    private(set) var size: CGSize?


    /// Designated Initializer.
    ///
    init?(dictionary: [String: AnyObject]) {
        guard let type = dictionary[MediaKeys.RawType] as? String, let indices = dictionary[MediaKeys.Indices] as? [Int],
            let start = indices.first, let end = indices.last else
        {
            return nil
        }

        kind = Kind(rawValue: type) ?? .Image
        range = NSMakeRange(start, end - start)

        if let url = dictionary[MediaKeys.URL] as? String {
            mediaURL = NSURL(string: url)
        }

        if let width = dictionary[MediaKeys.Width] as? NSNumber, let height = dictionary[MediaKeys.Height] as? NSNumber {
            size = CGSize(width: width.integerValue, height: height.integerValue)
        }
    }
}


// MARK: - NotificationRange Parsers
//
extension NotificationMedia
{
    /// Parses NotificationMedia instances, given an array of raw media.
    ///
    class func mediaFromArray(media: [[String: AnyObject]]?) -> [NotificationMedia] {
        let parsed = media?.flatMap {
            return NotificationMedia(dictionary: $0)
        }

        return parsed ?? []
    }
}


// MARK: - NotificationMedia Types
//
extension NotificationMedia
{
    /// Known kinds of Media Entities
    ///
    enum Kind: String {
        case Image              = "image"
        case Badge              = "badge"
    }

    /// Parsing Keys
    ///
    private enum MediaKeys {
        static let RawType      = "type"
        static let URL          = "url"
        static let Indices      = "indices"
        static let Width        = "width"
        static let Height       = "height"
    }
}
