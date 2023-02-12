// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, duplicate_ignore

import 'package:flutter/material.dart';
import 'package:ngos/src/admin/pages/add_users.dart';
import 'package:ngos/src/models/payment_model.dart';
import 'package:ngos/src/scoped-model/main_model.dart';
import 'package:ngos/src/widgets/donar.dart';
import 'package:ngos/src/widgets/comm.dart';
import 'package:scoped_model/scoped_model.dart';

class FavoritePage extends StatefulWidget {
  final MainModel model;

  const FavoritePage({super.key, required this.model});
  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {

  // the scaffold global key
  GlobalKey<ScaffoldState> _explorePageScaffoldKey = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.model.fetchNGOs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _explorePageScaffoldKey,
      backgroundColor: Colors.white,
      body: ScopedModelDescendant<MainModel>(
        builder: (BuildContext sctx, Widget child, MainModel model) {
          //model.fetchNGOs(); // this will fetch and notifylisteners()
          // List<NGOs> NGOs = model.NGOs;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: RefreshIndicator(
              onRefresh: model.fetchNGOs,
              child: ListView.builder(
                itemCount: model.NGOsLength,
                itemBuilder: (BuildContext lctx, int index) {
                  return GestureDetector(
                    onTap: () async {
                      final bool response =
                          await Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) => AddNGOs(
                                    NGOs: model.NGOs[index],
                                  )));

                      if (response) {
                        SnackBar snackBar = SnackBar(
                          duration: Duration(seconds: 2),
                          backgroundColor: Theme.of(context).primaryColor,
                          // ignore: prefer_const_constructors
                          content: Text(
                            "NGOs successfully updated.",
                            style:
                                const TextStyle(color: Colors.white, fontSize: 16.0),
                          ),
                        );
                        _explorePageScaffoldKey.currentState!.showSnackBar(snackBar);
                      }
                    },
                    onDoubleTap: (){
                      
                      showLoadingIndicator(context, "Deleting NGOs...");
                      model.deleteNGOs(model.NGOs[index].id).then((bool response){
                        Navigator.of(context).pop();
                      });
                    },
                    child: NGOsCard(
                      model.NGOs[index].name,
                      model.NGOs[index].description,
                      model.NGOs[index].amount.toString(),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

