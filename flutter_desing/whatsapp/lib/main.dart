import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:whatsapp/chat_page.dart';

const dGreen = Color(0xFF2ac0a6);
const dWhite = Colors.white;
const dBlack = Colors.black;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WhatsApp Redesing',
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: dBlack,
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.menu, color: dWhite, size: 30),
        ),

        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.search_rounded, color: dWhite, size: 30),
          ),
        ],
      ),
      body: Column(
        children: [
          MenuSection(),
          FavoriteSection(),
          Expanded(child: MessageSection()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: dGreen,
        foregroundColor: dWhite,
        onPressed: () {},
        child: Icon(Icons.edit, size: 20),
      ),
    );
  }
}

class MenuSection extends StatelessWidget {
  final List menuItems = ['Message', 'Online', 'Groups', 'calls'];
  MenuSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      color: dBlack,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Row(
            children: menuItems.map((items) {
              return Container(
                margin: EdgeInsets.only(right: 55),
                child: Text(
                  items,
                  style: GoogleFonts.inter(color: Colors.white60, fontSize: 29),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class FavoriteSection extends StatelessWidget {
  FavoriteSection({Key? key}) : super(key: key);

  final List FavoriteContacts = [
    {'name': 'Alland', 'profile': 'assets/images/img1.jpg'},
    {'name': 'Jony', 'profile': 'assets/images/img2.jpg'},
    {'name': 'Imar', 'profile': 'assets/images/img3.jpg'},
    {'name': 'Magy', 'profile': 'assets/images/img4.jpg'},
    {'name': 'Dorcas', 'profile': 'assets/images/img5.jpg'},
    {'name': 'Ben', 'profile': 'assets/images/img6.jpg'},
    {'name': 'Mirah', 'profile': 'assets/images/img7.jpg'},
    {'name': 'Driss', 'profile': 'assets/images/img8.jpg'},
    {'name': 'Anytah', 'profile': 'assets/images/img9.jpg'},
    {'name': 'Julien', 'profile': 'assets/images/img10.jpg'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: dBlack,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: dGreen,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 15),
                  child: Text(
                    'Favorite contacts',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.more_horiz, color: Colors.white, size: 20),
                ),
              ],
            ),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: FavoriteContacts.map((favorite) {
                  return Container(
                    margin: EdgeInsets.only(left: 15),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(4),
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                            color: dWhite,
                            shape: BoxShape.circle,
                          ),
                          child: CircleAvatar(
                            radius: 20,
                            backgroundImage: AssetImage(favorite['profile']),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          favorite['name'],
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageSection extends StatelessWidget {
  MessageSection({Key? key}) : super(key: key);

  final List message = [
    {
      'senderName': 'Aline',
      'senderProfile': 'assets/images/img11.jpg',
      'message': 'Hello',
      'unRead': 0,
      'date': '16:35',
    },

    {
      'senderName': 'Marty',
      'senderProfile': 'assets/images/img12.jpg',
      'message': "Hey! What's up?",
      'unRead': 2,
      'date': '13:40',
    },

    {
      'senderName': 'Junior',
      'senderProfile': 'assets/images/img13.jpg',
      'message': "Coffee this week? When are you free?",
      'unRead': 5,
      'date': '15:20',
    },

    {
      'senderName': 'Dodo',
      'senderProfile': 'assets/images/img14.jpg',
      'message': "Sorry, busy day! What's the plan?",
      'unRead': 3,
      'date': '11:55',
    },
    {
      'senderName': 'Mariam',
      'senderProfile': 'assets/images/img15.jpg',
      'message': "HBD! Have a great one! ",
      'unRead': 7,
      'date': '10:05',
    },
    {
      'senderName': 'Savag',
      'senderProfile': 'assets/images/img16.jpg',
      'message': "Congrats! Amazing news!",
      'unRead': 4,
      'date': '00:30',
    },
    {
      'senderName': 'Dan',
      'senderProfile': 'assets/images/img17.jpg',
      'message': "Thanks for the help! ",
      'unRead': 10,
      'date': '23:35',
    },
    {
      'senderName': 'Marcus',
      'senderProfile': 'assets/images/img18.jpeg',
      'message': "You got this! Good luck today.",
      'unRead': 9,
      'date': '14:40',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: message.map((message) {
          return InkWell(
            splashColor: dGreen,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChatPage()),
              );
            },
            child: Container(
              padding: EdgeInsets.only(left: 30, right: 10, top: 15),
              child: Row(
                children: [
                  Container(
                    width: 62,
                    height: 62,
                    margin: EdgeInsets.only(right: 23),
                    decoration: BoxDecoration(
                      color: dGreen,
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(message['senderProfile']),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  message['senderName'],
                                  style: GoogleFonts.inter(
                                    color: Colors.grey,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),

                                Wrap(
                                  children: [
                                    Text(
                                      message['message'],
                                      style: GoogleFonts.inter(
                                        color: Colors.black87,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            Column(
                              children: [
                                Text(message['date']),
                                message['unRead'] != 0
                                    ? Container(
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          color: dGreen,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Text(
                                          message['unRead'].toString(),
                                          style: GoogleFonts.inter(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      )
                                    : Container(),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Container(color: Colors.grey, height: 0.5),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
