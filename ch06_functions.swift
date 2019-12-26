func returnNothing(){
	print("This is function that return nothing")
}
func returnEmptyTuple() -> (){
	return ()
}
print(returnNothing()) // () empty tuple
print(returnEmptyTuple())
print(returnNothing() == returnEmptyTuple())
print(returnNothing)

// argument label, multiple return values, return optional tuple
var array = [21, 23, 45, 56, 13, 12]
func findMax(in list:[Int]) -> (max: Int, position: Int)?{
	guard list.count > 0 else{
		return nil
	}
	var maxPosition = 0
	for i in 1..<list.count{
		if list[i] > list[maxPosition]{
			maxPosition = i
		}
	}
	return (list[maxPosition], maxPosition)
}
if let (max, pos) = findMax(in:array){
	print("Max is \(max) at index \(pos)")
}

// func double(_ items: inout Int..., times:Int = 2){ //inout cannot use on variadic
// func double(_ item: Int, times:Int = 2){ //cant mutate item
func double(_ item: inout Int, times:Int = 2){
	item *= times
}

func getDoubles(_ items: Int..., times: Int = 2) -> [Int]{
	var res: [Int] = []
	for item in items{
		res.append(item * times)
	}
	return res
}

print(getDoubles(2, 3, 5, 8, times:3))

var (a, b, c) = (5, 8, 3)
double(&a) //inout must prefix with &
double(&b, times: 4)
// double(times: 5, &c) //error argument order is matter
print(a, b, c)

func append(_ items: Int..., into list: inout [Int]){
	for item in items{
		list.append(item)
	}
}

append(91, 92, 93, 99, into: &array)
print(array)

//function type, function as return type, nested fuction
func chooseOperation(operatorChar:Character) -> (Int, Int) -> Int{
	//implicit return
	// func addInt(_ a: Int, _ b: Int){ // cannot covert return type Int -> ()
	func addInt(_ a: Int, _ b: Int) -> Int{
		a + b
	}
	func multInt(_ a: Int, _ b: Int) -> Int{
		a * b
	}
	func subInt(_ a: Int, _ b: Int) -> Int{
		a - b
	}
	switch operatorChar{
		case "+":
			return addInt
		case "-":
			return subInt
		case "*":
			return multInt
		default:
			// return {(_ a:Int, _ b:Int) -> Int in print("not support"); 0} //only works when there's only one expression
			return {(_ a:Int, _ b:Int) -> Int in print("not support"); return 0}
	}
}

var operate = chooseOperation(operatorChar: "+")
print(operate(8, 5))
// print(operate(&8, 5)) //error cannot use & with non-inout

//function as parameter type
func whichOperator(operation: (Int, Int) -> Int, operand1:Int, operand2:Int) -> (){
	switch operation(operand1, operand2){
		case operand1 + operand2:
			print("a + b")
		case operand1 - operand2:
			print("a - b")
		case operand1 * operand2:
			print("a * b")
		default:
			break
	}
	// no need to return
}
whichOperator(operation: operate, operand1:8, operand2:5)

// func cross(a: Int..., operation: (Int, Int) -> Int, b: Int...) -> [Int]{ //can only have 1 variadic param
func cross(a: Int..., operation: (Int, Int) -> Int, b: Int) -> [Int]{ //variadic arg can also be labeled
	var res: [Int] = []
	for i in a{
		res.append(operation(i, b))
	}
	return res
}

print(cross(a: 4, 2, operation:operate, b: 3))