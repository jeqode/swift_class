let thbSalary = [("Jake", 28_000.0), ("Mike", 50_000.0)]

//non-labeled and labeled args
func thbToUsd(_ name: String, income: Double) -> (String, Double){
	return (name, income * 0.033)
}

// pass normal func as a closure arg
print(thbSalary.map(thbToUsd))

// closure expression
let usdSalary = thbSalary.map({(name: String, income: Double) -> (String, Double) in return (name, income * 0.033)})

//inferring types from context
let jpySalary = thbSalary.map({name, income in return (name, income * 3.61) })

//implicit return and shorthand args
let cnySalary = thbSalary.map({($0, $1 * 0.23)})

print(thbSalary, jpySalary, cnySalary, separator: "\n")

var unorderedArray = [5, 8, 2, 4, 9]
//operator method
unorderedArray.sort(by: ==) //order not change
unorderedArray.sort(by: <)
//trainling closure
// unorderedArray.sort{!=} // operator method not works
unorderedArray.sort{$0 != $1} //reverse ___
print(unorderedArray)

var ordinalNum = Array(repeating: "th", count: 10)
ordinalNum[1...3] = ["st", "nd", "rd"]

let dateMonths = [(13, "December"), (2, "January"), (12, "March"), (23, "August")]
let dateStrings = dateMonths.map{ (date, month) -> String in  
	let suffixLetters: String
	if Range(10...20).contains(date){
		suffixLetters = "th"
	} else {
		suffixLetters = ordinalNum[date % 10]
	}
	return month + " " + String(date) + suffixLetters
}
print(dateStrings)

func addInt(_ a: Int, _ b: Int) -> Int{
	a + b
}
func multInt(_ a: Int, _ b: Int) -> Int{
	a * b
}

//Capturing values & escaping

func createIncrementerCreator(by step: Int) -> (@escaping (Int, Int) -> Int) -> () -> Int{
	//no escaping result in error
	func incrementerCreator(method: @escaping (Int, Int) -> Int) -> () -> Int{
		var total = 1
		func incrementer() -> Int{
			total = method(total, step)
			return total
		}
		return incrementer
	}
	return incrementerCreator
}
//escaping must have in param type, return type also var type declaration
let byTwoIncrementerCreator: (@escaping (Int, Int) -> Int) -> () -> Int = createIncrementerCreator(by: 2)
let byThreeIncrementerCreator = createIncrementerCreator(by: 3)
print(type(of:byTwoIncrementerCreator))

let addByTwoIncrementer = byTwoIncrementerCreator(addInt)
print(addByTwoIncrementer())
let mulByTwoIncrementer = byTwoIncrementerCreator(multInt)
print(mulByTwoIncrementer())
print(addByTwoIncrementer())
print(mulByTwoIncrementer())

let addByThreeIncrementer = byThreeIncrementerCreator(addInt)
print(addByThreeIncrementer())

// reference closure
let sameMulByTwoIncrementer = mulByTwoIncrementer
print(sameMulByTwoIncrementer())
var incrementer = mulByTwoIncrementer
print(incrementer())
print(mulByTwoIncrementer())
incrementer = addByThreeIncrementer
print(incrementer())
print(addByThreeIncrementer())

let printHello = {print("hello")}
print(type(of:printHello))
printHello()

func runner(_ job:() -> (), preMsg: String = "__befor running__", postMsg: String = "__after running__"){
	print(preMsg)
	job()
	print(postMsg)
}

var jobSchedule: [() -> ()] = []
var sharedVar = 5
func addNewJob(_ job: @autoclosure @escaping () -> ()){
	jobSchedule.append(job)
}

func addFive(){
	print("\(sharedVar) += 5")
	sharedVar += 5
}

func addEight(){
	print("\(sharedVar) += 8")
	sharedVar += 8
}

addNewJob(addFive())
// addNewJob(addFive) //error add () to forward @autoclosure parameter
print("sharedVar", sharedVar)
addNewJob(addEight())
print("sharedVar", sharedVar)
for job in jobSchedule{
	runner(job)
	print("sharedVar", sharedVar)
}

let salaryDict: Dictionary<String, Double> = ["Jake": 28_000.0, "Mike": 50_000.0]
func defaultValue() -> Double{
	print("calc default value")
	return Double(sharedVar) * 5_000
}
// func value(of dict:[String: Double], forKey key: String, default defaultValue: Double) -> Double{
// 	if let val = dict[key]{
// 		return val
// 	}
// 	else{
// 		return defaultValue
// 	}
// }

// print(value(of: salaryDict, forKey: "Jake", default: defaultValue()))
// print(value(of: salaryDict, forKey: "Jonas", default: defaultValue()))
// **** dafaultValue() is called even there is value for that key

func value(of dict:[String: Double], forKey key: String, default defaultValue: @autoclosure () -> Double) -> Double{
	if let val = dict[key]{
		return val
	}
	else{
		return defaultValue()
	}
}

print(value(of: salaryDict, forKey: "Jake", default: defaultValue()))
print(value(of: salaryDict, forKey: "Jonas", default: defaultValue()))
// **** dafaultValue() is called only when there's no value for that key

print(salaryDict["Jake"] ?? defaultValue())
print(salaryDict["Jonas"] ?? defaultValue())