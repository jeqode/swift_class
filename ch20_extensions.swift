struct Date{
	enum Month: Int{
		case jan = 1, feb, mar, apr, may, jun, jul, aug, sep, oct, nov, dec
		var text: String{
			"\(self)"
		}
	}
	enum WeekDay: Int{
		case sun = 1, mon, tue, wed, thu, fri, sat
		var text: String{
			"\(self)"
		}
	}
	enum Format{
		case numeric, text
	}
	var day: Int
	var month: Month
	var year: Int
	var weekDay: WeekDay?

	init(_ day: Int, _ month: Month, _ year: Int, weekDay: WeekDay?){
		self.day = day
		self.month = month
		self.year = year
		self.weekDay = weekDay
	}
	init(_ day: Int, _ month: Int, _ year: Int, weekDay: WeekDay){
		self.init(day, Month(rawValue: min(max(1, month), 12))!, year, weekDay: weekDay)
	}
	init(_ day: Int, _ month: Int, _ year: Int){
		self.init(day, Month(rawValue: min(max(1, month), 12))!, year, weekDay: nil)
	}

	func toString(format: Format) -> String{
		switch format {
		case .numeric:
			return (day < 10 ? "0" + String(day) : String(day)) + "/" + (month.rawValue < 10 ? "0" + String(month.rawValue) : String(month.rawValue)) + "/" + String(year)
		default:
			return "\(month) \(day), \(year)"
		}
	}
}

let valentineDay = Date(14, 2, 2020, weekDay: .fri)
let laborDay = Date(1, Date.Month.may, 2020, weekDay: .fri)

// extends to add computed props
extension Int{
	var pct: Double{ Double(self) / 100 }
	var isLeapYear: Bool{
		(self % 4 == 0 && self % 100 != 0) || self % 400 == 0
	}
}
print(32.pct, 300 * 12.pct)
print(2020.isLeapYear, 2100.isLeapYear, 2400.isLeapYear)

extension Double{
	var floor: Int{
		Int(self.rounded(.towardZero))
	}
}
print(23.4.floor, 38.76.floor)

// Extends to add init
extension String{
	init(_ date: Date, format: Date.Format = .numeric){
		self.init(date.toString(format: format))
	}
}
print(String(valentineDay), String(valentineDay, format: .text))

extension Date{
	init(_ day: Int, _ month: Month, _ year: Int){
		self.init(day, month, year, weekDay: nil)
	}
	init?(_ string: String){
		let date = string.split(separator: "/").map{ Int($0) ?? nil }
		guard let d = date[0], let m = date[1], let y = date[2] else {
			return nil
		}
		self.init(d, m, y)
	}
}
if let someDate = Date("10/02/2020"){
	print(String(someDate, format: .text))
}
if let someDate = Date("10ss2020"){
	print(String(someDate, format: .text))
}else{
	print("invalid format")
}

// Extends to add method
extension Date.Month{ //Extend Nested type
	func getNumberOfDays(year: Int) -> Int{
		switch self{
		case .jan, .mar, .may, .jul, .aug, .oct, .dec:
			return 31
		case .apr, .jun, .sep, .nov:
			return 30
		case .feb:
			return year.isLeapYear ? 29 : 28
		}
	}
}
print(Date.Month.mar.getNumberOfDays(year: 2020), 
			Date.Month.feb.getNumberOfDays(year: 2020),  
			Date.Month.feb.getNumberOfDays(year: 2021))

extension Date{
	func nextDay() -> Date{
		var d = self.day + 1
		var m = self.month
		var y = self.year
		let weekDay = WeekDay(rawValue: self.weekDay?.rawValue != nil ? (self.weekDay?.rawValue)! + 1 : 9)
		if d > m.getNumberOfDays(year: year){
			d = 1
			if m.rawValue + 1 > 12{
				m = Month(rawValue: 1)!
				y += 1
			}else{
				m = Month(rawValue: m.rawValue + 1)!
			}
		}
		return Date(d, m, y, weekDay: weekDay)
	}
	// add mutating method
	mutating func toNextDay(){
		self = self.nextDay()
	}
	// add subscription
	subscript(part: String) -> Any?{
		switch part{
		case "d", "day":
			return self.day
		case "m", "month":
			return self.month
		case "y", "year":
			return self.year
		default:
			return nil
		}
	}
}
print(String(valentineDay.nextDay()))
if let day = valentineDay["day"]{
	print(day)
}

// Extends to conform to Protocol
extension Date: Equatable, Comparable{
	static func == (lhs: Date, rhs: Date) -> Bool{
		(lhs.day, lhs.month.rawValue, lhs.year) == (rhs.day, rhs.month.rawValue, rhs.year)
	}
	static func < (lhs: Date, rhs: Date) -> Bool{
		if lhs.year != rhs.year{
			return lhs.year < rhs.year
		} else if lhs.month.rawValue != rhs.month.rawValue{
			return lhs.month.rawValue < rhs.month.rawValue
		} else{
			return lhs.day < rhs.day
		}
	}
	static func > (lhs: Date, rhs: Date) -> Bool{
		rhs < lhs
	}
	// var storedProp = 0 // error: cannot extend stored prop
}
print(valentineDay == laborDay, valentineDay == Date("14/02/2020"))


// Extend to add Nested type
extension Date{
	enum Zodiac: Int{
		case aries = 0x2648, taurus, gemini, cancer, leo, virgo, libra, scorpio, sagittarius, capricorn, aquarius, pisces
	}

	var zodiac: Zodiac{
		switch self{
		case let date where date > Date(14, .apr, self.year):
			switch date{
			case let date where date < Date(16, .may, self.year):
				return .aries
			case let date where date < Date(16, .jun, self.year):
				return .taurus
			case let date where date < Date(16, .jul, self.year):
				return .gemini
			case let date where date < Date(16, .aug, self.year):
				return .cancer
			case let date where date < Date(16, .sep, self.year):
				return .leo
			case let date where date < Date(16, .oct, self.year):
				return .virgo
			case let date where date < Date(17, .nov, self.year):
				return .libra
			case let date where date < Date(16, .dec, self.year):
				return .scorpio
			default:
				return .sagittarius
			}
		default:
			switch self{
			case let date where date < Date(15, .jan, self.year):
				return .sagittarius
			case let date where date < Date(15, .feb, self.year):
			 return .capricorn
			case let date where date < Date(15, .mar, self.year):
				return .aquarius
			default:
				return .pisces
			} 
		}

	}
}

if let myBirthdate = Date("17/08/1994"){
	print(myBirthdate.zodiac, Unicode.Scalar(myBirthdate.zodiac.rawValue)!)	
}
print("aquarius: ", Unicode.Scalar(Date.Zodiac.aquarius.rawValue)!)