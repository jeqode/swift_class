// lazy property
var customerQueue = ["Anne", "Brennet", "Clark", "Danial"]
class ServiceProvider{
	lazy var queue = customerQueue
	var log = [String]()
}

var serviceProvider = ServiceProvider()
serviceProvider.log.append("Start serving...")
customerQueue.append("Elizabeth")
print(serviceProvider.queue) //["Anne", "Brennet", "Clark", "Danial", "Elizabeth"]
customerQueue.append("Frank")
print(serviceProvider.queue) //["Anne", "Brennet", "Clark", "Danial", "Elizabeth"]

//computed property
struct Employee{
	var name = String()
	var salaryThb = 25_000.0
	var salaryUsd: Double{
		get{
			print("get salaryUsd")
			return salaryThb * 0.033
		}
		set(newSalary){
			salaryThb = newSalary * 30.3031
			print("set salaryUsd")
		}
		// sorthand
		// set{
		// 	salaryThb = newValue * 30.3031
		// }
	}
}

var johny = Employee(name: "Johny")
print(johny, johny.salaryUsd)
johny.salaryUsd = 900
print(johny, johny.salaryUsd)

// func setSalaryUsd(employee: inout Employee, to newSalary: Double){
// 	print("begin setSalaryUsd()")
// 	employee.salaryUsd = newSalary
// 	print("setSalaryUsd() end")
// }
// setSalaryUsd(employee: &johny, to: 920)
//___________________________________________________________
// begin setSalaryUsd()
// set salaryUsd
// setSalaryUsd() end

func setSalaryUsd(salary: inout Double, to newSalary: Double){
	print("begin setSalaryUsd()")
	salary = newSalary
	print("setSalaryUsd() end")
}
setSalaryUsd(salary: &johny.salaryUsd, to: 920)
//___________________________________________________________
// get salaryUsd
// begin setSalaryUsd()
// setSalaryUsd() end
// set salaryUsd

struct SimpleDate{
	var day: Int
	var month: Int
	var year: Int
}

//const computed property
struct Person{
	var name = String()
	var birthdate = SimpleDate(day: 17, month: 8, year: 1994)
	var age: Int{
		let today = SimpleDate(day: 7, month: 12, year: 2019)
		return today.year - birthdate.year
	}
}

var jason = Person(name: "Jason")
print(jason, jason.age)
// jason.age = 24  //'age' is a get-only property

//property observers
struct Account{
	var name = String()
	var balance = 500.0 {
		// get{
		// 	print("get balance:", balance)
		// 	return balance
		// }
		// set{
		// 	balance = newValue
		// 	print("set balance:", balance)
		// }
		// can't have willSet/didSet with getter & setter
		willSet{
			print("About to set balance to", newValue)
		}
		didSet{
			let transactionAmount = balance - oldValue
			if transactionAmount < 0 {
				print("Withdraw \(-transactionAmount) thb successfully.")
			} 
			else {
				print("Deposit \(transactionAmount) thb successfully.")
			}
			log.append(String(transactionAmount))
		}
	}
	var log = [String]()
}

var johnyAccount = Account(name: "Johny", balance: 8_000)
johnyAccount.balance += 500
johnyAccount.balance -= 1_000
print(johnyAccount.log)

func withdraw(from account: inout Account, amount: Double){
	print("begin withdraw()")
	account.balance -= amount
	print("withdraw() end")
}
withdraw(from: &johnyAccount, amount: 800)
// ___________________________________________________________
// begin withdraw()
// About to set balance to 6700.0
// Withdraw 800.0 thb successfully.
// withdraw() end

// func withdraw(from balance: inout Double, amount: Double){
// 	print("begin withdraw()")
// 	balance -= amount
// 	print("withdraw() end")
// }
// withdraw(from: &johnyAccount.balance, amount: 800)
//___________________________________________________________
// begin withdraw()
// withdraw() end
// About to set balance to 6700.0
// Withdraw 800.0 thb successfully.

// property wrapper
@propertyWrapper
struct ValidDay{
	private var day = 1
	var wrappedValue: Int{
		get{
			day
		}
		set{
			day = max(1, newValue)
			day = min(day, 31)
		}
	}
}

@propertyWrapper
struct ValidMonth{
	private var month = 1
	var wrappedValue: Int{
		get{
			month
		}
		set{
			month = max(1, newValue)
			month = min(month, 12)
		}
	}
}

@propertyWrapper
struct ValidYear{
	private var year = 1800
	var wrappedValue: Int{
		get{
			year
		}
		set{
			year = max(1800, newValue)
			year = min(year, 3000)
		}
	}
}

struct MyDate{
	@ValidDay var day: Int
	@ValidMonth var month: Int
	private var _year = ValidYear()
	var year: Int{
		get{ _year.wrappedValue }
		set{ _year.wrappedValue = newValue }
	}
}

var someDate = MyDate()
someDate.month = 8
someDate.day = 32
someDate.year = 30
print(someDate.day, someDate.month, someDate.year)

enum ProjectedValue: Int{
	case underflow = -1, normal, overflow
}

//init wrapped properties
@propertyWrapper
struct RangedNumber{
	private var number: Int = 0
	private var minimum: Int = Int.min
	private var maximum: Int = Int.max
	var projectedValue = ProjectedValue.normal // can use any types
	var wrappedValue: Int{
		get{ number }
		set{
			// number = min(max(minimum, newValue), maximum)
			//
			if newValue < minimum{
				number = minimum
				projectedValue = .underflow
			}
			else if newValue > maximum{
				number = maximum
				projectedValue = .overflow
			}else{
				number = newValue
				projectedValue = .normal
			}
		}
	}

	init(wrappedValue: Int){
		minimum = Int.min
		maximum = Int.max
		self.wrappedValue = min(max(minimum, wrappedValue), maximum)
	}
	//default args not work
	init(wrappedValue: Int, minimum: Int = -100, maximum: Int = 100){
		self.minimum = minimum
		self.maximum = maximum
		self.wrappedValue = min(max(minimum, wrappedValue), maximum)
	}

	init(wrappedValue: Int, minimum: Int){
		self.minimum = minimum
		maximum = 1_000
		self.wrappedValue = min(max(minimum, wrappedValue), maximum)
	}
}

struct RangedPoint{
	@RangedNumber var x = 2
	@RangedNumber(wrappedValue: 11, minimum: 1, maximum: 10) var y: Int //min = 1, max = 10
	@RangedNumber(minimum: 13) var z = 4  //error no initializer match before declare init(wrappedValue: Int, minimum: Int)
}

var someRangedPoint = RangedPoint()
print(someRangedPoint.x, someRangedPoint.y, someRangedPoint.z)
someRangedPoint.x = -1_254_815 //default min = Int.min, max = Int.max set by init(wrappedValue: Int)
print(someRangedPoint.$x)
someRangedPoint.y = 0
print(someRangedPoint.$y.rawValue)
someRangedPoint.$y = .normal
print(someRangedPoint.$y)
someRangedPoint.z = 20_000
print(someRangedPoint.$z)
print(someRangedPoint.x, someRangedPoint.y, someRangedPoint.z)

// ######!!! Global vars are lazy???
// var z = 5
// func f() -> Int{
// 	print("f()")
// 	return z
// }
// let globalVar = f()
// print("var globalVar")
// z = 7
// print("z = 7")
// print(globalVar)


//Type properties
class Player{
	static let row = 10
	static var col = 10
	//overridable computed property
	class var cellsAmount: Int{//static/class
		get{ row * col }
	}
	var pos = (x: 2, y: 2)

	func move(step: Int){
		pos.x += step
		while pos.x > Player.col{
			pos.y += 1
			pos.x -= Player.col
		}
		if pos.y > Player.row{
			pos.y = Player.row
			pos.x = Player.col - pos.x
		}
	}
}

var player1 = Player()
print(Player.row, Player.cellsAmount)
Player.col = 5
print(Player.col, Player.cellsAmount)
player1.move(step: 5)
print(player1.pos)
player1.move(step: 12)
print(player1.pos)
player1.move(step: 27)
print(player1.pos)