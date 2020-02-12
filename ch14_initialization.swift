import Foundation
// ##### stored prop MUST have value by the time it is created
struct Date{
	var day: Int
	var month: Int = 1 // default value
	var year = 2000
}
// let date = Date() //error missing `day`
let date = Date(day: 2) //provide value through memberwise init

// struct Date{
// 	var day: Int
// 	var month: Int = 1
// 	var year = 2000

// 	init(){
// 		day = 1 //provide value in init
							//if it always takes the same value, it should be provided as default value
// 	}
// }
// let date = Date()
// let date = Date(day: 2) //there's a custom init, there's no memberwise init

class People{
	var name: String? //optional with default nil
	var age = 18
	let national: String
	// let national = "TH" // cant change value afterward

	init(){ // default initializer
		national = "TH" // assign const during init
	}
	init(_ name: String, age: Int = 18, national: String = "TH"){ //init with defualt params
		self.name = name
		self.age = age
		self.national = national
	}
	func describe(){
		print(name ?? "Noname", age, national)
	}
}
let someone = People() // init with no param
someone.describe()
let somchai = People("Somchai", age: 42) // omitting arg label
somchai.describe()

struct Point{
	var x = 0.0, y = 0.0
	init(){}
	init(_ x:Double, _ y: Double){
		self.x = x
		self.y = y
	}

	init(_ x: Int, _ y: Int){
		self.init(Double(x), Double(y))
	}
}

//init delegation
struct Rectangle{
	var width = 0.0, height = 0.0
	var centroid = Point()

	init(){}
	init(_ width: Double, _ height: Double, centeredAt centroid: Point){
		self.width = width
		self.height = height
		self.centroid = centroid
	}
	init(bottomLeftPoint: Point, upperRightPoint: Point){
		self.init(upperRightPoint.x - bottomLeftPoint.x, upperRightPoint.y - bottomLeftPoint.y,
			centeredAt: Point((upperRightPoint.x + bottomLeftPoint.x) / 2, (upperRightPoint.y + bottomLeftPoint.y) / 2))
	}

	func describe(){
		print(width, "x", height, "centeredAt", centroid as Any)
	}
}
let rect = Rectangle(20, 30, centeredAt:Point(10, 10))
rect.describe()
let anotherRect = Rectangle(bottomLeftPoint: Point(2, 4), upperRightPoint: Point(92, 44))
anotherRect.describe()

// class Shape{
// 	var centroid = Point()
// 	convenience init(x: Double, y: Double){
// 		centroid = Point(x, y)
// 	}
// } ### must have atleast one designated init

// class Shape{
// 	var centroid = Point()
// 	init(){}
// 	init(centroid: Point){
// 		self.centroid = centroid
// 	}
// 	convenience init(x: Double, y: Double){  ### self.init isn't called
// 		centroid = Point(x, y) 								 ### self is used before init call
// 	}
// } ## all convenience inits must ultimately call designated init

class Shape{
	var centroid = Point()
	var description: String{
		"shape centered at Point(\(centroid.x), \(centroid.y))"
	}
	init(){
		// self.centroid = Point(3, 4)
	}
	init(centeredAt centroid: Point){
		self.centroid = centroid
	}
	convenience init(x: Double, y: Double){
		self.init(centeredAt: Point(x, y))
	}
}

class Circle:Shape{
	var radius: Double
	//override keyword is needed
	// override init(){} // error super.init isn't called
	override var description: String{
		"\(radius) unit(s) radius circle " + super.description
	}
	override init(){
		radius = 1
		super.init()
		// radius = 1 // error: radius is not inited at super.init call --^ move up
	}
	init(radius: Double){
		self.radius = radius
		// self.enlarge(times: 2) // error: cannot call method before init(1st phase)
		// print(self.description) // error: cannot use property before init(1st phase)
		// print(self.radius) // valid
		// self.centroid = Point(1, 2) // can't access before calling super.init
		super.init()
		// super.init(x: 2, y: 2) //error: must call super's designated init
	}
	// convenience init(radius: Double, centeredAt centroid: Point){
	// 	self.radius = radius
	// 	// super.init(x: centroid.x, y: centroid.y) //error: must delegate to self.init not chainning to super.init
	// }
	convenience init(radius: Double, centeredAt centroid: Point){
		// self.centroid = centroid // use self before calling init
		self.init(radius: radius)
		self.centroid = centroid
	}

	func enlarge(times: Double){
		radius = radius * times
	}
}

let circle = Circle()
print(circle.description)
let smallCircle = Circle(radius: 2)
print(smallCircle.description)
let bigCircleAtFiveFive = Circle(radius: 10, centeredAt: Point(5, 5))
print(bigCircleAtFiveFive.description)
bigCircleAtFiveFive.enlarge(times: 2)
print(bigCircleAtFiveFive.description)

// class Cylinder: Circle{
// 	var height = 1.0
// 	override var description: String{
// 		"\(height) unit(s) height " + super.description.replacingOccurrences(of: "circle", with: "cylinder")
// 	}
// }
// let cylinder = Cylinder() //inherited default init
// print(cylinder.description)
// let largeCylinder = Cylinder(radius: 40) //inherited from Circle.init(radius)
// print(largeCylinder.description) 
// let smallCylinderAtFiveFive = Cylinder(radius: 2, centeredAt: Point(5, 5)) //inherited convenience init
// print(smallCylinderAtFiveFive.description)
// //automaticaly inherits when subclass has no custom init

class Cylinder: Circle{
	var height = 1.0
	override var description: String{
		"\(height) unit(s) height " + super.description.replacingOccurrences(of: "circle", with: "cylinder")
	}
	override init(){ super.init() }
	override convenience init(radius: Double){ // override desg as conv
		self.init()
		self.radius = radius
	}
	init(height: Double){
		self.height = height
		super.init() // omitting cause error (?)
		// super.init(radius: 5, centeredAt: Point(3,3)) // error: must call a designated init
	}
}

let tallCylinder = Cylinder(height: 20)
print(tallCylinder.description)
let shortFiveRadiusCylinderAtFiveFive = Cylinder(radius: 5, centeredAt: Point(5, 5)) //auto inherited conv init 'cause all super's desgn init have been overriden
print(shortFiveRadiusCylinderAtFiveFive.description)

// Failable init
enum WeekDay: Int{
	case sun, mon, tue, wed, thu, fri, sat
	init?(abbrv: String){ // failable init for enum
		switch abbrv{
		case "sun":
			self = .sun
		case "mon":
			self = .mon
		case "tue":
			self = .tue
		case "wed":
			self = .wed
		case "thu":
			self = .thu
		case "fri":
			self = .fri
		case "sat":
			self = .sat
		default:
			return nil
		}
	}
}

if let monday = WeekDay(abbrv: "mon"){
	print(monday)
}else{
	print("There's no day with provided abbrv")
}
if let someDay = WeekDay(abbrv: "tfr"){
	print(someDay)
}else{
	print("There's no day with provided abbrv")
}
if let lastDayOfTheWeek = WeekDay(rawValue: 6){ // failable init with rawValue
	print(lastDayOfTheWeek)
}

class ServiceScheduler{
	var service: ()->()
	var interval: Int
	required init(){
		self.service = {print("Do nothing")}
		self.interval = 60
	}
	init?(service: @autoclosure @escaping ()->(), interval: Int){
		print("ServiceScheduler init...")
		if interval <= 0{
			print("failed at ServiceScheduler")
			return nil 
		}
		self.interval = interval
		self.service = service
	}
}

if let greetingService = ServiceScheduler(service: print("Hello!"), interval: 3600){
	greetingService.service()
}

class NamedServiceScheduler: ServiceScheduler{
	var name: String = "Unnamed"
	required init(){ super.init() } // error: if not provide required init
	init?(name: String, service: @autoclosure @escaping ()->(), interval: Int){
		print("NamedServiceScheduler init...")
		if name.isEmpty {
			print("failed at NamedServiceScheduler")
			return nil
		}
		super.init(service: service(), interval: interval)
		print("...NamedServiceScheduler init")
	}

	override init(service: @autoclosure @escaping ()->(), interval: Int){ // override failable to non-failable
		super.init(service: service(), interval: max(1, interval))!
	}

	init!(name: String, printingText: String, interval: Int){ // implicitly unwrap failable
		self.name = name
		super.init(service: print(printingText), interval: max(1, interval))!
	}
}
// fail propagation
let emptyNameService = NamedServiceScheduler(name: "", service: print("Do something"), interval: 360)
let minusIntervalService = NamedServiceScheduler(name: "Say hi", service: print("Hi there!"), interval: -10)
let anotherGreetingService = NamedServiceScheduler(name: "Say hello", service: print("Hello!"), interval: 360)
print(anotherGreetingService as Any)

let morningGreetingService = NamedServiceScheduler(service: print("Good morning"), interval: -60)
morningGreetingService.service()

// let printingService = NamedServiceScheduler(name: "Print name", printingText: "Nattapong Siribal", interval: 0)
// print(printingService) // optional
// printingService?.service()
let printingService: NamedServiceScheduler = NamedServiceScheduler(name: "Print name", printingText: "Nattapong Siribal", interval: 0)
print(printingService)
printingService.service()

class SnakeGame{
	static var board = (width: 10, height: 10)
	var snake: [Point] = { // setting defult prop val with a closure
		let (x, y) = (Int.random(in: 0..<SnakeGame.board.width), Int.random(in: 0..<SnakeGame.board.height))
		return [Point(x, y), Point(x - 1, y), Point(x - 2, y)]
	}()
}
let snakeGame = SnakeGame()
print(snakeGame.snake)