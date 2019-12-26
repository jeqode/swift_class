//assignment & arithmatic ops
let (breed, age) = ("Pitbull", 4)
print(breed, age)
// let (a1, b1, c1) = (1, 2) //;error 
// let (a2, b2) = (1, 2, 3)  //;different number of elements
var result = 5 + 2 * 3 + 8 / 2
// print(result++) //;not support
print(result += 1) // assignment return nothing
print(result)
var someText :String
someText = "Hello " + "Swift" //concatenate
print(someText)

//modulo
let remainder = 24 % 13
print(remainder)

//unary plus & minus op
let negNumber = -2
let sameNumber = +negNumber
let posNumber = -negNumber
print(negNumber, sameNumber, posNumber)


//comparision & logical ops
print((1, "zebra") < (10, "ant"))
print((10, "zebra") >= (10, "ant"))
print((3, "cat") != (3, "cat"))
// print((2, "meow") == ("meow", 2)) //error compare different types
let hotFood = true
let spicyFood = true
var hotWeather = false
if hotWeather && (spicyFood || hotFood)
{
	print("I NEED WATER!")
}
else if !hotWeather
{
	print("I'm fine")
}

//ternary condition & nil-coalescing
let otHour = 10
var salary = 20_000 + (otHour > 0 ? otHour * 100 : 0)
print(salary)

let otString = Int("800")
let ot = otString ?? 0
salary = 20_000 + ot
// salary = 20_000 + otString ?? 0 //error
print(salary)

//Range
for i in 1...4 //cannot be minus/float
{
	print(i, terminator:" ")
}
print("")
for i in 1..<4
{
	print(i, terminator:" ")
}
print("")
let animals = ["ant", "bird", "cat", "dog"]
for i in 0..<animals.count
{
	print(animals[i])
}
// for animal in animals[3...1] //upperBound cant < lowerBound
for animal in animals[1...2]
{
	print(animal)
}

var range = 1...
print(range) //PartialRangeFrom<Int>(lowerBound: 1)
print(range.contains(900_000_999))