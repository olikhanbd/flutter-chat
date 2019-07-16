class ChatListModel {
  final String name;
  final String message;
  final String time;
  final String avatarUrl;

  ChatListModel(this.name, this.message, this.time, this.avatarUrl);
}

List<ChatListModel> dummyData = [
  ChatListModel("Harvy Keitel", "Hello, I am Harvey Keitel", "15:30",
      "https://www.syfy.com/sites/syfy/files/styles/1200x680/public/2019/03/iron_man_vr.jpg"),
  ChatListModel("Matt Damon", "Hello, I am Matt Damon", "15:30",
      "https://www.syfy.com/sites/syfy/files/styles/1200x680/public/2019/03/iron_man_vr.jpg"),
  ChatListModel("Leonardo DiCaprio", "Hello, I am Leonardo DiCaprio", "15:30",
      "https://www.syfy.com/sites/syfy/files/styles/1200x680/public/2019/03/iron_man_vr.jpg"),
  ChatListModel("Brad Pitt", "Hello, I am Brad Pitt", "15:30",
      "https://www.syfy.com/sites/syfy/files/styles/1200x680/public/2019/03/iron_man_vr.jpg"),
  ChatListModel("Johny depp", "Hello, I am Johny depp", "15:30",
      "https://www.syfy.com/sites/syfy/files/styles/1200x680/public/2019/03/iron_man_vr.jpg"),
  ChatListModel("Mathew McConoughey", "Hello, I am Mathew McConoughey", "15:30",
      "https://www.syfy.com/sites/syfy/files/styles/1200x680/public/2019/03/iron_man_vr.jpg"),
  ChatListModel("Robert Downey Jr.", "Hello, I am Robert Downey Jr.", "15:30",
      "https://www.syfy.com/sites/syfy/files/styles/1200x680/public/2019/03/iron_man_vr.jpg"),
  ChatListModel("Chris Evans", "Hello, I am Chris Evans", "15:30",
      "https://www.syfy.com/sites/syfy/files/styles/1200x680/public/2019/03/iron_man_vr.jpg"),
  ChatListModel("Chris pratt", "Hello, I am Chris pratt", "15:30",
      "https://www.syfy.com/sites/syfy/files/styles/1200x680/public/2019/03/iron_man_vr.jpg"),
  ChatListModel("Chris Hemsworth", "Hello, I am Chris Hemsworth", "15:30",
      "https://www.syfy.com/sites/syfy/files/styles/1200x680/public/2019/03/iron_man_vr.jpg"),
];
