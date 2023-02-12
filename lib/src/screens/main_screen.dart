import 'package:flutter/material.dart';
import 'package:ngos/src/admin/pages/add_users.dart';
import 'package:ngos/src/pages/sigin_page.dart';
import 'package:ngos/src/scoped-model/main_model.dart';
import 'package:scoped_model/scoped_model.dart';
import '../pages/main_frame.dart';
import '../pages/donation.dart';
import '../pages/events.dart';
import '../pages/profile_page.dart';

class MainScreen extends StatefulWidget {
  final MainModel model;

  const MainScreen({super.key, required this.model});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentTab = 0;

  // Pages
  late HomePage homePage;
  late DonationPage donationPage;
  late FavoritePage favoritePage;
  late ProfilePage profilePage;

  late List<Widget> pages;
  late Widget currentPage;

  @override
  void initState() {
    widget.model.fetchAll();

    homePage = HomePage();
    donationPage = DonationPage();
    favoritePage = FavoritePage(model: widget.model);
    profilePage = ProfilePage();
    pages = [homePage, favoritePage, donationPage, profilePage];

    currentPage = homePage;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          title: Text(
            currentTab == 0
                ? "selfless"
                : currentTab == 1
                    ? "All NGOs"
                    : currentTab == 2
                        ? "Donation"
                        : "Profile",
            style: TextStyle(
                color: Colors.black,
                fontSize: 16.0,
                fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.notifications_none,
                  // size: 30.0,
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: () {}),
            currentTab == 3
                ? ScopedModelDescendant(builder:
                    (BuildContext context, Widget child, MainModel model) {
                    return IconButton(
                      icon: Icon(
                        Icons.logout,
                        color: Theme.of(context).primaryColor,
                      ),
                      onPressed: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (BuildContext context) => SignInPage()));
                        model.logout();
                      },
                    );
                  })
                : IconButton(
                    icon: _buildDonation(),
                    onPressed: () {},
                  )
          ],
        ),
        drawer: Drawer(
          child: Column(
            children: <Widget>[
              ListTile(
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => Donation()));
                },
                leading: Icon(Icons.list),
                title: Text(
                  "Donation",
                  style: TextStyle(fontSize: 16.0),
                ),
              )
            ],
          ),
        ),
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentTab,
          onTap: (index) {
            setState(() {
              currentTab = index;
              currentPage = pages[index];
            });
          },
          type: BottomNavigationBarType.fixed,
          // ignore: prefer_const_literals_to_create_immutables
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
              ),
              icon: Text("Home"),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.explore,
              ),
              title: Text("Search"),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.shopping_cart,
              ),
              title: Text("Donations"),
            ),
            const BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
              ),
              icon: Text("Profile"),
            ),
          ],
        ),
        body: currentPage,
      ),
    );
  }

  Widget _buildDonation() {
    return Stack(
      children: <Widget>[
        Icon(
          Icons.Donation,
          // size: 30.0,
          color: Theme.of(context).primaryColor,
        ),
        Positioned(
          top: 0.0,
          right: 0.0,
          child: Container(
            height: 12.0,
            width: 12.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Colors.red,
            ),
            child: Center(
              child: Text(
                "1",
                style: TextStyle(
                  fontSize: 12.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
