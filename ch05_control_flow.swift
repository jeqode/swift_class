// var timesTable: [[Int]] #cannot insert by subscription, have to be init first
var timesTable = Array(repeating: Array(repeating: 0, count: 13), count: 13)
for i in 9...12{
	for ii in 2...12{
		timesTable[i][ii] = i * ii
	}
}

var multTable = [Int: [Int: Int]]()
for i in 9...12{
	multTable[i] = [Int: Int]()
	for ii in 2...12{
		multTable[i]![ii] = i * ii
	}
}

// for (multiplicant, exp) in multTable{
// 	for (multiplier, result) in exp{
// result not sorted, have to call sorted()
for multiplicant in multTable.keys.sorted(){
	for multiplier in multTable[multiplicant]!.keys.sorted(){
		print(multiplicant, "*", multiplier, "=", multTable[multiplicant]![multiplier]!)
	}
}

let dogs = ["Diggie": ("Husky", 2), "Suzanne": ("Chihuahua", 1.2), "Tommy": ("Bulldog", 3)]
print(type(of:dogs)) //Dictionary<String, (String, Double)>
for (name, (breed, _)) in dogs{ //ignore age
	print(name, "is a", breed)
}

var schedule = ["0930": (("COS2101", "Procedural Programming"), "SCL204"),
								"1130": (("COS2102", "Object-Oriented Programming"), "SCL211/2"),
								"1530": (("COS3105", "Operating Systems"), "SCL205")]
//stride(from: 9, to: 15, by: 2) //not include 15
for time in stride(from: 9, through: 15, by: 2){
	let hour = "0" + String(time)
	let timeText = String(hour.suffix(2) + "30")
	if let `class` = schedule[timeText]{
		print(timeText, `class`.0.0, `class`.1)
	}
}
// decompose all values at once
for (time, ((subjCode, subjName), room)) in schedule{
	print(time, subjCode, subjName, room)
}

var playAgain = "y"
repeat{
	var over = false
	var score = 0
	while !over{
		let firstNum = Int.random(in: 2...255)
		let secondNum = Int.random(in: 2...12)
		print(firstNum, "*", secondNum, "=", terminator: " ")
		if let input = Int(readLine()!){
			if input == firstNum * secondNum{
				score += 5
				print("correct!")
			}
			else{
				over = true
			}
		}
	}
	print("total score:", score)
	print("play again? y/n : ", terminator: "")
	playAgain = readLine()!
}while playAgain == "y"

//###Switch case
var op = "+"
let operand1 = 8
let operand2 = 5
switch op{
	case "+":
		print(operand1 + operand2)
	case "-","+": // + fall to the first case and not doing this :warning
		print(operand1 - operand2)
	case "*", "/":
		print("not support * and / yet")
	//with no default :error switch must be exhaustive
	default:
		print("invalid operator")
}

let freeTaxRange = ..<25_000
let incomeAndAllowance = (30_000, 5_000)
switch incomeAndAllowance{
	case (freeTaxRange, _):
		print("You don't have to pay tax")
	case let (income, allowance) where income < 50_000:
		var tax = Double(income) * 0.1 - Double(allowance)
		tax = tax > 0 ? tax : 0
		print("Tax(10%) - allowance =", tax)
	case (let income, _):
		print("Tax(20%) = ", Double(income) * 0.2)
}

//###Control Transfer Statements
//continue
var matrix = [[4, 5, 9],
							[2, 8, 7],
							[3, 1, 6]]
for row in 0..<3{
	for col in 0..<3{
		if row == col{
			continue
		}
		matrix[row][col] = 0
	}
}
for row in matrix{
	print(row)
}

//break in loop
let array = [21, 23, 45, 56, 13, 12]
let find = 15
var index = 0
while index < array.count{
	if array[index] == find{
		break
	}
	index += 1
}
if index == array.count{
	print("\(find) is not found")
}
else{
	print("\(find) is found at index \(index)")
}


/* break in switch & break label
 ↶a  b   ↶b  a   ↶a,b
[1]---->[2]-----[[3]]
*/

var state = 1
checking:
while state != 3{
	let input = readLine()!
	switch state{
		case 1:
			switch input{
				case "a":
					break
				case "b":
					state = 2
				default:
					break checking
			}
		case 2:
			switch input{
				case "a":
					state = 3
				case "b":
					break
				default:
					break checking
			}
		default:
			break
	}
}
print(state == 3 ? "accept" : "not accept")

let countDownFrom = 10
switch countDownFrom{
	// default:
	// 	fallthrough //case block cannot follow default block
	case 7...:
		print("too long. Let's start with 5")
		fallthrough
	case 6:
		fallthrough
	case 5:
		print("5...")
		fallthrough
	case 4:
		print("4...")
		fallthrough
	case 3:
		print("3...")
		fallthrough
	case 2:
		print("2...")
		fallthrough
	case 1:
		print("1...")
	default:
		print("invalid")
		// fallthrough //there's no case to fallthrough
}

//early exit guard
func find(_ item:Int, in list:[Int]) -> Int?{
	guard list.count > 0 else{
		print("early exit")
		return nil //must have return or trow
	}
	var index = 0
	while index < list.count{
		if list[index] == item{
			return index
		}
		index += 1
	}
	return nil
}
print(find(15, in:array) ?? "not found")