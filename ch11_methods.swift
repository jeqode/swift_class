enum Direction{
	case left, right, up, down
	var opposite: Direction{
		switch self{
		case .left:
			return Direction.right
		case .right:
			return Direction.left
		case .up:
			return Direction.down
		case .down:
			return Direction.up
		}
	}

	//discardable result & self assign in mutating method
	@discardableResult
	mutating func turnAround() -> Direction{
		switch self{
		case .left:
			self = .right
		case .right:
			self = .left
		case .up:
			self = .down
		case .down:
			self = .up
		}
		return self
	}
}
//discardable result
var snakeHeadingDirection = Direction.right
print(snakeHeadingDirection.turnAround())
snakeHeadingDirection.turnAround()
print(snakeHeadingDirection)

struct Point{
	var x = 0
	var y = 0

	// func move(_ direction: Direction){ // can't mutate
	mutating func move(_ direction: Direction){
		switch direction {
		case .left:
			//self keyword can be omitted
			x -= 1
		case .right:
			x += 1
		case .up:
			self.y += 1
		case .down:
			self.y -= 1
		}
	}
	//assign to self
	mutating func moveTo(point: Point){
		self = point
	}
	mutating func moveBy(x dx: Int = 0, y dy: Int = 0){
		self = Point(x: self.x + dx, y: self.y + dy)
	}
}

var somePoint = Point(x: 2, y: 3)
let anotherPoint = Point(x: 5, y: 5)
somePoint.moveTo(point: anotherPoint)
print(somePoint)
somePoint.moveBy(x: 2, y: -2)
print(somePoint)

class Snake{
	static var board = (width: 10, height: 10)
	static var food = Point(x: 3, y: 4)
	var direction = Direction.right
	var head = Point(x: 0, y: 0)
	var body = [Point(x: 0, y: 0)]
	var score = 0
	
	//type method
	static func resizeBoardTo(width: Int, height: Int){
		board = (width: width, height: height)
	}
	//overidable type method
	class func randomFood(){
		// assign to class property
		self.food = Point(x: Int.random(in: 0..<board.width), y: Int.random(in: 0..<board.height))
	}

	@discardableResult
	func move(_ direction: Direction) -> Bool{
		if direction == self.direction.opposite{
			return false
		}
		head.move(direction)
		self.direction = direction
		head.x = head.x % Snake.board.width
		head.y = head.y % Snake.board.height
		if head.x < 0 { head.x += Snake.board.width }
		if head.y < 0 { head.y += Snake.board.height }
		if head.x == Snake.food.x && head.y == Snake.food.y{
			score += 1
			Snake.randomFood()
			body.insert(head, at: 0)
		}
		return true
	}
}

//type method
Snake.resizeBoardTo(width: 10, height: 10)
print(Snake.board)
var player1 = Snake()
player1.move(.up)
print(Snake.food, player1.body)

let player2 = Snake()
print(player2.move(.up))
print(player2.move(.down))