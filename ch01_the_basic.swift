// #####Variable & Constant definition__Data types
let constIntVar :Int = 2
// constIntVar = 5 ;error variable defined by `let` is constant and immutable

let constFltVar :Float
constFltVar = 10.2
print(constFltVar)

let pointTwoFive = 0.25
print(type(of:pointTwoFive)) //Double : default type for decimal number
let intNumber = 5
print(type(of:intNumber)) //;Int

var someText :String = "Hi"
print("someText:", someText)
someText += " there!" //str + str => concatenate
print("modified someText:", someText)

//### variable name
let จำนวนเต็มบวก  :UInt16 = 10
print("จำนวนเต็มบวก", type(of:จำนวนเต็มบวก), จำนวนเต็มบวก, separator:": ")
let `var` = true //; use reserved word as variable name
print("`var`", type(of:`var`), `var`, separator:": ")
let `notReservedWord` = "also can use `__`"; print("`notReservedWord`", `notReservedWord`, separator:": ")
// ;(semicolon) is optional, can use to seperate inst on the same line

print("\nInteger bounds")
print("Int: \(Int.min) to \(Int.max)") //;equal to Int64
print("Int8: \(Int8.min) to \(Int8.max)")
print("Int16: \(Int16.min) to \(Int16.max)")
print("Int32: \(Int32.min) to \(Int32.max)")
print("Int64: \(Int64.min) to \(Int64.max)")
print("UInt8: \(UInt8.min) to \(UInt8.max)")
print("UInt16: \(UInt16.min) to \(UInt16.max)")
print("UInt32: \(UInt32.min) to \(UInt32.max)")
print("UInt64: \(UInt64.min) to \(UInt64.max)")

//#### Type convertion
let pi = 3.14159
let two = 2
// let pi = 3.141592 ; error
// let two = 2.0     ; cant redeclare
var piPlusTwo = pi + 2  //literal is not typed until evaluated
// piPlusTwo = pi + two  ;error
// var twoPi = pi * two  ;type mismatch
var twoPi = pi * Double(two)
// let pi :Float = 3.14159
// piPlusTwo = pi + Double(two)
// -- error Float and Double cannot operate
print(piPlusTwo, twoPi)

//### Number literals
let zeroLeadingDecInteger = 00012
let binInteger = 0b1100
let octInteger = 0o14
let hexInteger = 0x0C
print(zeroLeadingDecInteger, binInteger, octInteger, hexInteger, separator:" = ")

let zeroleadingDouble = 00027.5
let expDouble = 02.75e1
let expHexDouble = 0xD.Cp1 // 13.75 * 2^1
let separatedDouble = 1_000.001_1_0 // _ not affect value not neccessary to be meaningful
print(zeroleadingDouble, expDouble, expHexDouble, separatedDouble)

//##### Tuple
let thisDog = ("Shih Tzu", 3)
print(thisDog.0, thisDog.1) //tuple access with tuple.index
// print(thisDog[0], thisDog[1]) ;cant access with subscript[]

// let breed, age = thisDog ;error () is needed
let (breed, _) = thisDog // ignore age use _
print(breed)

let dogs = [(breed: "Shih Tzu", age: 4), (breed: "Boxer", age: 2)]
print(type(of:dogs))
for dog in dogs
{
	print(dog.breed, dog.age, separator: ", ", terminator: ".\n")
	/*tuple acess with tuple.keyname
	var in string*/
	print("breed: \(dog.breed), age: \(dog.age)")
}

//##### Type aliases
typealias dog = (breed: String, age: Int)
let mumu :dog = ("bulldog", 2)
let diggie :dog
diggie.breed = "Poodle"
diggie.age = 4
print(type(of:mumu))
print(mumu)
print(diggie)


//##### Optional
var numberString = "123"
var convertedInteger = Int(numberString)
var assumeInteger :Int! = Int(numberString)
var implicitOptInteger :Int = assumeInteger
print("convertedInteger", convertedInteger) // warning: expression implicitly coerced from 'Int?' to 'Any'
print("implicitOptInteger", implicitOptInteger)
if convertedInteger != nil
{
	print("convertedInteger: ", convertedInteger!)
}
print("convertedInteger: ", convertedInteger ?? "cannot convert to integer")

if let actualValue = Int(numberString)
{
	print("actualValue", actualValue)
}

// var actualValue :Int?
// if actualValue = Int(numberString)  ;cannot use = in boolean context
if var actualValue = Int(numberString)
{
	print("actualValue", actualValue)
}

numberString = "NaN"
convertedInteger = Int(numberString)
print("convertedInteger", convertedInteger) // nil , warning
//print(convertedInteger!) ; error unwrap nil
print(convertedInteger ?? "cannot convert to integer") // print default value

// assumeInteger = Int(numberString)
// implicitOptInteger = assumeInteger  //; error unwrap
var optionalStringDefault :String?
print(optionalStringDefault) // nil, warning
// let nilInt :Int = nil ;error nil cannot assign to non-optional

//##### Assert & Precondition

var divisor = 2
assert(divisor != 0, "cannot divided by zero")
precondition(divisor != 0, "cannot divided by zero")
print("20 / \(divisor) =", 20 / divisor)

// divisor = 0
// assert(divisor != 0, "cannot divided by zero") //;Assertion failed
// precondition(divisor != 0, "cannot divided by zero") //;Precondition faile
// print("20 / \(divisor) =", 20 / divisor)
// 

divisor = 22
if divisor > 20
{
	divisor = 20
	print("divisor cannot exceed 20, 20 / \(divisor) =", 20 / divisor)
}
else if divisor != 0
{
	print("20 / \(divisor) =", 20 / divisor)
}else{
	assertionFailure("cannot divided by zero")  // divisor = 0 fatal error
}