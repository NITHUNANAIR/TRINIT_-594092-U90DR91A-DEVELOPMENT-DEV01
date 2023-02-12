import 'package:flutter/material.dart';
import 'package:ngos/src/pages/ngo_details_page.dart';

import 'package:ngos/src/scoped-model/main_model.dart';
import 'package:ngos/src/widgets/donated_ngos.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped-model/main_model.dart';
import '../widgets/donated_ngos.dart';
import '../widgets/home_top_info.dart';
import '../widgets/ngo_category.dart';
import '../widgets/search_file.dart';

// Model
import '../models/paymnet_model.dart';
import 'ngo_details_page.dart';

class HomePage extends StatefulWidget {
 
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  @override
  void initState() {
  
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        padding: EdgeInsets.only(left: 20.0, right: 20.0),
        children: <Widget>[
          HomeTopInfo(),
          NGOsCategory(),
          SizedBox(
            height: 20.0,
          ),
          SearchField(),
          SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Frequently Searched NGOs",
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () {
                  print("visited");
                },
                child: Text(
                  "View all",
                  style: TextStyle(
                    color: Colors.orangeAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.0),
          ScopedModelDescendant<MainModel>(
            builder: (BuildContext context, Widget child, MainModel model) {
              return Column(
                children: model.NGOs.map(_buildNGOs as Function(dynamic e)).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNGOs(NGOs NGOs) {
    return GestureDetector(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => NGOsDetailsPage(
            ngos: NGOs,
          ),
        ));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 20.0),
        child: DonatedNGOs(
          id: NGOs.id,
          name: NGOs.name,
          imagePath: "assets/images/pic1.jpeg",
          category: NGOs.category,
          discount: NGOs.discount,
          price: NGOs.price,
          ratings: NGOs.ratings,
        ),
      ),
    );
  }
}
