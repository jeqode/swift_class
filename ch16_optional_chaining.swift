struct FullName{
	var firstName: String
	var lastName: String
	var middleName: String?

	func display(){
		print("\(firstName) \(middleName ?? "") \(lastName)")
	}
}

class Account{
	var name: FullName
	var email: String
	var password: String
	var tel: String?

	init(name: FullName, email: String, password: String, tel: String){
		self.name = name
		self.email = email
		self.password = password
		self.tel = tel
	}
}

class Customer: Account{
	var point: Int = 0
	var orders: [Order]? {
		let list = Order.list.filter{$0.customer === self}
		if list.count > 0 {
			return list
		} else{
			return nil
		}
	}
}

class Staff: Account{
	var position: String
	var commission = 0.0

	init(name: FullName, email: String, password: String, position: String, tel: String){
		self.position = position
		super.init(name: name, email: email, password: password, tel: tel)
	}

	func getSalary(salaryList: [String: Double]) -> Double?{
		if let salary = salaryList[self.position]{
			return salary
		}else{
			return nil
		}
	}
}

class Order{
	var customer: Customer
	var items = [String]()
	var seller: Staff?
	var total = 0.0
	static var list = [Order]()

	init(customer: Customer, items: String..., seller: Staff? = nil, total: Double){
		self.customer = customer
		for item in items{
			self.items.append(item)
		}
		self.seller = seller
		self.total = total
		Order.list.append(self)
	}
}

var customerJason = Customer(name: FullName(firstName: "Jason", lastName: "Ja"), email: "jason03@mail.com", password: "Rw6A0TWjzEMf2NJ", tel: "0801602924")

var staffJohn = Staff(name: FullName(firstName: "John", lastName: "Doe", middleName: "Will"), email: "johndoe@mail.com", password: "TkmtRGGEVNjH66N",position: "sale", tel: "0874928570")
var staffMarry = Staff(name: FullName(firstName: "Marry", lastName: "Smith"), email: "marryss@mail.com", password: "uCkNqm1NDjPqgpr",position: "sale", tel: "0698745216")

if let fistLetterOfMiddleName = customerJason.name.middleName?.first{
	print("1st letter:", fistLetterOfMiddleName)
}else{
	print("Can't get 1st letter off middle name.")
}

if let fistLetterOfMiddleName = staffJohn.name.middleName?.first{
	print("1st letter:", fistLetterOfMiddleName)
}else{
	print("Can't get 1st letter off middle name.")
}

var newOrder = Order(customer: customerJason, items: "mousepad", "ssd 500GB", seller: staffJohn, total: 12000)

//Calling Methods Through Optional Chaining
customerJason.orders?.first?.seller?.name.display()
newOrder = Order(customer: customerJason, items: "toothbrush", "wine", total: 1800)
newOrder = Order(customer: customerJason, items: "mousepad", "flashdrive", seller: staffMarry, total: 900)
customerJason.orders?.forEach{print($0.total)}

// Accessing Subscripts Through Optional Chaining
customerJason.orders?[1].seller?.name.display() // do nothing
// customerJason.orders[1].seller!.name.display() // error: force unwrap nil

customerJason.orders?.first?.seller?.name.middleName = {print("set middle name"); return "Well"}()
staffJohn.name.display()
customerJason.orders?[1].seller?.name.middleName = {print("set middle name"); return "Will"}() // func was not called
staffMarry.name.display()

// optional doesn't stacking up
print(type(of:customerJason.orders?.first?.seller?.name)) // Optional<FullName>
// print(type(of:customerJason.orders?.first?.seller?.name!)) // error: unwrap non-optional
print(type(of:(customerJason.orders?.first?.seller?.name)!)) // FullName
print(type(of:customerJason.orders?.first?.seller?.name.middleName)) // Optional<String>
print(staffJohn.name.middleName as Any) // Optional("Will")

// Chaining on Methods with Optional Return Values
var salaryList: [String: Double] = ["sale": 18_000.32, "manager": 30_000, "packing": 15_000, "social admin": 20_000]
if let salary = staffJohn.getSalary(salaryList: salaryList)?.rounded(){
	print(salary)
}else{
	print("invalid position")
}

let notStaff = Staff(name: FullName(firstName: "John", lastName: "Doe", middleName: "Will"), email: "johndoe@mail.com", password: "TkmtRGGEVNjH66N",position: "nothing", tel: "0874928570")
if let salary = notStaff.getSalary(salaryList: salaryList)?.rounded(){
	print(salary)
}else{
	print("invalid position")
}