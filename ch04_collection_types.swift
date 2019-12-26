// let arrayOfTupleOfIntAndString :[(Int, String)] = [(2, "a"),(3,"b"), ("a", 5)] //#error type
// let arrayWithDefaultValues = [(2, "a"),(3,"b"), ("a", 5)]
// print(type(of:arrayWithDefaultValues)) //error: heterogeneous collection must be typed to [Any]
let arrayOfTupleOfAnyAndAny :[(Any, Any)] = [(2, "a"),(3,"b"), ("a", 5)]
print(arrayOfTupleOfAnyAndAny)

var emptyArrayOfDouble = [Double]() //call initializer
print(type(of:emptyArrayOfDouble), emptyArrayOfDouble)

var arrayOfInt = [3]
print(type(of:arrayOfInt)) //context typed as Array<Int>
arrayOfInt = []
// arrayOfInt.append(3.2) //so we cant append Double to arrayOfInt
print(arrayOfInt)

var shoppingList = ["eggs", "milk", "sugar"]
// var shoppingCart = [] //error empty array must define type
var shoppingCart = [String]()
if shoppingList.isEmpty
{
	print("there is nothing to shop")
}
else 
{
	for (index, item) in shoppingList.enumerated()
	{
		print(index + 1, item)
	}
}
shoppingList.append("banana") // ["eggs", "milk", "sugar", "banana"]
// shoppingList.insert("cucumber", at: 10) //cant insert out of range
// var putBackItem = shoppingCart.remove(at: 0) //trying to remove an empty list - error index out of range
// var putBackItem = shoppingCart.removeFirst() //also cant remove from empty list

if !shoppingList.isEmpty // checking to avoid error
{
	let whatToBuyNext = shoppingList.remove(at: 0)
	shoppingCart.append(whatToBuyNext)
	print("getting \(whatToBuyNext) into shopping cart")
	print("Cart:", shoppingCart)
	print("Shopping list:", shoppingList)
}
shoppingList += ["butter", "palm oil"]
shoppingList[4] = "olive oil" // change from "palm oil" to "olive oil"
print(shoppingList)
shoppingList[1...2] = ["apple", "orange", "chocolate"]
print(shoppingList)
print("There're still \(shoppingList.count) item(s) to buy")
shoppingList.append("chocolate")
print(shoppingList) // end up with 2 chocolates in the list

//let use set to avoid duplicate entry
var shoppingListSet = Set(shoppingList)
var cartSet = Set<String>()
print(shoppingListSet) // the duplicated chocolate is gone
// print(shoppingListSet[0]) // error cant subscript with Int
print(shoppingListSet[shoppingListSet.startIndex])
if shoppingListSet.contains("wine")
{
	let wine = shoppingListSet.remove("wine")
	print(type(of:wine))
	print("let buy wine")
}
else
{
	print("Wine is not on the shopping list")
}

if let itemToBuy = shoppingListSet.remove("butter")
{
	cartSet.insert(itemToBuy)
	print("Cart:", cartSet)
	print("Shopping list:", shoppingListSet)
}
else
{
	print("No need to buy butter")
}

var momShoppingList: Set = ["olive oil", "eggs", "banana", "milk", "hair dryer"]
var dadShoppingList: Set = ["beer", "chicken", "banana", "milk", "shaving cream"]
let allList = momShoppingList.union(dadShoppingList) 
let momAndDadList = momShoppingList.intersection(dadShoppingList)
print("All:", allList)
print("Mom & Dad:", momAndDadList)
print("Mom not Dad:", momShoppingList.subtracting(dadShoppingList))
print("Mom or Dad but not both:", momShoppingList.symmetricDifference(dadShoppingList))
momShoppingList.insert("eggs")
print(momShoppingList)
print(momAndDadList.isSubset(of: momShoppingList)) //true
print(allList.isSuperset(of: dadShoppingList)) //true
print(momShoppingList.isDisjoint(with: dadShoppingList)) //false

let aUmlaut = "\u{00E4}"
let compositedAUmlaut = "\u{0061}\u{0308}"
momShoppingList.insert(aUmlaut)
momShoppingList.insert(compositedAUmlaut)
print(momShoppingList) // treats as the same (==)

typealias itemWithAmount = [String: Int]
var shopListWithAmount = ["milk": 2, "eggs": 12, "apple": 6]
var cartWithAmount = [itemWithAmount]()
print(type(of: cartWithAmount))
shopListWithAmount["banana"] = 4
print(shopListWithAmount)
shopListWithAmount["banana"] = 10
print(shopListWithAmount)
// print(shopListWithAmount["strawberry"]) // nil
if let strawberryAmount = shopListWithAmount["strawberry"]
{
	print(strawberryAmount)
}
else
{
	print("There's no strawberry on the list.")
}
if let oldAmountOfMilk = shopListWithAmount.updateValue(8, forKey: "milk")
{
	print("Change from \(oldAmountOfMilk) to 8 amount of milk")
}
else
{
	print("Add 8 milk to the list")
}
shopListWithAmount["strawberry"] = nil // nothing happen
shopListWithAmount["milk"] = nil
print(shopListWithAmount)

if let oldAmountOfMilk = shopListWithAmount.updateValue(8, forKey: "milk")
{
	print("Change from \(oldAmountOfMilk) to 8 amount of milk")
}
else
{
	print("Add 8 milk to the list")
}

if let removedAmount = shopListWithAmount.removeValue(forKey: "banana")
{
	print("\(removedAmount) banana have been removed")
}
else
{
	print("There're no banana to be removed")
}

(shopListWithAmount["lemon"], shopListWithAmount["tuna"], shopListWithAmount["bread"]) = (6, 2, 3)

for (item, amount) in shopListWithAmount
{
	print(amount, "of", item)
}

for item in shopListWithAmount.keys.sorted()
{
	print(item, ":", shopListWithAmount[item]!)
}