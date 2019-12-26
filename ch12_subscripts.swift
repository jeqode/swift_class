struct Fibonacci{
	static var values = [1: 1, 2: 1, 3: 2]
	var multiplier = 1
	//subscript get & set
	subscript(index: Int) -> Int{
		get{
			assert(index > 0, "Index underflow!")
			if let value = Fibonacci.values[index]{
				return value * multiplier
			}else{
				Fibonacci.values[index] = self[index - 2] + self[index - 1]
				return self[index] * multiplier
			}
		}
		set{
			assert(index > 0, "Index underflow!")
			Fibonacci.values[index] = newValue / multiplier
		}
	}

	// subscript using variadic param
	subscript(indexs: Int...) -> [Int]{
		var out = [Int]()
		for index in indexs{
			out.append(self[index])
		}
		return out
	}
}

var fibonacci = Fibonacci()
print(fibonacci[3])
print(fibonacci[5])
print(fibonacci[2, 5, 6, 8])
print(Fibonacci.values.keys.sorted().map{ "\($0): \(Fibonacci.values[$0]!)" })
// print(fibonacci[-1]) //assert error


var doubleFibonacci = Fibonacci(multiplier: 2)
print(doubleFibonacci[3])
doubleFibonacci[6] = 16
print(Fibonacci.values.keys.sorted().map{ "\($0): \(Fibonacci.values[$0]!)" })

//type subscript & subscript options
enum Month: Int{
	case jan = 1, feb, mar, apr, may, jun, jul, aug, sep, oct, nov, dec
	static subscript(index: Int) -> Month{
		return Month(rawValue: min(max(1, index), 12))!
	}

	static subscript(name: String) -> Month{
		let monthNames = "january,febuary,march,april,may,june,july,august,september,october,november,december".split(separator: ",")
		// if let index = monthNames.firstIndex(where: { $0.hasPrefix(name.lowercased()) }){
		// 	return Month[index + 1]
		// }else{
		// 	fatalError("Invalid month")
		// }
		
		guard let index = monthNames.firstIndex(where: { $0.hasPrefix(name.lowercased()) }) else {
			fatalError("Invalid month name")
		}
		return Month[index + 1]
	}
}

var someMonth = Month[8]
print(someMonth)
// someMonth = Month[name: "mar"] //cant use label
someMonth = Month["mar"]
print(someMonth)
someMonth = Month["DECember"]
// someMonth = Month["sunday"] // Invalid month name
print(someMonth)

struct Multiplier{
	var multiplier = 2
	static subscript(multiplier: Int) -> Multiplier{
		return Multiplier(multiplier: multiplier)
	}

	subscript(operand: Int) -> Int{
		return operand * multiplier
	}
	subscript(operand: String) -> String{
		return String(repeating: operand, count: multiplier)
	}
	subscript(operand1: Int, operand2: Int) -> Int{
		return operand1 * operand2 * multiplier
	}
	subscript(operand1: Int, operands: Int...) -> [Int]{
		var out = [operand1 * multiplier]
		for operand in operands{
			out.append(operand * multiplier)
		}
		return out
	}
}

let double = Multiplier[2]
print(double[5])
print(double["choo "])

let triple = Multiplier[3]
print(triple["echo "])
print(triple[3, 4]) //call subscript(operand1: Int, operand2: Int)
print(triple[3, 4, 5])