import 'package:flutter/material.dart';
import 'package:ngos/src/models/paymnet_model.dart';
import 'package:ngos/src/scoped-model/main_model.dart';
import 'package:ngos/src/widgets/button.dart';
import 'package:ngos/src/widgets/comm.dart';
import 'package:ngos/src/scoped-model/user_scoped_model.dart';
import 'package:scoped_model/scoped_model.dart';

class AddNGOs extends StatefulWidget {
  final NGOs ngos;

  const AddNGOs({super.key, required this.food});

  @override
  _AddNGOsState createState() => _AddNGOsState();
}

class _AddNGOsState extends State<AddNGOs> {
  late String title;
  late String category;
  late String description;
  late String amount;
  late String donation;

  GlobalKey<FormState> _NGOsFormKey = GlobalKey();
  GlobalKey<ScaffoldState> _scaffoldStateKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () {
          Navigator.of(context).pop(false);
          return Future.value(false);
        },
        child: Scaffold(
          key: _scaffoldStateKey,
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Colors.white,
            title: Text(
              widget.ngos != null ? "Donate" : "View",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              // width: MediaQuery.of(context).size.width,
              // height: MediaQuery.of(context).size.height,
              child: Form(
                key: _foodItemFormKey,
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(bottom: 15.0),
                      width: MediaQuery.of(context).size.width,
                      height: 170.0,
                      decoration: BoxDecoration(
                        // color: Colors.red,
                        borderRadius: BorderRadius.circular(10.0),
                        image: DecorationImage(
                          image: AssetImage("assets/images/noimage.png"),
                        ),
                      ),
                    ),
                    _buildTextFormField("NGO name"),
                    _buildTextFormField("Category"),
                    _buildTextFormField("Description", maxLine: 5),
                    _buildTextFormField("Amount"),
                    _buildTextFormField("Donation"),
                    SizedBox(
                      height: 70.0,
                    ),
                    ScopedModelDescendant(
                      // ignore: dead_code
                      @override
Widget build(BuildContext context) {
  // here, Scaffold.of(context) returns null
  return Scaffold(
    appBar: AppBar(title: const Text('Demo')),
    body: Builder(
      builder: (BuildContext context) {
        return TextButton(
          child: const Text('BUTTON'),
          onPressed: () {
            Scaffold.of(context).showBottomSheet<void>(
              (BuildContext context) {
                return Container(
                  alignment: Alignment.center,
                  height: 200,
                  color: Colors.amber,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const Text('BottomSheet'),
                        ElevatedButton(
                          child: const Text('Close BottomSheet'),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    )
  );
}

  void onSubmit(Function addNGO, Function updateNGO) async {
    if (_NGOsFormKey.currentState!.validate()) {
      _NGOsFormKey.currentState!.save();

      if (widget.ngos != null) {
       
        Map<String, dynamic> updatedNGOs = {
          "title": title,
          "category": category,
          "description": description,
          "amount": double.parse(amount),
          "donation": donation!= null ? double.parse(donation) : 0.0,
        };

        final bool response = await updateNGOs(updatedNGOs, widget.ngos.id);
        if (response) {
          Navigator.of(context).pop(); // to remove the alert Dialog
          Navigator.of(context).pop(response); // to the previous page
        } else if (!response) {
          Navigator.of(context).pop();
          SnackBar snackBar = SnackBar(
            duration: Duration(seconds: 2),
            backgroundColor: Colors.red,
            content: Text(
              "Failed to update ngo",
              style: TextStyle(color: Colors.white, fontSize: 16.0),
            ),
          );
          _scaffoldStateKey.currentState.showSnackBar(snackBar);
        }
      } else if (widget.ngo == null) {
        // I wnat to add new Item
        final NGOs ngos = NGOs(
          name: title,
          category: category,
          description: description,
          amount: double.parse(amount),
          donation: double.parse(donation),
        );
        bool value = await addNGOs(ngos);
        if (value) {
          Navigator.of(context).pop();
          SnackBar snackBar =
              SnackBar(content: Text("NGOs successfully added."));
          _scaffoldStateKey.currentState.showSnackBar(snackBar);
        } else if (!value) {
          Navigator.of(context).pop();
          SnackBar snackBar =
              SnackBar(content: Text("Failed to add NGOs"));
          _scaffoldStateKey.currentState.showSnackBar(snackBar);
        }
      }
    }
  }

  Widget _buildTextFormField(String hint, {int maxLine = 1}) {
    return TextFormField(
      initialValue: widget.ngos != null && hint == "Title"
          ? widget.ngos.name
          : widget.ngos != null && hint == "Description"
              ? widget.ngos.description
              : widget.ngos != null && hint == "Category"
                  ? widget.ngos.category
                  : widget.ngos != null && hint == "amount"
                      ? widget.ngos.price.toString()
                      : widget.ngos != null && hint == "Donation"
                          ? widget.ngos.discount.toString()
                          : "",
      decoration: InputDecoration(hintText: "$hint"),
      maxLines: maxLine,
      keyboardType: hint == "Amount" || hint == "Donation"
          ? TextInputType.number
          : TextInputType.text,
      validator: (String value) {
        // String error
        if (value.isEmpty && hint == "Title") {
          return "The ngos is required";
        }
        if (value.isEmpty && hint == "Description") {
          return "The description is required";
        }

        if (value.isEmpty && hint == "Category") {
          return "The category is required";
        }

        if (value.isEmpty && hint == "Amount") {
          return "The amount is required";
        }
        // return "";
      },
      onSaved: (String value) {
        if (hint == "Title") {
          title = value;
        }
        if (hint == "Category") {
          category = value;
        }
        if (hint == "Description") {
          description = value;
        }
        if (hint == "Amount") {
          amount = value;
        }
        if (hint == "Donation") {
          donation = value;
        }
      },
    );
  }

  Widget _buildCategoryTextFormField() {
    return TextFormField();
  }
}
