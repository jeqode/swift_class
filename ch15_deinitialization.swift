class Chatroom{
	var name: String
	var capacity = 50
	var onlineUsers = [String]()

	init(name: String, capacity: Int){
		self.name = name
		self.capacity = capacity
	}
}

class User{
	var name = "Anonymous"
	var joinedRooms = [Chatroom]()

	init(name: String, rooms: Chatroom...){
		self.name = name
		for room in rooms{
			if room.onlineUsers.count < room.capacity{
				self.joinedRooms.append(room)
				room.onlineUsers.append(self.name)
			}
		}
	}

	deinit{
		for room in joinedRooms{
			room.onlineUsers.removeAll(where: {$0 == self.name})
		}
	}
}

let techTalkRoom = Chatroom(name: "techTalk", capacity: 30)
let thaiCultRoom = Chatroom(name: "thaiCult", capacity: 40)

var jason: User? = User(name: "Jason", rooms: techTalkRoom, thaiCultRoom)
let jack = User(name: "Jack", rooms: techTalkRoom)

print(jason!.joinedRooms.map({$0.name}))
print(techTalkRoom.onlineUsers)
jason = nil // there's no ref to the obj trigger deallocate
print(techTalkRoom.onlineUsers)