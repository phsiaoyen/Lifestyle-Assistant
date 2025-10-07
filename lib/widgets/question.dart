import 'dart:math';

import 'package:flutter/material.dart';

import 'package:test_dart/models/food.dart';

import 'package:test_dart/widgets/alarm.dart';

class Question extends StatefulWidget {
  const Question({super.key});

  //final void Function(Food food) onrightanswer;

  @override
  State<Question> createState() {
    return _QuestionState();
  }
}

class _QuestionState extends State<Question> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  final Set<Category> _selectedCategories = {};
  final Alarmwork _alarmwork=Alarmwork();

  late int a,b,c;
  late int answer,answernum;
  late List<int> ans=[0,0,0,0];

  _QuestionState()
  {
    makequestion();
  }


  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: now,
    );
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _submitanswer(int hechoose) {
    if (hechoose!=answernum) {
      setState(() {
        makequestion();
      });
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Wrong Answer'),
          content: const Text(
              'Try again'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Okay'),
            ),
          ],
        ),
      );
      return;
    }
    _alarmwork.stopAlarm();
    Navigator.pop(context);
  }
  void makequestion()
  {
    List<int> choose=[0,1,2,3];
    choose.shuffle();

    var ran=Random();
    a=ran.nextInt(999);
    b=ran.nextInt(999);
    c=ran.nextInt(999);

    answer=a+b+c;
    answernum=choose[0];

    int ranchoose=ran.nextInt(3000);
    while(ranchoose==answer) {
      ranchoose=ran.nextInt(3000);
    }
    
    ans[choose[0]]=answer;
    ans[choose[1]]=answer+ran.nextInt(100)+1;
    ans[choose[2]]=answer-ran.nextInt(100)-1;
    ans[choose[3]]=ranchoose;

  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
      child: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(a.toString()),
                  const Text('+'),
                  Text(b.toString()),
                  const Text('+'),
                  Text(c.toString()),
                  const Text('='),
                ],
              ),
            ),
          ),
          const Expanded(child: SizedBox(height: 5,)),
          Expanded(
            child: MaterialButton(
              color:Theme.of(context).primaryColorLight,
              minWidth: double.infinity,
              onPressed: (){_submitanswer(0);},
              child: Text(ans[0].toString()),
            ),
          ),
          const Expanded(child: SizedBox(height: 5,)),
          Expanded(
            child: MaterialButton(
              color:Theme.of(context).primaryColorLight,
              minWidth: double.infinity,
              onPressed: (){_submitanswer(1);},
              child: Text(ans[1].toString()),
            ),
          ),
          const Expanded(child: SizedBox(height: 5,)),
          Expanded(
            child: MaterialButton(
              color:Theme.of(context).primaryColorLight,
              minWidth: double.infinity,
              onPressed: (){_submitanswer(2);},
              child: Text(ans[2].toString()),
            ),
          ),
          const Expanded(child: SizedBox(height: 5,)),
          Expanded(
            child: MaterialButton(
              color:Theme.of(context).primaryColorLight,
              minWidth: double.infinity,
              onPressed: (){_submitanswer(3);},
              child: Text(ans[3].toString()),
            ),
          )
        ],
      ),
    );
  }
}
