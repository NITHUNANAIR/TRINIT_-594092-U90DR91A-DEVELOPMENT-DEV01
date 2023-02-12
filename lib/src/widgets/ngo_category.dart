import 'package:flutter/material.dart';
import 'user_pro.dart';

// DAta
import '../data/ngo_data.dart';

// Model
import '../models/filter_name.dart';

class NGOList extends StatelessWidget{

  final List<Category> _categories = categories;

  @override
  Widget build(BuildContext context){
    return Container(
      height: 80.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (BuildContext context, int index){
          return progressCard(
            categoryName: _categories[index].categoryName,
            imagePath: _categories[index].imagePath,
            numberOfNGOs: _categories[index].numberOfItems,
          );
        },
      ),
    );
  }
}
