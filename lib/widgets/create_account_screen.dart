import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'user.dart';
import 'package:test_dart/widgets/bottom_nav.dart';
import 'package:test_dart/main.dart';
import 'package:test_dart/widgets/color_schemes.blue.dart';
import 'package:test_dart/widgets/color_schemes.red.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({/*required this.setuser,*/ super.key});
  //final ValueChanged<User> setuser;

  @override
  _CreateAccountScreenState createState() => _CreateAccountScreenState();
}
class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final PageController _pageController = PageController();
  User mainUser = User();
  List<String> questions = [
    'What is your name?',
    'What is your height?',
    'What is your weight?',
    'What is your goal weight?',
    'When is your birthday?',
    'Which AI character do you want?',
  ];
  int currentPageIndex = 0;

  TextEditingController nameController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController goalController = TextEditingController();

  int selectedCharacterIndex = -1;

  @override
  void dispose() {
    nameController.dispose();
    heightController.dispose();
    weightController.dispose();
    goalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: 7,
        itemBuilder: (context, index) {
          return buildPage(index);
        },
        onPageChanged: (index) {
          setState(() {
            currentPageIndex = index;
          });
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {
                if(currentPageIndex>0){
                  _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  );
                }
                else {
                  Navigator.pop(context);
                }
              },
              child: const Text('Back'),
            ),
            const Spacer(),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 0; i < questions.length + 1; i++)
                    Expanded(
                      child: Icon(
                        Icons.circle,
                        size: 12,
                        color: i == currentPageIndex ? Colors.black : Colors.grey,
                      ),
                    ),
                ],
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {
                if (currentPageIndex < questions.length) {
                  _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut);
                } else {
                  if(mainUser.name.isEmpty 
                      || mainUser.height==0 
                      || mainUser.weight==0 
                      || mainUser.goal==0 
                      || mainUser.birthday==null
                      ||selectedCharacterIndex==-1){
                    _showDialog('Please fill in all fields correctly.');
                  }
                  else{
                    //widget.setuser(mainUser);
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => MyTabs(user: mainUser)),
                      (route) => false,
                    );
                  }
                }
              },
              child: Text(currentPageIndex < questions.length  ? 'Next' : 'Finish'),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPage(int index) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          index == 0
            ? const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Welcome to our intelligent assistant app!",
                    style: TextStyle(
                      fontSize: 20, 
                      fontWeight: FontWeight.bold, 
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Take charge of your health journey with our intuitive diet and lifestyle management tool. Get started in just a few simple steps to personalize your experience and achieve your wellness goals.",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10), 
                  Text(
                    "Let's get started!",
                    style: TextStyle(
                      fontSize: 18,
                      fontStyle: FontStyle.italic, 
                    ),
                    textAlign: TextAlign.center, 
                  ),
                ],
              )
            : Text(
                questions[index - 1],
                style: const TextStyle(fontSize: 15.0),
              ),
          const SizedBox(height: 20.0),
          index > 0 
            ? index == 6
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      characterButton(0, 'Diet Expert'),
                      const SizedBox(width: 10),
                      characterButton(1, 'Angry Robot'),
                      const SizedBox(width: 10),
                      characterButton(2, 'Cat'),
                    ],
                  )
                : index==5 
                ? ElevatedButton(
                    onPressed: () => _selectDate(context),
                    child: Text( mainUser.birthday == null
                                    ? 'No date selected'
                                    : DateFormat.yMd().format(mainUser.birthday!),),
                  )
                :TextFormField(
                    controller: index == 1
                        ? nameController
                        : index == 2
                            ? heightController
                            : index == 3
                                ? weightController
                                : goalController,
                    decoration: InputDecoration(
                      label: index == 1
                              ? const Text('')
                              : index == 2
                                  ? const Text('cm')
                                  : const Text('kg'),
                      labelStyle: const TextStyle(color: Colors.grey),
                    ),
                    onChanged: (value) {
                      switch (index) {
                        case 1:
                          mainUser.name = value;
                          break;
                        case 2:
                          mainUser.height = double.tryParse(value) ?? 0.0;
                          if(mainUser.height==0 && value!="") _showDialog('Please enter a vaild number.');
                          break;
                        case 3:
                          mainUser.weight = double.tryParse(value) ?? 0.0;
                          weightnow = int.tryParse(value) ?? 0;
                          if(mainUser.weight==0 && value!="") _showDialog('Please enter a vaild number.');
                          break;
                        case 4:
                          mainUser.goal = double.tryParse(value) ?? 0.0;
                          idealweight = int.tryParse(value) ?? 0;
                          if(mainUser.goal==0 && value!="") _showDialog('Please enter a vaild number.');
                          break;
                      }
                    },
                  )
            : const SizedBox(), 
        ],
      ),
    ),
  );
}


  Widget characterButton(int buttonIndex, String buttonText) {
    return TextButton(
      onPressed: () {
        setState(() {
          selectedCharacterIndex = buttonIndex;
          mainUser.aiCharacter = buttonText;
          if(buttonText=='Diet Expert')
          {
            robotnum=1;
            kColorScheme = lightColorSchemeBlue;
            kDarkColorScheme = darkColorSchemeBlue;
          }
          else if(buttonText=='Angry Robot')
          {
            robotnum=2;
            kColorScheme = lightColorSchemeRed;
            kDarkColorScheme = darkColorSchemeRed;
          }
          else
          {
            robotnum=3;
            kColorScheme = lightColorSchemeBlue;
            kDarkColorScheme = darkColorSchemeBlue;
          }
        });
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (buttonIndex == selectedCharacterIndex) {
              return const Color.fromARGB(255, 104, 34, 180);
            }
            return Colors.white;
          },
        ),
        foregroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (buttonIndex == selectedCharacterIndex) {
              return Colors.white;
            }
            return const Color.fromARGB(255, 104, 34, 180);
          },
        ),
      ),
      child: Text(buttonText),
    );
  }

  void _showDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: mainUser.birthday ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != mainUser.birthday) {
      setState(() {
        mainUser.birthday = picked;
      });
    }
  }
}