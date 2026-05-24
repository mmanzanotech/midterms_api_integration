import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'webview_screen.dart';

class ApiScreen extends StatefulWidget {
  const ApiScreen({super.key});

  @override
  State<ApiScreen> createState() => _ApiScreenState();
}

class _ApiScreenState extends State<ApiScreen> {
  List posts = [];
  bool isLoading = true;
  String errorMessage = '';

  Future<void> fetchData() async {
    try {
      final response = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/posts'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer sample_token',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          posts = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load data. Status code: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error occurred: $e';
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return OrientationBuilder(
      builder: (context, orientation) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('API Data Screen'),
          ),
          body: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(screenWidth * 0.03),
                    child: Text(
                      orientation == Orientation.portrait
                          ? 'Portrait Mode'
                          : 'Landscape Mode',
                      style: TextStyle(
                        fontSize: screenWidth > 600 ? 24 : 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  Expanded(
                    child: isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : errorMessage.isNotEmpty
                            ? Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Text(errorMessage),
                                ),
                              )
                            : ListView.builder(
                                itemCount: posts.length,
                                itemBuilder: (context, index) {
                                  return Card(
                                    margin: EdgeInsets.all(screenWidth * 0.02),
                                    child: ListTile(
                                      title: Text(
                                        posts[index]['title'],
                                        style: TextStyle(
                                          fontSize: screenWidth > 600 ? 20 : 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Text(
                                        posts[index]['body'],
                                        style: TextStyle(
                                          fontSize: screenWidth > 600 ? 16 : 14,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                  ),

                  Padding(
                    padding: EdgeInsets.all(screenWidth * 0.03),
                    child: SizedBox(
                      width: constraints.maxWidth > 600 ? 300 : double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const WebViewScreen(),
                            ),
                          );
                        },
                        child: const Text('Open WebView'),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}