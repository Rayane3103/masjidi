import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:masjidi/Constants/constants.dart';
import 'package:masjidi/Constants/lists.dart';
import 'package:masjidi/Screens/all_books.dart';
import 'package:masjidi/components/dots_indicator.dart';
class MaktabaScreen extends StatefulWidget {
  MaktabaScreen({super.key, required this.resultData});
  final Map<String, dynamic>? resultData;

  @override
  State<MaktabaScreen> createState() => _MaktabaScreenState();
}
class _MaktabaScreenState extends State<MaktabaScreen> {
  List<dynamic> choosenBooksList = [];
  int currentPageIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: currentPageIndex);
    
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mosqueId = widget.resultData!['loginMosquee']['id'];
    Size screenSize = MediaQuery.sizeOf(context);

    final String getMosqueeQuery = """
    query getMosquee(\$id: ID!) {
      getMosquee(id: \$id) {
        ... on Error {
          message
        }
        ... on Mosque {
          mosqueeName
          id
          library {
            ... on Error {
              message
            }
            ... on library {
              id
              Books {
                book {
                  ... on Error {
                    message
                  }
                  ... on book {
                    Class
                    bookName
                    numberOfPart
                    Creator
                    detecteur
                    DarNacher
                    DateOfPublier
                    interdit
                  }
                }
              }
            }
          }
        }
      }
    }
    """;

String addLibraryMutation = """
     mutation AddLibrary(\$MosqueeId: ID!) {
  addLibrary(MosqueeId: \$MosqueeId) {
    ... on Mosque {
      mosqueeName
      id
      
    }
    ... on Error {
      message
    }
  }
}
""";

    return Query(
      options: QueryOptions(
        document: gql(getMosqueeQuery),
        variables: {'id': mosqueId},
        fetchPolicy: FetchPolicy.noCache
      ),
     builder: (QueryResult result, {VoidCallback? refetch, FetchMore? fetchMore}) {

   

    if (result.isLoading) {
      return Center(child: CircularProgressIndicator(color: primaryColor));
    }

    if (result.hasException) {
      if (result.exception?.linkException != null) {
        return Center(
          child: Text('خطأ في الاتصال بالشبكة. يرجى التحقق من اتصال الإنترنت الخاص بك.'),
        );
      } else if (result.exception?.graphqlErrors.isNotEmpty ?? false) {
        return Center(
          child: Text('حدث خطأ في جلب البيانات من الخادم.'),
        );
      }
    }
        final library = result.data?['getMosquee']['library']; 
        print('library: $library');
       
        final booksData = result.data?['getMosquee']['library']['Books'] ?? [];
        final libId = result.data?['getMosquee']['library']?['id'];
        print('libId: $libId');
        if (libId==null){
          
          return Column(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Center(child: Image.asset('assets/images/maktaba.png')),
    Text('!لا يحتوي هذا المسجد المكتبة'),
    Container(
      color: Colors.transparent,
      width: screenSize.width * 0.75,
      child: 
          Mutation(
            options: MutationOptions(
              document: gql(addLibraryMutation),
              variables: {
                'MosqueeId': mosqueId,  
              },
              onCompleted: (dynamic resultData) {
                
                print('Library created: $resultData');
              },
              onError: (error) {
                print('Error creating library: $error');
              },
            ),
            builder: (RunMutation runMutation, QueryResult? result) {
               return TextButton(onPressed: (){runMutation({'MosqueeId': mosqueId});}, child: Text(
                  "إنشاء المكتبة",
                  style: TextStyle(fontSize: 18.0, color: secondaryColor),
                ),);
              //
            },
          ))]);
        }
        final filteredBooksData = booksData.where((book) => book['book'] != null).toList();
  print('the books number is : ${filteredBooksData.length} ');
        final type1 = filteredBooksData.where((book) => book['book']['Class'] == "قسم العقيدة").toList();
        final type2 = filteredBooksData.where((book) => book['book']['Class'] == "قسم الغة العربية و النحو").toList();
        final type3 = filteredBooksData.where((book) => book['book']['Class'] == "قسم الفقه").toList();
        final type4 = filteredBooksData.where((book) => book['book']['Class'] == "قسم السيرة النبوية").toList();
        final type5 = filteredBooksData.where((book) => book['book']['Class'] == "قسم التفسير").toList();
        final type6 = filteredBooksData.where((book) => book['book']['Class'] == "قسم التاريخ").toList();
        final type7 = filteredBooksData.where((book) => book['book']['Class'] == "قسم الثقافة العامة").toList();

        final listOfLists = [
          type1,
          type2,
          type3,
          type4,
          type5,
          type6,
          type7
        ];

        if (filteredBooksData.isEmpty) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset('assets/images/maktaba.png'),
              SizedBox(height: MediaQuery.sizeOf(context).height*0.07,),
                            const Center(child: Text('!لا تحتوي هذه المكتبة على كتب',style: TextStyle(fontSize: 18),)),
              SizedBox(height: MediaQuery.sizeOf(context).height*0.035,),

              Container(
                color: Colors.transparent,
                width: screenSize.width * 0.75,
                child: ElevatedButton(
                  onPressed: () async {
                   final newBook = await  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => AllBooksPage(libraryId: libId, myRefetch: refetch,),
                      ),
                    );
                    if (newBook!=null) {
                      setState(() {
                       filteredBooksData.add(newBook);
  //                     
                      });
                    }
                    
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: secondaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: const Text(
                    "تحديث المكتبة",
                    style: TextStyle(fontSize: 18.0, color: Colors.white),
                  ),
                ),
              ),   
            ],
          );
        }

        // Make sure to update choosenBooksList based on the current page index
      //  if (choosenBooksList.isEmpty && listOfLists.isNotEmpty) {
      //     choosenBooksList = List.from(listOfLists[0]);
      //   }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.14,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: BookType.length,
                  onPageChanged: (index) {
                    setState(() {
                      currentPageIndex = index;
if (listOfLists.isNotEmpty && listOfLists.length > currentPageIndex) {
      choosenBooksList = List.from(listOfLists[currentPageIndex]);
    }
  });                   
                  },
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        
                        decoration: BoxDecoration(
                          
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 7.0,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.height * 0.225,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  border: Border.all(
                                    color: primaryColor,
                                    width: 2.0,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 10.0,
                                      offset: Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    listOfLists[index].length.toString(),
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.black,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'قسم الكتاب',
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                  Text(
                                    BookType[index],
                                    style: TextStyle(
                                      color: primaryColor,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            
                CustomPageIndicator(selectedIndex:currentPageIndex, itemCount: BookType.length,),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
             choosenBooksList.isNotEmpty? Container(
              //color: Colors.red,
              height: MediaQuery.sizeOf(context).height*0.45,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal:15.0),
                child: ListView.builder(
                  itemCount: choosenBooksList.length,
                  itemBuilder: (context, index) {
                    final bookData = choosenBooksList[index];
                    if (bookData == null || bookData['book'] == null) {
                      return Text('No book data available');
                    }
                
                    final book = bookData['book'];
                    return InkWell(
                      hoverColor: Colors.black,
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: primaryColor,
                              ),
                              child: Center(
                                child: Image.asset('assets/icons/book.png'),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  book['bookName'] ?? 'Unknown Book',
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  book['Creator'] ?? 'Unknown Creator',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ): Container(
        height: MediaQuery.sizeOf(context).height*0.45,                child:Center(child: Text('هذا القسم لا يحتوي على كتب'),)),
          
          
           
          ],
        ),
         Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom:10.0),
              child: Container(
                color: Colors.transparent,
                height: MediaQuery.sizeOf(context).height*0.07,
                width: MediaQuery.sizeOf(context).width*0.8,
                child: ElevatedButton(
                  onPressed: () async {
                   final newBook = await  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => AllBooksPage(libraryId: libId, myRefetch: refetch,),
                      ),
                    );
                    if (newBook!=null) {
                      setState(() {
                        filteredBooksData.add(newBook);
                      });
                    }
                    
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: secondaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: const Text(
                    "تحديث المكتبة",
                    style: TextStyle(fontSize: 18.0, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
