let multilineString = """
Dolores quod totam commodi dignissimos culpa ut.
Laborum nisi et id.
Libero rerum aut necessitatibus et.
"""

let indentTextAndQoute = """
	Dolores quod totam commodi dignissimos culpa ut.
	Laborum nisi et id.
	Libero rerum aut necessitatibus et.
	"""

let indentTextNotQoute = """
	Dolores quod totam commodi dignissimos culpa ut.
	Laborum nisi et id.
	Libero rerum aut necessitatibus et.
"""

let threeIndentTextNotQoute = 
"""
			Dolores quod totam commodi dignissimos culpa ut.
			Laborum nisi et id.
			Libero rerum aut necessitatibus et.
		"""

print(multilineString == indentTextAndQoute)
print(indentTextAndQoute == indentTextNotQoute)
print(indentTextNotQoute == threeIndentTextNotQoute)

let veryLongLine = """
	Ipsa illum incidunt sed. \
	Ullam est et eligendi aut. \
	Est ut nesciunt nihil. \
	Officiis consequatur corrupti in amet provident et. \
	Exercitationem nisi vero et sapiente quo.
	"""
print("==================", terminator:"")
print(veryLongLine, terminator:"")
print("==================")

let multilineWithLineBreak = """

	Dolores quod totam commodi dignissimos culpa ut.
	Laborum nisi et id.

	Libero rerum aut necessitatibus et.

	"""
/*
"""
	Libero rerum aut 
necessitatibus et. #insufficient indent
	"""
*/
print("==================", terminator:"")
print(multilineWithLineBreak, terminator:"")
print("==================")

let thaiFlag = "\u{1F1F9}\u{1F1ED}"
print(type(of: thaiFlag), thaiFlag, thaiFlag.count, thaiFlag.unicodeScalars.count) //🇹🇭

var greeting = "Welcome to Thailand "
greeting += thaiFlag
greeting.append("!")
print(greeting)

print("greeting is \(greeting.count) characters long")
for char in greeting
{
	print(char, terminator:",")
}
print(#"\#n\#u{1F1F9}\#u{1F1ED} is consist of unicode \u{1F1F9} and \u{1F1ED}"#)

let aUmlaut = "\u{00E4}"
let compositedAUmlaut = "\u{0061}\u{0308}"
print("aUmlaut: \(aUmlaut), count/scalar: \(aUmlaut.count)/\(aUmlaut.unicodeScalars.count)")
print("compositedAUmlaut: \(compositedAUmlaut), count/scalar: \(compositedAUmlaut.count)/\(compositedAUmlaut.unicodeScalars.count)")
print("aUmlaut == compositedAUmlaut?: ", aUmlaut == compositedAUmlaut)

var germanGirls = "Madchen"
germanGirls.insert("\u{0308}", at:germanGirls.index(germanGirls.startIndex, offsetBy:2))// ̈
print(germanGirls.startIndex, germanGirls.endIndex, type(of:germanGirls.startIndex))
print(germanGirls.index(before:germanGirls.endIndex))

for i in 0..<germanGirls.count
{
	let index = germanGirls.index(germanGirls.startIndex, offsetBy:i)
	print(germanGirls[index], index)
}
print("endIndex", germanGirls.endIndex)
// M Index(_rawBits: 1) 66304
// ä Index(_rawBits: 66305) 196096
// d Index(_rawBits: 262401) 65536
// c Index(_rawBits: 327937) 65536
// h Index(_rawBits: 393473) 65536
// e Index(_rawBits: 459009) 65536
// n Index(_rawBits: 524545) 65280
// endIndex Index(_rawBits: 589825) 

let umlautGermanGirls = "M" + aUmlaut + "dchen"
print(germanGirls == umlautGermanGirls) //true

var girlsInGerman = "Girls are  in german"
girlsInGerman.insert(contentsOf:"Madchen", at:girlsInGerman.index(girlsInGerman.startIndex, offsetBy: 10))
print(girlsInGerman)
let range = girlsInGerman.index(girlsInGerman.startIndex, offsetBy: 10)..<girlsInGerman.index(girlsInGerman.endIndex, offsetBy: -10)
print(girlsInGerman[range])
var madchen = girlsInGerman[range]
for i in 0..<girlsInGerman.count
{
	let index = girlsInGerman.index(girlsInGerman.startIndex, offsetBy:i)
	print(girlsInGerman[index], index)
}
print("rawBits in substring are the same as in original string")
for i in 0..<madchen.count
{
	let index = madchen.index(madchen.startIndex, offsetBy:i)
	print(madchen[index], index)
}
// rawBits in substring are the same as in original string

// madchen = umlautGermanGirls  #cannot assign string to substring
let umlautGermanGirlsSubstr = umlautGermanGirls[..<umlautGermanGirls.endIndex]
var madchenSubstr = umlautGermanGirlsSubstr
madchenSubstr.append("?")
for i in 0..<madchenSubstr.count
{
	let index = madchenSubstr.index(madchenSubstr.startIndex, offsetBy:i)
	print(madchenSubstr[index], index)
}
print(girlsInGerman)
// rawBits are changed but does not affect original string
girlsInGerman.insert("\u{0308}", at:madchen.index(madchen.startIndex, offsetBy: 2))
print(girlsInGerman)
//substring's index can be used to manipulate original string

let vocabs = [
	"Boy: Junge - \u{1F1E9}\u{1F1EA}",
	"Boy: เด็กผู้ชาย - \u{1F1F9}\u{1F1ED}",
	"Girl: Mädchen - 🇩🇪",
	"Girl: เด็กผู้หญิง - \u{1F1F9}\u{1F1ED}",
	"Children: Kinder - \u{1F1E9}\u{1F1EA}",
	"Children: เด็กๆ - \u{1F1F9}\u{1F1ED}",
]
print("German words")
for word in vocabs
{
	if word.hasSuffix("\u{1F1E9}\u{1F1EA}")
	{
		print(word)
	}
}
print("Boy in Thai & German")
for word in vocabs
{
	if word.hasPrefix("Boy")
	{
		print(word)
	}
}

for code in umlautGermanGirls.utf8
{
	print(type(of:code), code, UnicodeScalar(code), separator:":", terminator:" ")
}
print("")
for code in umlautGermanGirls.utf16
{
	print(type(of:code), code, UnicodeScalar(code), separator:":", terminator:" ")
}
print("")
for scalar in umlautGermanGirls.unicodeScalars
{
	print(type(of:scalar), scalar.value, UnicodeScalar(scalar), separator:":", terminator:" ")//UnicodeScalar(scalar) or just `scalar`
}
print("")
/*
	UnicodeScalar() - with uint8, unicodeScalar passed return unicodeScalar
	- with other type return optional (nil if invalid value was passed)
*/

for code in aUmlaut.utf8
{
	print(code, terminator: " ")
}
print("")
for code in compositedAUmlaut.utf8
{
	print(code, terminator: " ")
}
print("")