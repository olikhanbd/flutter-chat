class ChatModel{
  final String message;
  final String timestamp;
  final String sender;
  final String receiver;
  final int doctype;

  ChatModel(this.message, this.timestamp, this.sender, this.receiver, this.doctype);

}

List<ChatModel> dummyChat = [
  ChatModel(
    "Hello", "time", "me", "you", 0
  ),
  ChatModel(
      "hi", "time", "you", "me", 0
  ),
  ChatModel(
      "https://www.syfy.com/sites/syfy/files/styles/1200x680/public/2019/03/iron_man_vr.jpg", "time", "me", "you", 1
  ),
  ChatModel(
      "fine. What about you", "time", "you", "me", 0
  ),
  ChatModel(
      "I am also fine", "time", "me", "you", 0
  ),
  ChatModel(
      "https://www.syfy.com/sites/syfy/files/styles/1200x680/public/2019/03/iron_man_vr.jpg", "time", "you", "me", 1
  ),
  ChatModel(
      "Working", "time", "me", "you", 0
  ),
  ChatModel(
      "What are you working on?", "time", "you", "me", 0
  ),
  ChatModel(
      "https://www.syfy.com/sites/syfy/files/styles/1200x680/public/2019/03/iron_man_vr.jpg", "time", "me", "you", 1
  ),
  ChatModel(
      "Nice!!", "time", "you", "me", 0
  ),
  ChatModel(
      "Hello", "time", "me", "you", 0
  ),
  ChatModel(
      "https://www.syfy.com/sites/syfy/files/styles/1200x680/public/2019/03/iron_man_vr.jpg", "time", "you", "me", 1
  ),
  ChatModel(
      "How are you", "time", "me", "you", 0
  ),
  ChatModel(
      "fine. What about you", "time", "you", "me", 0
  ),
  ChatModel(
      "mimi7", "time", "me", "you", 2
  ),
  ChatModel(
      "mimi1", "time", "you", "me", 2
  ),
  ChatModel(
      "Working", "time", "me", "you", 0
  ),
  ChatModel(
      "What are you working on?", "time", "you", "me", 0
  ),
  ChatModel(
      "Creating flutter app", "time", "me", "you", 0
  ),
  ChatModel(
      "Nice!!", "time", "you", "me", 0
  ),
];