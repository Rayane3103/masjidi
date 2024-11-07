import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:masjidi/Constants/constants.dart';
import 'package:masjidi/models/pub_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart'; // For permission handling
import 'package:open_filex/open_filex.dart'; // To open files
import 'package:path/path.dart' as path; // For handling file paths

class PubListScreen extends StatefulWidget {
  @override
  _PubListScreenState createState() => _PubListScreenState();
}

class _PubListScreenState extends State<PubListScreen> {
  late Future<List<Pub>> futurePubs;
  final PageController _pageController = PageController(viewportFraction: 0.9);
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    futurePubs = fetchPubs();
    _pageController.addListener(() {
      int nextIndex = _pageController.page!.round();
      if (currentIndex != nextIndex) {
        setState(() {
          currentIndex = nextIndex;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<List<Pub>> fetchPubs() async {
    final response = await http.get(Uri.parse('https://masjidiprivate.onrender.com/api/pub'));

    if (response.statusCode == 200) {
      print(response.body);
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Pub.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load pubs');
    }
  }

 @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.sizeOf(context);
    final formatter = DateFormat('yyyy-MM-dd – HH:mm'); 
    return FutureBuilder<List<Pub>>(
      future: futurePubs,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(color: primaryColor,));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No pubs found'));
        } else {
          final pubs = snapshot.data!;
          final formattedDate = pubs[currentIndex].date != null
              ? formatter.format(pubs[currentIndex].date!)
              : 'No date available';

        return Column(
            children: [
             Container(
  height: screenSize.height * 0.175,
  width: screenSize.width,
  
    child: PageView.builder(
       controller: _pageController,
      itemCount: pubs.length,
      itemBuilder: (context, index) {
        bool isCurrent = index == currentIndex;
        return ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 7.5),
            child: Transform.scale(
              scale: isCurrent ? 1.07 : 1.0,
              child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),

                child: AnimatedContainer(  
                
                  duration: const Duration(milliseconds: 300),
                  height: isCurrent ? screenSize.height * 0.185 : screenSize.height * 0.155,  
                  decoration: BoxDecoration(
    //                 border: Border(
    //   bottom: BorderSide(
    //     color: Colors.blue, // Color for the bottom border
    //     width: 3.0,        // Width of the bottom border
    //   ),
    // ),
                    
                    borderRadius: BorderRadius.circular(20.0),
                    gradient: isCurrent 
                      ? LinearGradient(
                          colors: [Colors.orange, Colors.white],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        )
                      : LinearGradient(
                          colors: [Colors.white, Colors.white],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                  ),
                  child: Stack(
                    children: [
                      Image.asset(
                        "assets/images/pub.png", 
                        height:   250,  
                        fit: BoxFit.fill,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  pubs[index].title != null && pubs[index].title!.length > 18 
                                    ? '...' + pubs[index].title!.substring(0, 18)  
                                    : pubs[index].title ?? 'No title available',
                                  style: TextStyle(
                                    color: secondaryColor,
                                    fontSize: isCurrent ? 22 : 20,  
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(formattedDate),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    ),
  
),

              SizedBox(height:screenSize.height*0.03,),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                       SizedBox(height:screenSize.height*0.015 ,),
        
                      Text(
                        pubs[currentIndex].title ?? 'No title available',
                        textAlign: TextAlign.right,
                        style:  TextStyle(
                          color: primaryColor,
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        pubs[currentIndex].description ?? 'No description available',
                        textAlign: TextAlign.right,
        
                        style: const TextStyle(
                          fontSize: 14.0,
                        ),
                      ),
            ])),),
                      Spacer(),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: pubs[currentIndex].file != null ?
                          Center(
                            child: SizedBox(
                              height: MediaQuery.sizeOf(context).height*0.07,
                              width: MediaQuery.sizeOf(context).width*0.8,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(foregroundColor: Colors.white,backgroundColor: primaryColor),
                                            onPressed: () {
                                              _downloadAndOpenFile(pubs[currentIndex].file!, pubs[currentIndex].title!);
                                            },
                                            child: Center(
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.download,color: Colors.white,),
                                                  SizedBox(width: 10,),
                                                  Text('تحميل الملحق',style: TextStyle(fontWeight: FontWeight.bold),),
                                                ],
                                              ),
                                            ),
                                          ),
                            ),
                          ): Text('لا يوجد تقرير ملحق'),
                        
                        ),
                      ),
                    ],
                  );
               
          
        }
      },
    );
  }

  Future<void> _downloadAndOpenFile(String base64String, String fileName) async {
    try {
      // Request storage permission for Android
      if (Platform.isAndroid) {
        PermissionStatus status = await Permission.storage.request();
        if (!status.isGranted) {
          throw Exception('Storage permission denied');
        }
      }

      // Decode Base64 string
      Uint8List bytes = base64Decode(base64String.split(',').last);

      // Get the external storage directory
      Directory? externalStorageDir = await getExternalStorageDirectory();
      if (externalStorageDir == null) {
        throw Exception('Could not access external storage directory');
      }

      // Create the "Download" directory if it doesn't exist
      String downloadsPath = path.join(externalStorageDir.path, 'Download');
      Directory downloadsDir = Directory(downloadsPath);

      if (!await downloadsDir.exists()) {
        await downloadsDir.create(recursive: true);
      }

      // Append file extension if not already present (adjust based on your API)
      String fileExtension = _getFileExtension(base64String, fileName);
      String fullFileName = fileName.endsWith(fileExtension) ? fileName : '$fileName$fileExtension';

      // Set the file path to the Downloads folder
      String filePath = path.join(downloadsDir.path, fullFileName);

      // Write the file to the Downloads folder
      File file = File(filePath);
      await file.writeAsBytes(bytes);

      // Open the file
      OpenFilex.open(filePath);
    } catch (e) {
      print('Error downloading and opening file: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to download or open file')),
      );
    }
  }

  // Function to determine file extension from base64 or fileName
  String _getFileExtension(String base64String, String fileName) {
    // Check for file type based on fileName
    if (fileName.contains('.')) {
      return path.extension(fileName);
    }
    
    // Fallback logic for detecting file type from base64 string (if available)
    if (base64String.contains('pdf')) {
      return '.pdf';}else if (base64String.contains('png')) {
      return '.png';}else if (base64String.contains('jpg')) {
      return '.jpg';}else if (base64String.contains('zip')) {
      return '.zip';} else if (base64String.contains('rar')) {
      return '.rar';
    }else if (base64String.contains('doc') || base64String.contains('docx')) {
      return '.docx';
    }
    
    // Default file extension
    return '.txt';
  }
}
