class Account{
	var name: String
	var email: String

	init(name: String, email: String){
		self.name = name
		self.email = email
	}
}

class Customer: Account{
	var point = 0
}

class Employee: Account{
	var salary: Double
	init(name: String, email: String, salary: Double){
		self.salary = salary
		super.init(name: name, email: email)
	}
}

let marry = Customer(name: "Marry", email: "marry01@mail.com")
let jason = Employee(name: "Jason", email: "jasonv@mail.com", salary: 18_000)

var accounts = [marry, jason]
marry.point += 101

// Type Checking with `is`
for account in accounts{
	print(type(of: account))
	if account is Customer{
		// print(account.name, "is a Customer with", account.point, "point(s)") // it's an Account not Customer can't access point
		print(account.name, "is a Customer")
	} else if account is Employee{
		print(account.name, "is an Employee")
	}

	//to access subclass props and methods use Downcasting
	if let customer = account as? Customer{
		print(customer.name, "is a Customer with", customer.point, "point(s)")
	} else {
		let employee = account as! Employee // downcasting with force-unwrap (!)
		print(employee.name, "is an Employee with salary:", employee.salary)
	}
}
// accounts.append(50) // error: cannot convert Int to Account

var anyThings = [Any]()
anyThings.append(marry)
anyThings.append(Customer(name:"Somsri", email: "somsri428@mail.com"))
anyThings.append(jason)
anyThings.append(50)
anyThings.append(50_000)
anyThings.append("word")
anyThings.append("Debitis fuga officiis nostrum ea.")
anyThings.append({(_ a: Int, _ b: Int) -> Int in a + b})
anyThings.append(25.32)

for item in anyThings{
	if item is Account{
	// if let object = item as? AnyObject{ // always true Any can be casted to AnyObject (is AnyObject also)
		switch item {
		case let customer as Customer where customer.point > 80:
			print(customer.name, "is a Customer with many points")
		case is Customer:
			print("a Customer")
		default:
			print("other Account")
		}
	}else{
		switch item{
		case ...100 as Int:
			print("small integer")
		case let number as Int where number > 10_000:
			print("big integer")
		case is Int:
			print("integer")
		case let string as String where string.count > 10:
			print("sentence")
		case is String:
			print("short string")
		case let intAdder as (Int, Int) -> Int:
			print("5 + 8 =", intAdder(5, 8))
		default:
			print("any")
		}
	}
}