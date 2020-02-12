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
	var weekDay: WeekDay

	init(_ day: Int, _ month: Month, _ year: Int, weekDay: WeekDay){
		self.day = day
		self.month = month
		self.year = year
		self.weekDay = weekDay
	}
	init(_ day: Int, _ month: Int, _ year: Int, weekDay: WeekDay){
		self.init(day, Month(rawValue: min(max(1, month), 12))!, year, weekDay: weekDay)
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

//Refering to Nested Types
let valentineDay = Date(14, 2, 2020, weekDay: .fri)
let laborDay = Date(1, Date.Month.may, 2020, weekDay: .fri) // Month.may is unresolved must define full path
print(Date.WeekDay.sun.rawValue, Date.WeekDay.sun)

print(valentineDay.toString(format: .numeric))
print(laborDay.toString(format: Date.Format.text))