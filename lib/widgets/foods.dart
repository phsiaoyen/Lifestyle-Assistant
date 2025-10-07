import 'package:test_dart/main.dart';
import 'package:test_dart/widgets/new_food.dart';
import 'package:flutter/material.dart';


import 'package:test_dart/widgets/foods_list/foods_list.dart';
import 'package:test_dart/models/food.dart';
import 'package:test_dart/models/pie_chart_data.dart';
import 'package:test_dart/widgets/pie_chart.dart';
import 'package:test_dart/widgets/question.dart';

import 'package:alarm/alarm.dart';
import 'package:test_dart/widgets/alarm.dart';

class Foods extends StatefulWidget {
  //const Foods({super.key});
  
  //final String foodHistory;

  //final Function(String) parentAction; 

  const Foods({Key ?key}) : super(key: key);

  @override
  State<Foods> createState() {
    return _FoodsState();
  }
}

class _FoodsState extends State<Foods> with AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;
  
  int fruitamount=0;
  int vegetableamount=1;
  int riceamount=1;
  int meatamount=0;
  int milkamount=0;

  List<Dietdata> _piedata=[];
  late String _foodHistory;
  

  String _selectedTimeRange = 'This Week';
  int _selectedTimeRangeIndex = 0;
  final Alarmwork _alarmwork=Alarmwork();

  


  final List<Food> _registeredFoods = [
    Food(
      title: 'Breakfast',
      amount: 19.0,
      date: DateTime.now(),
      category: [Category.vegetable],
    ),
    Food(
      title: 'Lunch',
      amount: 15.6,
      date: DateTime.now(),
      category: [Category.rice],
    ),
  ];

   //String foodHistory=''; // Declare foodHistory variable

  @override
  void initState() {
    super.initState();
    _foodHistory='';    //foodHistory = widget.foodHistory; // Initialize foodHistory with widget.foodHistory
  }

  
  _FoodsState(){
    _updatepiedata();
  }

  void _changeTimeRange(String newRange, int newIndex) {
    setState(() {
      _selectedTimeRange = newRange;
      _selectedTimeRangeIndex = newIndex;
    });
  }

  void _updatepiedata(){
    fruitamount = 0;
    vegetableamount = 0;
    riceamount = 0;
    meatamount = 0;
    milkamount = 0;

    _registeredFoods.where((food) {
      if (_selectedTimeRangeIndex == 0) {
        final now = DateTime.now();
        final lastSunday = now.subtract(Duration(days: now.weekday % 7 + 1));
        return food.date.isAfter(lastSunday);
      } else if (_selectedTimeRangeIndex == 1) {
        final now = DateTime.now();
        final firstDayOfThisMonth = DateTime(now.year, now.month, 1);
        return food.date.isAfter(firstDayOfThisMonth.subtract(const Duration(days: 1)));
      } else {
        return true;
      }
    }).forEach((food) {
      for (var element in food.category) {
        if(element==Category.fruit)
        {
          fruitamount++;
        }
        else if(element==Category.vegetable)
        {
          vegetableamount++;
        }
        else if(element==Category.rice)
        {
          riceamount++;
        }
        else if(element==Category.meat)
        {
          meatamount++;
        }
        else
        {
          milkamount++;
        }
        if(fruitamount<=vegetableamount&&fruitamount<=riceamount&&fruitamount<=meatamount&&fruitamount<=milkamount){
          lackfood='fruit';
        }
        else if(vegetableamount<=fruitamount&&vegetableamount<=riceamount&&vegetableamount<=meatamount&&vegetableamount<=milkamount){
          lackfood='vegetable';
        }
        else if(riceamount<=fruitamount&&riceamount<=vegetableamount&&riceamount<=meatamount&&riceamount<=milkamount){
          lackfood='rice';
        }
        else if(meatamount<=fruitamount&&meatamount<=vegetableamount&&meatamount<=riceamount&&meatamount<=milkamount){
          lackfood='meat';
        }
        else{
          lackfood='milk';
        }
      }
      
    });
    _piedata=[
      Dietdata(
        "fruit",
        fruitamount
      ),
      Dietdata(
        "vegetable",
        vegetableamount
      ),
      Dietdata(
        "rice",
        riceamount
      ),
      Dietdata(
        "meat",
        meatamount
      ),
      Dietdata(
        "milk",
        milkamount
      ),
    ];
  }

  void _openAddFoodOverlay() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewFood(onAddFood: _addFood),
    );
  }

  void _openQuestionOverlay() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) => const Question(),
    );
  }

  void _addFood(Food food) {
    setState(() {
      _registeredFoods.add(food);
      for (var element in food.category) {
        if(element==Category.fruit)
        {
          fruitamount++;
        }
        else if(element==Category.vegetable)
        {
          vegetableamount++;
        }
        else if(element==Category.rice)
        {
          riceamount++;
        }
        else if(element==Category.meat)
        {
          meatamount++;
        }
        else
        {
          milkamount++;
        }
      }
      
      _updatepiedata();
    });
  }

  void _removeFood(Food food) {
    final foodIndex = _registeredFoods.indexOf(food);
    setState(() {
      _registeredFoods.remove(food);
      for (var element in food.category) {
        if(element==Category.fruit)
        {
          fruitamount--;
        }
        else if(element==Category.vegetable)
        {
          vegetableamount--;
        }
        else if(element==Category.rice)
        {
          riceamount--;
        }
        else if(element==Category.meat)
        {
          meatamount--;
        }
        else
        {
          milkamount--;
        }
      }
      _updatepiedata();
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text('Food deleted.'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _registeredFoods.insert(foodIndex, food);
              for (var element in food.category) {
                if(element==Category.fruit)
                {
                  fruitamount++;
                }
                else if(element==Category.vegetable)
                {
                  vegetableamount++;
                }
                else if(element==Category.rice)
                {
                  riceamount++;
                }
                else if(element==Category.meat)
                {
                  meatamount++;
                }
                else
                {
                  milkamount++;
                }
              }
              _updatepiedata();
              
            }
            );
          },
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    super.build(context);
    
    _updatepiedata();

    Widget mainContent = const Center(
      child: Text('No foods found. Start adding some!'),
    );

    if (_registeredFoods.isNotEmpty) {
      mainContent = FoodsList(
        foods: _registeredFoods.where((food) {
          if (_selectedTimeRangeIndex == 0) {
            final now = DateTime.now();
            final lastSunday = now.subtract(Duration(days: now.weekday % 7 + 1));
            return food.date.isAfter(lastSunday);
          } else if (_selectedTimeRangeIndex == 1) {
            final now = DateTime.now();
            final firstDayOfThisMonth = DateTime(now.year, now.month, 1);
            return food.date.isAfter(firstDayOfThisMonth.subtract(const Duration(days: 1)));
          } else {
            return true;
          }
        }).toList(),
        onRemoveFood: _removeFood,
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: 
        IconButton(
          //onPressed: _openAddFoodOverlay,
          onPressed: _openQuestionOverlay,
          //onPressed:() async{await Alarm.stop(42);},
          icon: const Icon(Icons.add),
        ),
        title: const Text('Flutter FoodTracker'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(width: 15),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _selectedTimeRangeIndex = 0;
                  });
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(_selectedTimeRangeIndex == 0 ? const Color.fromARGB(255, 96, 59, 181) : Colors.grey),
                  foregroundColor: MaterialStateProperty.all(_selectedTimeRangeIndex == 0 ? Colors.white : Colors.white70),
                  minimumSize: MaterialStateProperty.all(const Size(10, 40)),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(0))),
                ),
                child: const Text('Week'),
              ),
              const SizedBox(width: 5), // Add some space between the buttons
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _selectedTimeRangeIndex = 1;
                  });
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(_selectedTimeRangeIndex == 1 ? const Color.fromARGB(255, 96, 59, 181) : Colors.grey),
                  foregroundColor: MaterialStateProperty.all(_selectedTimeRangeIndex == 1 ? Colors.white : Colors.white70),
                  minimumSize: MaterialStateProperty.all(const Size(10, 40)),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(0))),
                ),
                child: const Text('Month'),
              ),
              const SizedBox(width: 5), // Add some space between the buttons
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _selectedTimeRangeIndex = 2;
                  });
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(_selectedTimeRangeIndex == 2 ? const Color.fromARGB(255, 96, 59, 181) : Colors.grey),
                  foregroundColor: MaterialStateProperty.all(_selectedTimeRangeIndex == 2 ? Colors.white : Colors.white70),
                  minimumSize: MaterialStateProperty.all(const Size(10, 40)),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(0))),
                ),
                child: const Text('All'),
              ),
            ],
          ),
          Buildpiechart(_piedata),
          Expanded(
            child: mainContent,
          ),
        ],
      ),
      /*floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewPage()),
          );
        },
        child: const Icon(Icons.navigate_next),
      ),*/
    );
  }
}
