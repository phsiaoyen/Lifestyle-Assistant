import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WeatherGenerationService extends StatefulWidget {
  static const String _url = 'https://opendata.cwa.gov.tw/api/v1/rest/datastore/F-D0047-053?Authorization=CWA-17A99F4D-6C86-4CFB-93F9-A3483D45002A&locationName=%E6%9D%B1%E5%8D%80&elementName=PoP12h,T';

  const WeatherGenerationService({super.key});

  @override
  State<WeatherGenerationService> createState() => _WeatherGenerationServiceState();
}

class _WeatherGenerationServiceState extends State<WeatherGenerationService> {
  String rainpercent='';
  String temperature='';

  Future<Map<String, dynamic>> generateWeather() async {
    var response = await http.get(
      Uri.parse(WeatherGenerationService._url),
    );
    var responseData = json.decode(utf8.decode(response.bodyBytes));
    print(responseData);
    return {
      //'image':responseData['records']['locations'][0]['datasetDescription'],
      'temper':responseData['records']['locations'][0]['location'][0]['weatherElement'][1]['time'][0]['elementValue'][0]['value'],
      'rain':responseData['records']['locations'][0]['location'][0]['weatherElement'][0]['time'][0]['elementValue'][0]['value'],
    };

  }

  void getweather() async {
    var data = await generateWeather();
    setState(() {
      rainpercent=data['rain'];
      temperature=data['temper'];
    });
  }

  @override
  Widget build(BuildContext context) {
      getweather();
      return 
      Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        child: Column(
          children: [
            Row(
              children: [
                const Text(
                      "Temperature: ",
                      selectionColor:Colors.white,
                      //style: Theme.of(context).textTheme.titleLarge,
                    ),
                Text(
                      temperature,
                      selectionColor:Colors.white,
                      //style: Theme.of(context).textTheme.titleLarge,
                    ),
                const Text(
                      "°C",
                      selectionColor:Colors.white,
                      //style: Theme.of(context).textTheme.titleLarge,
                    ),
              ],
            ),
            const SizedBox(height:10),
            Row(
              children: [
                const Text(
                      "Probability of precipitation: ",
                      selectionColor:Colors.white,
                      //style: Theme.of(context).textTheme.titleLarge,
                    ),
                Text(
                      rainpercent,
                      selectionColor:Colors.white,
                    ),
                const Text(
                      "%",
                      selectionColor:Colors.white,
                      //style: Theme.of(context).textTheme.titleLarge,
                    ),
              ],
            ),
          ],
        ), 
      );
    
  }
}
