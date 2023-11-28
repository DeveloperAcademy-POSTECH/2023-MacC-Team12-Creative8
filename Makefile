project:
	tuist clean
	tuist fetch
	tuist generate && pod install &&  open Setlist.xcworkspace
