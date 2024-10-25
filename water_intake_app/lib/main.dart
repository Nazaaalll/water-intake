import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main(){
  runApp(const waterIntakeApp());
}
class waterIntakeApp extends StatelessWidget{
  const waterIntakeApp({super.key});

  @override
  Widget build(BuildContext context) {
   return MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Water Intake App',
    theme: ThemeData(primarySwatch: Colors.blue,useMaterial3: true, ),
    home: const waterIntakeHomePage(),
   );
  }
}
class waterIntakeHomePage extends StatefulWidget {
  const waterIntakeHomePage({super.key});

  @override
  State<waterIntakeHomePage> createState() => _waterIntakeHomePageState();
}

class _waterIntakeHomePageState extends State<waterIntakeHomePage> {
int _waterIntake = 0;
int _dailyGoal = 8;
final List<int> _dailyGoalOptions =[8,10,12];

@override
void initState()
{
  super.initState();
  _loadPreferences();
}  


Future<void> _loadPreferences() async{
  SharedPreferences pref = await SharedPreferences.getInstance();
  setState(() {
    _waterIntake =(pref.getInt('Water intake')?? 0);
    _dailyGoal = (pref.getInt('daily goal')?? 8);
  });
}
Future _incrementWaterIntake() async{
  SharedPreferences pref = await SharedPreferences.getInstance();
  setState(() {
    _waterIntake++;
    pref.setInt('Water intake',_waterIntake);
    if(_waterIntake>= _dailyGoal){
      // show a dialogue box here
      _showGoalReachedDialogue();

    }
  });
}
Future<void> _resetWaterIntake()async
{
  SharedPreferences pref = await SharedPreferences.getInstance();
  setState(() {
    _waterIntake = 0;
    pref.setInt('Water intake',_waterIntake);
  });
}

Future<void> _setDailyGoals(int newGoal)async{
  SharedPreferences pref = await SharedPreferences.getInstance();
  setState(() {
    _dailyGoal = newGoal;
    pref.setInt('DailyGoal', newGoal);
  });

}
Future<void> _showGoalReachedDialogue()async{
  return showDialog<void>(context: context,
  barrierDismissible: false,
  builder: (BuildContext context){
    return AlertDialog(
      title: const Text('Congratulation!'),
      content: SingleChildScrollView(
        child: ListBody(
          children: [
            Text('You have reached your daily goal of $_dailyGoal glasses of water!'),

          ],
        ),
      ),
      actions: [
        TextButton(onPressed: (){
          Navigator.of(context).pop();

        }, child:const Text('ok'))
      ],
    );
  }

  );
  
}

Future<void> _showResetConfirmationDialogue()async{
  return showDialog<void>(context: context,
  barrierDismissible: false,
  builder: (BuildContext context){
    return AlertDialog(
      title: const Text('Reset Water intake?!'),
      content: SingleChildScrollView(
        child: ListBody(
          children: [
            Text('Are you sure, you want to reset your water intake?!'),

          ],
        ),
      ),
      actions: [
        TextButton(onPressed: (){
          Navigator.of(context).pop();

        }, child:const Text('cancel')),
        TextButton(onPressed: (){
          _resetWaterIntake();
          Navigator.of(context).pop();

        }, child: const Text('Reset'))
      ],
    );
  }

  );
  
}

  @override
  Widget build(BuildContext context) {

    double progress = _waterIntake / _dailyGoal;
    bool goalReached = _waterIntake >= _dailyGoal;

    return Scaffold(
      appBar: AppBar(title: Text('Water Intake App'),),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(children: [
            const Icon(Icons.water_drop,size: 120,color: Colors.blue,),
            SizedBox(height: 10,),
            const Text('You have consumed: ',style: TextStyle(fontSize: 18,),),
            Text('$_waterIntake glasses of water',style: Theme.of(context).textTheme.headlineSmall,),
            const SizedBox(height: 10,),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation(Colors.blue),
              minHeight: 20,

            ),
            SizedBox(height: 10,),
            const Text('Dayli goal',style: TextStyle(fontSize: 18),),
            DropdownButton(
              value: _dailyGoal,
              items: _dailyGoalOptions.map((int value){
                return DropdownMenuItem(value: value,
                child: Text('$value glassess'),
                );
              }).toList(),
               onChanged: (int? newValue){
                if(newValue!= null){
                  _setDailyGoals(newValue);
                }
               }),
               SizedBox(height: 10,),
               ElevatedButton(
                onPressed: goalReached? null: _incrementWaterIntake, child: const Text('Add a glass of water',style: TextStyle(fontSize: 18),),),
                SizedBox(height: 20,),
                ElevatedButton(onPressed: _showResetConfirmationDialogue,
                 child: const Text('Reset',style: TextStyle(fontSize: 18),))
        ],),),
      ),
    );
  }
}