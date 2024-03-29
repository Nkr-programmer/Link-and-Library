import 'package:Chromser/Screens/classifications/links.dart';
import 'package:Chromser/Screens/classifications/new_or_most.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'constants.dart';
import 'package:Chromser/Screens/classifications/chat/Screens/home_screen.dart'as hm;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CategoriesScroller categoriesScroller = CategoriesScroller();
  ScrollController controller = ScrollController();
  bool closeTopContainer = false;
  double topContainer = 0;

  List<Widget> itemsData = [];

  void getPostsData(BuildContext context) {
    List<dynamic> responseList = FOOD_DATA;
    List<Widget> listItems = [];
    responseList.forEach((post) {
      listItems.add(Container(
          height: 150,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20.0)), 
          color: Colors.black54, boxShadow: [
            BoxShadow(color: Colors.white.withAlpha(100), blurRadius: 10.0),
          ]),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        post["name"],
                        style: const TextStyle(fontSize: 20, color: Colors.white,fontWeight: FontWeight.bold),
                      ),
                      Text(
                        post["brand"],
                        style: const TextStyle(fontSize: 17, color: Colors.grey),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "\ ${post["price"]}",
                        style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                Expanded(
                                  child: GestureDetector(
                              child: Image.asset(
                      "assets/images/${post["image"]}",
                      height: double.infinity,
                     
                    ),
                  onLongPress: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context){return Links(post: post);}));
                  },),
                )
              ],
            ),
          )));
    });
    setState(() {
      itemsData = listItems;
    });
  }

  @override
  void initState() {
    super.initState();
    getPostsData(context);
    controller.addListener(() {

      double value = controller.offset/119;

      setState(() {
        topContainer = value;
        closeTopContainer = controller.offset > 50;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double categoryHeight = size.height*0.30;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.black,
          leading: Icon(
            Icons.menu,
            color: Colors.white,
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search, color: Colors.white),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.person, color: Colors.white),
              onPressed: () {},
            )
          ],
        ),
        body: Container(
          height: size.height,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text(
                    "Links",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  GestureDetector(
                                      child: Text(
                      "Lib",
                      style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) {return hm.HomeScreen();},))
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: closeTopContainer?0:1,
                child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: size.width,
                    alignment: Alignment.topCenter,
                    height: closeTopContainer?0:categoryHeight,
                    child: categoriesScroller),
              ),
              Expanded(
                  child: ListView.builder(
                    controller: controller,
                      itemCount: itemsData.length,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        double scale = 1.0;
                        if (topContainer > 0.5) {
                          scale = index + 0.5 - topContainer;
                          if (scale < 0) {
                            scale = 0;
                          } else if (scale > 1) {
                            scale = 1;
                          }
                        }
                        return Opacity(
                          opacity: scale,
                          child: Transform(
                            transform:  Matrix4.identity()..scale(scale,scale),
                            alignment: Alignment.bottomCenter,
                            child: Align(
                                heightFactor: 0.7,
                                alignment: Alignment.topCenter,
                                child: itemsData[index]),
                          ),
                        );
                      })),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoriesScroller extends StatelessWidget {
  const CategoriesScroller();

  @override
  Widget build(BuildContext context) {
    final double categoryHeight = MediaQuery.of(context).size.height * 0.30 - 50;
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: FittedBox(
          fit: BoxFit.fill,
          alignment: Alignment.topCenter,
          child: Row(
            children: <Widget>[
              GestureDetector(
                              child: Container(
                  width: 150,
                  margin: EdgeInsets.only(right: 20),
                  height: categoryHeight,
                  decoration: BoxDecoration(color: Colors.orange.shade400, borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Most\nFavorites",
                          style: TextStyle(fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),onLongPress: (){
Navigator.push(context, MaterialPageRoute(builder: (context) {
  return NewOrMost(name: "Most");
  },));
                },
              ),
              GestureDetector(
                child: Container(
         
                           width: 150,
                  margin: EdgeInsets.only(right: 20),
                  height: categoryHeight,
                  decoration: BoxDecoration(color: Colors.blue.shade400, borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Newest",
                            style: TextStyle(fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                onLongPress: (){
Navigator.push(context, MaterialPageRoute(builder: (context) {
  return NewOrMost(name:"Newest");
  },));
                },
              ),
              Container(
                width: 150,
                margin: EdgeInsets.only(right: 20),
                height: categoryHeight,
                decoration: BoxDecoration(color: Colors.lightBlueAccent.shade400, borderRadius: BorderRadius.all(Radius.circular(20.0))),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Super\nSaving",
                        style: TextStyle(fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "20 Items",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}