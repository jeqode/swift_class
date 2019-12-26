struct PointNoDefaultY{
	var x = 0
	let y: Int
}
// let somePoint = PointNoDefaultY() //error missing arg y
let pointAtOrigin = PointNoDefaultY(y: 0)
// pointAtOrigin.x = 2 // pointAtOrigin is const
print(pointAtOrigin.x, pointAtOrigin.y)
var pointAtThreeFive = PointNoDefaultY(x: 2, y: 5)
pointAtThreeFive.x = 3
// pointAtThreeFive.y = 6 // y is a const
print(pointAtThreeFive.x, pointAtThreeFive.y)
enum Direction{
	case up, right, down, left
}

struct Point{
	var x = 0
	var y = 0
}

class Snake{
	//member-wise initializer
	var head = Point(x: 3, y: 3)
	var body = [Point]()
	var direction = Direction.right
}

func movePoint(_ point: inout Point, direction: Direction){
	switch direction {
	case .up:
		point.y += 1
	case .right:
		point.x += 1
	case .down:
		point.y -= 1
	case .left:
		point.x -= 1
	}
}

// var snake = Snake(head: Point(x: 4, y: 6), body: [Point(x: 3, y: 6)], direction: Direction.right) 
//class doesen't have memberwise-initializer
var point = Point(x: 2, y: 4)
var snake = Snake()
print("snake", snake.head.x, snake.head.y) // 3, 3
movePoint(&snake.head, direction: Direction.up)
print("snake", snake.head.x, snake.head.y) // 3, 4
var sameSnake = snake
movePoint(&sameSnake.head, direction: Direction.up)
print("snake", snake.head.x, snake.head.y) // 3, 5
// classes are reference type

movePoint(&point, direction: .down)
print("point", point.x, point.y) // 2, 3
var samePoint = point
movePoint(&samePoint, direction: .left)
print("point", point.x, point.y) // 2, 3
print("samePoint", samePoint.x, samePoint.y) // 1, 3
// structures are value type
let anotherSnake = Snake()
if snake === sameSnake{
	print("Snake is a reference type")
}
movePoint(&sameSnake.head, direction: .down)
movePoint(&sameSnake.head, direction: .down)
// print("snake == anotherSnake", snake == anotherSnake) // overload is needed
print("snake.head.x == anotherSnake.head.x", snake.head.x == anotherSnake.head.x)
print("snake === anotherSnake", snake === anotherSnake)
// if samePoint !== point{ //cannot apply to struct
// 	print("Point is a value type")
// }