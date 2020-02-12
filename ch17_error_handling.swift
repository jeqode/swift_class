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
	var currency: String{
		switch self {
		case .thb:
			return "THB"
		case .cny:
			return "CNY"
		case .usd:
			return "USD"
		}
	}
}

enum BankingError: Error{
	case mismatchCurrency(String, String),
	insufficientBalance(Double),
	invalidAccountNumber
}

enum OtherError: Error{
	case otherError
}

class Account{
	let number: String
	var name: String
	var balance: Currency
	static var list = [Account]()

	init(number: String, name: String, balance: Currency){
		self.number = number
		self.name = name
		self.balance = balance
		Account.list.append(self)
	}
	static subscript(accountNumber: String) -> Account?{
		Account.list.first(where:{$0.number == accountNumber})
	}

	// Propagating Errors Using Throwing Functions
	func transfer(_ amount: Currency, toAccountNumber transfereeAccountNumber: String) throws {
		guard self.balance.currency == amount.currency else {
			throw BankingError.mismatchCurrency(self.balance.currency, amount.currency)
		}
		guard amount.value <= self.balance.value else{
			throw BankingError.insufficientBalance(amount.value - self.balance.value)
		}
		guard let transferee = Account[transfereeAccountNumber] else{
			throw BankingError.invalidAccountNumber
		}
		self.balance.value -= amount.value
		transferee.balance.value += amount.value
	}
}

let jasonAccount = Account(number: "001", name: "Jason", balance: Currency.thb(20_000))
let marryAccount = Account(number: "002", name: "Mary", balance: Currency.thb(18_000))
try jasonAccount.transfer(.thb(300), toAccountNumber: "002") //calling throwing func must be marked with `try`
print(jasonAccount.balance, marryAccount.balance)
// try jasonAccount.transfer(.thb(300), toAccountNumber: "000") // error: Error raised at top level

// handle error throwed from account.transfer() by throwing error up
func transfering( _ amount: Currency, fromAccountNumber transferorAccountNumber: String, toAccountNumber transfereeAccountNumber: String) throws {
	if transferorAccountNumber == "999" { throw OtherError.otherError }
	guard let transferor = Account[transferorAccountNumber] else{
		throw BankingError.invalidAccountNumber
	}
	try transferor.transfer(amount, toAccountNumber: transfereeAccountNumber)
}

// Handling Errors Using Do-Catch
do{
	// try transfering(.cny(20), fromAccountNumber: "001", toAccountNumber: "002") // error trying to transfer CNY from THB account
	// try transfering(.thb(20_500), fromAccountNumber: "001", toAccountNumber: "002") // insufficient amount: 800.0
	// try transfering(.thb(20), fromAccountNumber: "001", toAccountNumber: "00") // banking error
	try transfering(.thb(20), fromAccountNumber: "999", toAccountNumber: "002") // unexpected error: otherError
} catch BankingError.insufficientBalance(let insufficientAmount){
	print("insufficient amount:", insufficientAmount)
} catch let BankingError.mismatchCurrency(accountCurrency, transferCurrency){
	print("error trying to transfer \(transferCurrency) from \(accountCurrency) account")
} catch is BankingError{
	print("banking error")
} catch{
	print("unexpected error:", error)
}

class Transaction{
	let thisAccount: Account
	let otherAccount: Account?
	let amount: Currency
	let message: String
	static var list = [Transaction]()

	// throwing initializer
	init(transfer amount: Currency, fromAccountNumber transferorAccountNumber: String, toAccountNumber transfereeAccountNumber: String) throws {
		try transfering(amount, fromAccountNumber: transferorAccountNumber, toAccountNumber: transfereeAccountNumber)
		self.thisAccount = Account[transferorAccountNumber]!
		self.otherAccount = Account[transfereeAccountNumber]!
		self.amount = amount
		self.message = "transfer"
		Transaction.list.append(self)
	}
}

// func addTransaction(){
// 	let transaction = try Transaction(transfer: .cny(20), fromAccountNumber: "001", toAccountNumber: "002")
// 	print(transaction.message)
// } // error: errors thrown from here are not handled \non-throw func must handles all errors inside func

// Converting Errors to Optional Values
var transaction = try? Transaction(transfer: .cny(20), fromAccountNumber: "001", toAccountNumber: "002")
print(transaction as Any) // nil
transaction = try? Transaction(transfer: .thb(20), fromAccountNumber: "001", toAccountNumber: "002")
print(transaction?.message as Any, transaction?.amount as Any)

// throwing func that return
func getBalance(ofAccountNumber accountNumber: String) throws -> Currency{
	guard let account = Account[accountNumber] else{
		throw BankingError.invalidAccountNumber
	}
	return account.balance
}

let marryAccountBalance = try? getBalance(ofAccountNumber: "002")
print(marryAccountBalance as Any)

// Disabling Error Propagation
let jasonAccountBalance = try! getBalance(ofAccountNumber: jasonAccount.number)
print(jasonAccountBalance as Any)

// Cleanup Actions
func doSomethingWithDefer(error: Bool = false) throws {
	print("func...")
	print(" statement#1")
	defer{
		// reverse order?
		print(" defer#1")
		print(" defer#2")
		// return // error: cannot return out of defer
	}
	print(" statement#2")

	if error {
		print(" error")
		throw OtherError.otherError
	}
	print(" statement#3")
	print("...func")
}

try doSomethingWithDefer()
// Disabling Error Propagation
try? doSomethingWithDefer(error: true)