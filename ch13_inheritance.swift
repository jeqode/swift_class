enum Direction{
	case left, right, up, down
}

struct Point{
	var x = 0.0
	var y = 0.0
}

class Shape{
	var centroid = Point(x: 0, y: 0)

	func describe(){
		print("I'm a shape")
	}
	// preventing override
	final func move(_ direction: Direction, by distance: Int){
		switch direction {
		case .left:
			centroid.x -= Double(distance)
		case .right:
			centroid.x += Double(distance)
		case .up:
			centroid.y += Double(distance)
		case .down:
			centroid.y -= Double(distance)
		}
	}
}

class Rectangle: Shape{
	var width = 2
	var height: Int = 2{
		willSet{
			print("will set height to \(newValue)")
		}
		didSet{
			print("just set Rectangle height from \(oldValue) to \(height)")
		}
	}
	var area: Int{
		width * height
	}

	// func describe(){ //error needs override keyword
	override func describe(){
		//access parent class method
		super.describe()
		print("a Rectangle at \(centroid)")
	}
}

class Cubic: Rectangle{
	// var width = 3 // cant someCubic.width = override stored prop (with or without `override`)
	override var height: Int{ //can't have initial value
		didSet{
			print("Cubic height has been changed from \(oldValue) to \(height)")
		}
	}
	var length = 4
	// override property getter
	override var area: Int{
		(length * width * 2) + (length * height * 2) + (super.area * 2) // use superclass method
	}
	var volume: Int{
		length * width * height
	}
	override func describe(){
		print("I'm a Cubic shape at \(centroid)")
	}
	// override func move(_ direction: Direction, by distance: Int){ } // cannot override final method
}

var someRectangle = Rectangle()
someRectangle.describe()
someRectangle.width = 5
someRectangle.height = 3
print(someRectangle.area)

var someCubic = Cubic()
someCubic.describe()
someCubic.height = 3
someCubic.width = 4
someCubic.move(.right, by: 4)
someCubic.move(.up, by: 6)
someCubic.describe()
print(someCubic.width, someCubic.length, someCubic.height)
print(someCubic.area, someCubic.volume)

class Circle: Shape{
	var radius = 1.0
	final var diameter: Double{
		get{ radius * 2 }
		set{ radius = newValue / 2 }
	}
	var area: Double{
		Double.pi * radius * radius
	}
}

class Sphere: Circle{
	var height = 1.0
	var volume: Double{
		area * height
	}

	// override var diameter: Double{ 0 } // cant override final
}

var thisCircle = Circle()
thisCircle.move(.up, by: 3)
thisCircle.move(.right, by: 2)
print(thisCircle.diameter)
thisCircle.diameter = 12
print(thisCircle.radius)

var sphereFromThisCircle = Sphere()
sphereFromThisCircle.radius = thisCircle.radius
sphereFromThisCircle.centroid = thisCircle.centroid
sphereFromThisCircle.height = 3
print(sphereFromThisCircle.volume)
print(sphereFromThisCircle.area) //inherited from Circle
sphereFromThisCircle.move(.left, by: 4)
print(sphereFromThisCircle.centroid)