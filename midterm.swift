// ###### FLAG #####
func unicodeValueFrom(character: Character) -> Int{
	Int(character.unicodeScalars.map{ $0.value }[0])
}

func regionalIndicatorFrom(character: Character) -> Character?{
	let alphabetBase = unicodeValueFrom(character: Character("A"))
	let regionalIndicatorBase = 0x1F1E6
	let offset = regionalIndicatorBase - alphabetBase
	guard character.isLetter else {
		return nil
	}
	let character = character.uppercased()
	let unicodeValue = unicodeValueFrom(character: Character(character)) + offset
	let regionalIndicator = Character(Unicode.Scalar(unicodeValue)!)

	return regionalIndicator
}

func flagFrom(countryCode: String) -> Character?{
	var stringFlag = ""

	for char in countryCode{
		if let regIndicator = regionalIndicatorFrom(character: char){
			stringFlag += String(regIndicator)
			// print(stringFlag)
		}
		else{
			// print("pass", char)
			continue
		}
	}
	guard stringFlag.count == 1 else{
		print(stringFlag.count)
		return nil
	}
	return Character(stringFlag)
}
// ##### END - FLAG #####

// ##### DATA STRUCTURES #####
enum Currency{
	case thb(Double)
	case usd(Double)
	case cny(Double)
	var value: Double{
		get{
			switch self {
			case .thb(let value):
				fallthrough
			case .cny(let value):
				fallthrough
			case .usd(let value):
				return value
			}
		}
		set{
			switch self {
			case .thb:
				self = .thb(newValue)
			case .cny:
				self = .cny(newValue)
			case .usd:
				self = .usd(newValue)
			}
		}
	}
	var code: String{
		switch self {
		case .thb:
			return "THB"
		case .cny:
			return "CNY"
		case .usd:
			return "USD"
		}
	}
	var flag: String{
		String(flagFrom(countryCode: String(self.code.prefix(2)))!)
	}


	static func from(currencyCode: String, value: Double = 0) -> Currency?{
		switch currencyCode {
		case "THB":
			return .thb(value)
		case "CNY":
			return .cny(value)
		case "USD":
			return .usd(value)
		default:
			return nil
		}
	}

	func isSameCurrencyAs(_ other: Currency) -> Bool{
		self.code == other.code
	}

	func isGreaterThan(_ other: Currency) -> Bool{
		assert(self.isSameCurrencyAs(other), "Can't compare difference Currency")
		return self.value > other.value
	}

	func toUSD() -> Currency{
		if self.code == "USD" { return self }
		return Currency.usd(self.value * exchangeRate[self.code]!["USD"]!)
	}

	func exchange(to currencyCode: String) -> Currency?{
		switch currencyCode{
		case "CNY", "THB", "USD":
			if self.code == currencyCode { return self }
			return Currency.from(currencyCode: currencyCode, value: self.value * exchangeRate[self.code]![currencyCode]!)
		default:
			return nil
		}
	}
}

var exchangeRate = ["USD": ["THB": 30.011, "CNY": 7.008], 
										"THB": ["USD": 0.033, "CNY": 0.233], 
										"CNY": ["THB": 4.282, "USD": 0.142]]

typealias Date = (day: Int, month: Int, year: Int)
typealias Time = (hour: Int, minute: Int)
typealias Log = (timestamp: (date: Date, time: Time), message: String)
typealias AccountNumber = String
typealias CustomerID = String
typealias Customer = (name: String, accountNumbers: [AccountNumber])
typealias Account = (balance: Currency, logs: [Log])


var accounts = [AccountNumber: Account]()
var customers = [CustomerID: Customer]()
// ##### END - DATA STRUCTURES #####

let clearScreen = { print("\u{001B}[2J") }
let now = (date: Date(day: 26, month: 12, year: 2019), time: Time(hour: 14, minute: 36))

@discardableResult
func prompt(_ message: String) -> String{
	print(message, terminator: " ")
	return readLine() ?? ""
}

func formatFill(_ string: String, with filler: Character = Character(" "), toLength length: Int = 10, centered: Bool = false) -> String{
	if centered{
		return formatFill(string + String(repeating: filler, count: (length - string.count) / 2), with: filler, toLength: length)
	}
	return String(repeating: filler, count: length - string.count) + string
}

func timestampTextFrom(date: Date, time: Time) -> String{
	let (day, month, year) = date
	let d = formatFill(String(day), with: "0", toLength: 2)
	let m = formatFill(String(month), with: "0", toLength: 2)
	let h = formatFill(String(time.hour), with: "0", toLength: 2)
	let n = formatFill(String(time.minute), with: "0", toLength: 2)
	
	return "\(d)/\(m)/\(String(year)) \(h):\(n)"
}

func find(_ substring: String, in string: String, startFrom startIndex: String.Index? = nil) -> (String.Index, String.Index)?{
	let startIndex = startIndex ?? string.startIndex
	let length = substring.count
	var index = 0
	iterateString:
	for _ in string{
		if index >= string.count - substring.count{ break iterateString }
		let (foundStartIndex, foundEndIndex) = (string.index(startIndex, offsetBy: index), string.index(startIndex, offsetBy: length + index))
		
		if string[foundStartIndex..<foundEndIndex] == substring { return (foundStartIndex, foundEndIndex) }
		index += 1
	}
	return nil
}


func requestExchangeRateAPI(currencyCode: String) -> String?{
	let cny = #"{"usd":{"code":"USD","alphaCode":"USD","numericCode":"840","name":"U.S. Dollar","rate":0.14268460488258,"date":"Wed, 25 Dec 2019 12:00:01 GMT","inverseRate":7.0084645839886},"thb":{"code":"THB","alphaCode":"THB","numericCode":"764","name":"Thai Baht","rate":4.2821999826575,"date":"Wed, 25 Dec 2019 12:00:01 GMT","inverseRate":0.23352482463451}}"#

	let thb = #"{"usd":{"code":"USD","alphaCode":"USD","numericCode":"840","name":"U.S. Dollar","rate":0.03332039733325,"date":"Wed, 25 Dec 2019 12:00:01 GMT","inverseRate":30.011646920012},"cny":{"code":"CNY","alphaCode":"CNY","numericCode":"156","name":"Chinese Yuan","rate":0.23352482463451,"date":"Wed, 25 Dec 2019 12:00:01 GMT","inverseRate":4.2821999826575}}"#
	
	let usd = #""cny":{"code":"CNY","alphaCode":"CNY","numericCode":"156","name":"Chinese Yuan","rate":7.0084645839886,"date":"Wed, 25 Dec 2019 12:00:01 GMT","inverseRate":0.14268460488258},"thb":{"code":"THB","alphaCode":"THB","numericCode":"764","name":"Thai Baht","rate":30.011646920012,"date":"Wed, 25 Dec 2019 12:00:01 GMT","inverseRate":0.03332039733325}"#
	let response = ["CNY": cny, "THB": thb, "USD": usd]

	return response[currencyCode]
}
@discardableResult
func updateExchangeRate() -> Bool{
	for currency in exchangeRate.keys{
		if let response = requestExchangeRateAPI(currencyCode: currency){
			for targetCurrency in exchangeRate.keys{
				if currency == targetCurrency{ continue }
				if let (_, targetCurrencyEnd) = find(targetCurrency.lowercased(), in: response){
					guard let (_, rateEnd) = find(#","rate":"#, in: response, startFrom: targetCurrencyEnd),
								let (startDate, _) = find(#","date":"#, in: response, startFrom: rateEnd) else{ continue }
					if let newRate = Double(response[rateEnd..<startDate]){
						exchangeRate[currency]!.updateValue(newRate, forKey: targetCurrency)
					}
				}
				else{
					return false
				}
			}
		}else{ return false }
	}
	return true
}

// ### Customer & Account
func nextAccountNumber() -> (asInt: Int, formattedString: () -> String){
	enum AccNO{
		static var latest = 0
	}

	AccNO.latest += 1
	let toString: () -> String = {
		let idStr = String(AccNO.latest)
		return formatFill(idStr, with: "0", toLength: 10)
	}

	return (asInt: AccNO.latest, formattedString: toString)
}
func openAccount(balance: Currency) -> AccountNumber{
	let (_, getAccountNumber) = nextAccountNumber()
	var newAccount = Account(balance: balance, logs: [Log]())
	newAccount.logs.append(Log(timestamp: now, message: "Open account with balance: \(balance)"))
	accounts[getAccountNumber()] = newAccount

	return getAccountNumber()
}
func register(id customerID: String, name: String, balance: Currency) -> AccountNumber{
	let accountNumber = openAccount(balance: balance)
	let newCustomer = Customer(name: name, accountNumbers: [accountNumber])
	customers[customerID] = newCustomer
	return accountNumber
}
func statement(accountNumber: AccountNumber) -> String?{
	guard let account = accounts[accountNumber] else{
		print("There is no account associated with this AccNo.")
		return nil
	}
	var out = ""
	for (timestamp, message) in account.logs{
		out += timestampTextFrom(date: timestamp.date, time: timestamp.time) + " : " + message + "\n"
	}
	return out
}

// ### Transactions
@discardableResult
func currencyAdd(_ amount: Currency, to balance: inout Currency) -> Bool{
	if amount.isSameCurrencyAs(balance){
		balance.value = balance.value + amount.value
		return true
	}
	else{
		return false
	}
}
@discardableResult
func currencySubtract(_ amount: Currency, from balance: inout Currency) -> Bool{
	if amount.isGreaterThan(balance){
		return false
	}

	var amount = amount
	amount.value = -amount.value
	return currencyAdd(amount, to: &balance)
}

@discardableResult
func withdraw(_ amount: Currency, from accountNumber: AccountNumber) -> Currency?{
	guard var account = accounts[accountNumber] else{
		print("There is no account associated with this AccNo.")
		return nil
	}

	if currencySubtract(amount, from: &account.balance){
		account.logs.append(Log(timestamp: now, message: "Withdraw \(amount)"))
		accounts[accountNumber] = account
		return account.balance
	}
	else{
		return nil
	}
}
@discardableResult
func deposit(_ amount: Currency, into accountNumber: AccountNumber) -> Currency?{
	guard var account = accounts[accountNumber] else{
		print("There is no account associated with this AccNo.")
		return nil
	}

	if currencyAdd(amount, to: &account.balance){
		account.logs.append(Log(timestamp: now, message: "Deposit \(amount)"))
		accounts[accountNumber] = account
		return account.balance
	}
	else{
		return nil
	}
}
@discardableResult
func transfer(_ amount: Currency, from senderAccNo: AccountNumber, to receiverAccNo: AccountNumber) -> Currency?{
	guard var senderAccount = accounts[senderAccNo] else{
		print("There is no account associated with sender AccNo.")
		return nil
	}
	guard var receiverAccount = accounts[receiverAccNo] else{
		print("There is no account associated with receiver AccNo.")
		return nil
	}

	if currencySubtract(amount, from: &senderAccount.balance){
		let transferAmount = amount.exchange(to: receiverAccount.balance.code)!
		if currencyAdd(transferAmount, to: &receiverAccount.balance){
			senderAccount.logs.append(Log(timestamp: now, message: "Transfered \(amount) to AccNo.\(receiverAccNo)"))
			receiverAccount.logs.append(Log(timestamp: now, message: "Received \(transferAmount) from AccNo.\(senderAccNo)"))
			accounts[senderAccNo] = senderAccount
			accounts[receiverAccNo] = receiverAccount
			return senderAccount.balance
		}
	}
	return nil
}

// #### MENU FUNCTIONS
func inputCurrency() -> Currency{
	var currency: Currency?
	while(currency == nil){
		let currencyCode = prompt("Currency <THB:\(Currency.thb(0).flag), USD:\(Currency.usd(0).flag), CNY:\(Currency.cny(0).flag)>: ")
		currency = Currency.from(currencyCode: currencyCode)
	}
	currency!.value = max(Double(prompt("Amount: ")) ?? 0, 0)
	return currency!
}
func openAccountMenu(){
	let id = prompt("Customer ID no.: ")
	if let customer = customers[id]{
		print("Customer exist for id \(id): \(customer.name)")
		for account in customer.accountNumbers{
			print("  Acc no. \(account)")
		}
		let key = prompt("Open new account (y/n)?")
		if key.uppercased() == "Y"{
			print("Initial Deposit:")
			let balance = inputCurrency()
			let newAccountNO = openAccount(balance: balance)
			print("Open account no.\(newAccountNO) with \(balance) successfully.")
			prompt("\nEnter to go back.")
		}
	}
	else{
		let customerName = prompt("Name: ")
		print("Initial Deposit:")
		let balance = inputCurrency()
		let newAccountNO = register(id: id, name: customerName, balance: balance)
		print("Open account no.\(newAccountNO) with \(balance) successfully.")
		prompt("\nEnter to go back.")
	}
}
func searchAccountMenu(){
	print("searchAccount")
}
func closeAccountMenu(){
	print("closeAccount")
}
func depositMenu(){
	var accountNumber = ""
	inputAccNo:
	while(true){
		accountNumber = prompt("Deposit into account no.:")
		if accountNumber == "q" { return }
		if accounts.keys.contains(accountNumber){ break inputAccNo }
		print("Invalid account no. input again or \"q\" to go back")
	}
	let account = accounts[accountNumber]!
	let balance = Currency.from(currencyCode: account.balance.code, value: Double(prompt("Amount(\(account.balance)):")) ?? 0.0)!
	if let newBalance = deposit(balance, into: accountNumber){
		print("Deposit \(balance) into account no.\(accountNumber) successfully. balance: \(newBalance)")
	} else { print("Something went wrong!") }
	prompt("\nEnter to go back.")
}
func withdrawMenu(){
	var accountNumber = ""
	inputAccNo:
	while(true){
		accountNumber = prompt("Withdraw from account no.:")
		if accountNumber == "q" { return }
		if accounts.keys.contains(accountNumber){ break inputAccNo }
		print("Invalid account no. input again or \"q\" to go back")
	}
	let account = accounts[accountNumber]!
	let balance = Currency.from(currencyCode: account.balance.code, value: Double(prompt("Amount(\(account.balance)):")) ?? 0.0)!
	if let newBalance = withdraw(balance, from: accountNumber){
		print("Withdraw \(balance) from account no.\(accountNumber) successfully. balance: \(newBalance)")
	} else { print("Something went wrong!") }
	prompt("\nEnter to go back.")
}
func transferMenu(){
	var senderAccNo = ""
	var receiverAccNo = ""
	while(true){
		senderAccNo = prompt("Transfer from account no.:")
		if senderAccNo == "q" { return }
		if accounts.keys.contains(senderAccNo){ break }
		print("Invalid account no. input again or \"q\" to go back")
	}
	while(true){
		receiverAccNo = prompt("To account no.:")
		if receiverAccNo == "q" { return }
		if accounts.keys.contains(receiverAccNo){ break }
		print("Invalid account no. input again or \"q\" to go back")
	}
	let account = accounts[senderAccNo]!
	let balance = Currency.from(currencyCode: account.balance.code, value: Double(prompt("Amount(\(account.balance)):")) ?? 0.0)!
	if let newBalance = transfer(balance, from: senderAccNo, to: receiverAccNo){
		print("Transfer \(balance) from account no.\(senderAccNo) to account no.\(receiverAccNo) successfully. balance: \(newBalance)")
	} else { print("Something went wrong!") }
	prompt("\nEnter to go back.")
}
func statementMenu(){
	var accountNumber = ""
	inputAccNo:
	while(true){
		accountNumber = prompt("Account no.:")
		if accountNumber == "q" { return }
		if accounts.keys.contains(accountNumber){ break inputAccNo }
		print("Invalid account no. input again or \"q\" to go back")
	}
	if let statements = statement(accountNumber: accountNumber){
		print(statements)
	}else{ print("-") }
	
	prompt("\nEnter to go back")
}
// ##### Menu #####
enum Menu{
	case item(String, @autoclosure () -> ())
	case submenu(String, [Menu])

	static var currentMenu: Menu!
	@discardableResult
	static func select(_ index: Int) -> Bool{
		if Range(1...currentMenu.menuList.count).contains(index){
			currentMenu = currentMenu.menuList[index - 1]
			return true
		}
		else{
			return false
		}
	}

	var menuList: [Menu]{
		switch self{
		case .item:
			return []
		case let .submenu(_, submenuList):
			return submenuList
		}
	}

	func toString() -> String{
		switch self{
		case let .item(name, _):
			fallthrough
		case let .submenu(name, _):
			return name
		}
	}
	func run(){
		switch self{
		case let .item(_, menuFunction):
			menuFunction()
		case .submenu:
			break
		}
	}
}

func displayMenu(_ menus: [Menu], screenWidth: Int){
	for (key, menu) in menus.enumerated(){
		print(" " + String(key + 1) + ". " + menu.toString())
	}
	print("\n0. Exit")
	print(String(repeating: "-", count: screenWidth))
}

// 	case calcInterestRate
// 	case calcMaintenanceFee

let accountSubMenu = Menu.submenu("Account Menu", [
	Menu.item("Open Account", openAccountMenu()),
	Menu.item("Statement", statementMenu())
	// Menu.item("Search Account", searchAccountMenu)
	// Menu.item("Close Account", closeAccountMenu)
])

let mainMenu = Menu.submenu("Main menu", [
	Menu.item("Deposit", depositMenu()),
	Menu.item("Withdraw", withdrawMenu()),
	Menu.item("Transfer", transferMenu()),
	accountSubMenu,
	Menu.item("Exchange Rate", {
		exchangeRate.forEach({ (key, rates) in
			print("\(key):")
			for (curr, rate) in rates{
				print("  \(curr): \(rate)")
			}
		})
		prompt("Enter to go back")
		}())
])
Menu.currentMenu = mainMenu
// ##### END - Menu #####

var johnDoe = Customer("Mr. John Doe", [])
var account = Account(.thb(23_000), logs: [])
accounts["9999999999"] = account
johnDoe.accountNumbers.append("9999999999")
account = Account(.usd(2_350), logs: [Log(timestamp: now, message: "test1")])
account.logs.append(Log(timestamp: now, message: "test2"))
accounts["9999999998"] = account
johnDoe.accountNumbers.append("9999999998")
customers["1409901193553"] = johnDoe

func main(title: String, screenWidth: Int = 40){
	var response = 9
	while(response != 0){
		clearScreen()
		print(String(repeating: "#", count: screenWidth))
		print(formatFill(title, with: " ", toLength: screenWidth, centered: true))
		print(String(repeating: "#", count: screenWidth))
		print("\n\(Menu.currentMenu.toString())")
		print(String(repeating: "-", count: screenWidth))
		if !Menu.currentMenu.menuList.isEmpty{
			displayMenu(Menu.currentMenu.menuList, screenWidth: screenWidth)
			response = Int(prompt("Select: ")) ?? 9
			Menu.select(response)
		}
		else{
			Menu.currentMenu.run()
			Menu.currentMenu = mainMenu
		}
	}
}
main(title: "SIAM NATIONAL BANK", screenWidth: 80)