import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simple_apod/data/fetch_api.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = false;
  String selectedDate = '';
  String imgUrl = '';
  String title = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Apod:  Astronomy Picture of the Day"),
      ),
      body: ListView(
        children: [
          Visibility(
            visible: !isLoading,
            replacement: const Center(
              child: CircularProgressIndicator(),
            ),
            child: Visibility(
              visible: imgUrl.isNotEmpty,
              replacement: const Center(
                child: Text("No image"),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.network(
                    imgUrl,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(title)
                ],
              ),
            ),
          )
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () async {
              try {
                setState(() {
                  isLoading = true;
                });
                final apodData = await FetchApi.getData(selectedDate);
                if (apodData.mediaType != null &&
                    apodData.mediaType == 'image' &&
                    apodData.url != null &&
                    apodData.url!.isNotEmpty &&
                    apodData.title != null &&
                    apodData.title!.isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Found a image!"),
                    ),
                  );
                  imgUrl = apodData.url!;
                  title = apodData.title!;
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Unexpected exception!"),
                  ),
                );
              } finally {
                setState(() {
                  isLoading = false;
                });
              }
            },
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Get Image'),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          FloatingActionButton(
            onPressed: () async {
              final dateTime = await showDatePicker(
                context: context,
                firstDate: DateTime(2020),
                lastDate: DateTime.now(),
              );
              if (dateTime != null) {
                final dateFormat = DateFormat('yyyy-MM-dd');
                setState(() {
                  selectedDate = dateFormat.format(dateTime);
                });
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child:
                  Text(selectedDate.isNotEmpty ? selectedDate : 'Pick a Date'),
            ),
          ),
        ],
      ),
    );
  }
}
