//Implicit rawValue
enum Number: Int{
	case zero, one, tWo, three, four, five
}
print(Number.zero, Number.one.rawValue, Number.tWo, Number.five.rawValue)

enum TextNumber: String{
	case zero, one, two, three = "สาม", four, five
}
print(TextNumber.zero, TextNumber.one.rawValue, TextNumber.three.rawValue, TextNumber.five.rawValue)

// enum EnumChar: Character{
	// case a, b, c, d          //error 
	// case a = "a", b, c, d    //require explicit rawValue when type is not expressible by Int or String
// }
// print(EnumChar.a.rawValue, EnumChar.b.rawValue)

enum CountingNumber: Int{
	// case one, two = 2, three, four  // 0, 2, 3, 4
	// case one = 1, two, three, four  // 1, 2, 3, 4
	case one = 1, two, three, four, six = 6, seven, eight  // 1, 2, 3, 4, 6, 7, 8
}
print(CountingNumber.one.rawValue, CountingNumber.two.rawValue, CountingNumber.three.rawValue, CountingNumber.six.rawValue, CountingNumber.seven.rawValue)

// rawValue initializing
let four = CountingNumber(rawValue: 4)
print(four as Any, type(of:four), four!) //optional(CountingNumber)
if let five = CountingNumber(rawValue: 5){
	print(five)
}else{
	print("5 is missing from CountingNumber")
}

//Iterate 
enum IterableNumber: CaseIterable{
	case zero
	case one, two, three
	case four, five, six
}

let one = Number.one
// print(one.rawValue) //have no rawValue
print(one, type(of: one))

print("There are \(IterableNumber.allCases.count) digits in IterableNumber")
for number in IterableNumber.allCases{
	print(number, terminator: ", ")
}
print(type(of: IterableNumber.allCases))

enum Point{
	case i2D(Int, Int)
	case i3D(Int, Int, Int)
	case f2D(Double, Double)
	case f3D(Double, Double, Double)
}

let int2DPoint = Point.i2D(2, 3)
print(int2DPoint)

var somePoint = Point.f2D(3.1, 3.2)
print(somePoint)
somePoint = .i3D(2, 3, 2)
print(somePoint)

func midPoint(start a: Point, end b: Point) -> Point?{
	func getDoubleMidCoordinate(start a: (x: Double, y: Double), end b: (x: Double, y: Double)) -> (Double, Double){
		((a.x + b.x) / 2, (a.y + b.y) / 2)
	}
	//using Enum with switch case
	var (newX, newY): (Double, Double)
	switch (a, b) {
		case let (.f2D(ax, ay), .f2D(bx, by)):
			(newX, newY) = getDoubleMidCoordinate(start: (ax, ay), end: (bx, by))
		case let (.f2D(ax, ay), .i2D(bx, by)):
			(newX, newY) = getDoubleMidCoordinate(start: (ax, ay), end: (Double(bx), Double(by)))
		case let (.i2D(ax, ay), .f2D(bx, by)):
			(newX, newY) = getDoubleMidCoordinate(start: (Double(ax), Double(ay)), end: (bx, by))
		case let (.i2D(ax, ay), .i2D(bx, by)):
			(newX, newY) = getDoubleMidCoordinate(start: (Double(ax), Double(ay)), end: (Double(bx), Double(by)))
		case (.i2D, _), (.f2D, _):
			print("Can't find middle point between 2D and 3D Points")
			return nil
		default:
			print("Not support")
			return nil
	}
	// .rounded(.towardZero) get rid of numbers after period 4.032 -> 4.0, 3.0 -> 3.0
	if newX.rounded(.towardZero) == newX && newY.rounded(.towardZero) == newY{
		return Point.i2D(Int(newX), Int(newY))
	}
	return Point.f2D(newX, newY)
}

print("mid point:")
print(midPoint(start: Point.i2D(2, 4), end: Point.i2D(4, 6)) ?? "Not valid")
print(midPoint(start: Point.i2D(2, 4), end: Point.f2D(3.2, 8.6)) ?? "Not valid")
print(midPoint(start: Point.f2D(2.8, 4.4), end: Point.f2D(3.2, 7.6)) ?? "Not valid")
print(midPoint(start: Point.i2D(2, 4), end: Point.i3D(4, 6, 5)) ?? "Not valid")
print(midPoint(start: Point.f3D(2.1, 4.4, 5.8), end: Point.i3D(4, 6, 5)) ?? "Not valid")
print(type(of: Point.i2D(2, 4)) == type(of: Point.i3D(4, 6, 5)))

// enum Char{  //enum that has no explicit type doesn't have implicit rawValue
enum Char: String{
	case a, b, c, d, e
}
indirect enum RegEx{
	case char(Char)
	case concat(RegEx, RegEx)
	case repeating(RegEx, Int)
	case selection([RegEx])
}
// [abc]
let aORbORc = RegEx.selection([RegEx.char(Char.a), RegEx.char(Char.b), RegEx.char(Char.c)])
// [ed]
let charEorD = RegEx.selection([RegEx.char(Char.e), RegEx.char(Char.d)])
// [abc]{3}
let repeatingAorBorC = RegEx.repeating(aORbORc, 3)
// ab
let ab = RegEx.concat(RegEx.char(Char.a),RegEx.char(Char.b))
// ab[abc]{3}[ed]
let regex = RegEx.concat(ab, RegEx.concat(repeatingAorBorC, charEorD))

//generate all possible strings from RegEx
//return array of string because .selection will results multiple possibilities
func regexToStrings(from regex: RegEx) -> [String]{
	switch regex{
		case .char(let character):
			return [character.rawValue]
		case let .concat(left, right):
			var out = [String]()
			// for each string that get from left side RegEx
			for l in regexToStrings(from: left){
				// for each string that get from right side RegEx
				for r in regexToStrings(from: right){
					out.append(l + r)
				}
			}
			return out
		case let .repeating(regex, count):
			var out = [String]()
			for str in regexToStrings(from: regex){
				out.append(String(repeating: str, count: count))
			}
			return out
		case let .selection(choices):
			var out = [String]()
			for choice in choices{
				for str in regexToStrings(from: choice){
					out.append(str)
				}
			}
			return out
	}
}

// check if input string is in the set of produced strings
func check(string: String, match regex: RegEx) -> Bool{
	return regexToStrings(from: regex).contains(string)
}

var strToCheck = "abccce"
print(regexToStrings(from: regex))
print(strToCheck, check(string: strToCheck, match: regex))
strToCheck = "abcdce"
print(strToCheck, check(string: strToCheck, match: regex))