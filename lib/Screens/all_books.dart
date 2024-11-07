import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:masjidi/Constants/constants.dart';
import 'package:masjidi/Screens/add_book.dart';

class AllBooksPage extends StatefulWidget {
  const AllBooksPage({super.key, required this.libraryId, this.myRefetch,});
final String libraryId;
final Function? myRefetch;


  @override
  State<AllBooksPage> createState() => _AllBooksPageState();
}

class _AllBooksPageState extends State<AllBooksPage> {
  String getAllBooksQuery = """
  query {
    getAllBook {
      ... on Error {
        message
      }
      ... on book {
        id
        bookName
        numberOfPart
        Class
        Creator
        detecteur
        DarNacher
        DateOfPublier
        Country
        interdit
      }
    }
  }
  """;

  String addBookToLibrary = r""" 
 mutation addBookToLib($BookId: ID!, $libraryId: ID!, $numberOfBook: Int!, $dateOfEnterLib: String!) {
  addBookToLib(BookId: $BookId, libraryId: $libraryId, numberOfBook: $numberOfBook, dateOfEnterLib: $dateOfEnterLib) {
    ... on Error {
      message
    }
   
  }
}

  
  """;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'البحث عن كتاب',
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
      ),
      body: Query(
        options: QueryOptions(
          document: gql(getAllBooksQuery),
        ),
        builder: (QueryResult result, {fetchMore, refetch}) {
          if (result.hasException) {
            return Center(
              child: Text(result.exception.toString()),
            );
          }

          if (result.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          List books = result.data?['getAllBook'] ?? [];

          if (books.isEmpty) {
            return const Center(
              child: Text('No books available'),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: books.length,
                  itemBuilder: (context, index) {
                    var book = books[index];
                    return InkWell(
                      onTap: () {
  TextEditingController numberOfBooksController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('إضافة الكتاب'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'إذا كنت تريد إضافة هذا الكتاب إلى هذه المكتبة، يرجى إدخال عدد الكتب:',
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: numberOfBooksController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                hintText: 'عدد الكتب',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); 
            },
            child: Text('إلغاء', style: TextStyle(color: Colors.red)),
          ),
          Mutation(
            options: MutationOptions(
              
              document: gql(addBookToLibrary),
              onError: (error) {
                print('error adding a book: $error');
              },
              update: (GraphQLDataProxy cache, QueryResult? result) {
          return cache;
        },
              onCompleted: (dynamic resultData) {
                final newBook = {
                  'BookId': book['id'],
                      'libraryId': widget.libraryId,
                      'numberOfBook': int.parse(numberOfBooksController.text),
                      'dateOfEnterLib': DateTime.now().toIso8601String(),
                };
                widget.myRefetch;
                Navigator.pop(context,newBook); 
                print(resultData);
                if (resultData != null) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: primaryColor,
                    content: Text('تمت إضافة الكتاب بنجاح'),
                     

                  ));
                 
 Navigator.pop(context,newBook);
                widget.myRefetch;



                }
                widget.myRefetch;
              },
            ),
            builder: (RunMutation runMutation, QueryResult? result) {
              return TextButton(
                onPressed: () {
                  if (numberOfBooksController.text.isNotEmpty) {
                    print('book id is : ${book['id']}');
                    print('library id is : ${widget.libraryId}');
                    print('number of book is : ${numberOfBooksController.text}');
                    print('day is : ${DateTime.now().toIso8601String()}');
                    runMutation({
                      'BookId': book['id'],
                      'libraryId': widget.libraryId,
                      'numberOfBook': int.parse(numberOfBooksController.text),
                      'dateOfEnterLib': DateTime.now().toIso8601String(),
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('يرجى إدخال عدد الكتب'),
                    ));
                  }
                },
                child: Text(
                  'تأكيد',
                  style: TextStyle(color: primaryColor),
                ),
              );
            },
          ),
        ],
      );
    },
  );
},

                      child: Padding(
                        padding:
                            const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        child: Container(
                          height: screenSize.height * 0.225,
                          width: 75,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                offset: Offset(1, 1),
                                blurRadius: 6,
                                spreadRadius: 1,
                              ),
                            ],
                            color: Color(0XFFF3F3F3),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                        onPressed: () {},
                                        icon: const Icon(Icons.copy_all)),
                                    Text(
                                      book['bookName'] ?? '',
                                      style: TextStyle(
                                          color: primaryColor,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'المؤلف: ',
                                            style: TextStyle(
                                              color: secondaryColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(
                                            text: book['Creator'] ?? '',
                                            style: const TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'المحقق: ',
                                            style: TextStyle(
                                              color: secondaryColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(
                                            text: book['detecteur'] ?? '',
                                            style: const TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  height: 45,
                                  margin: EdgeInsets.all(2),
                                  child: Row(
                                    textDirection: TextDirection.rtl,
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: primaryColor,
                                            borderRadius: BorderRadius.circular(30),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  book['DateOfPublier'] ?? '',
                                                  style: const TextStyle(
                                                    
                                                      color: Colors.white),
                                                ),
                                                Icon(
                                                  Icons.calendar_month,
                                                  color: Colors.white,
                                                  
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: primaryColor,
                                            borderRadius: BorderRadius.circular(30),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.all(5.0),
                                                child: Text(
                                                  book['DarNacher'] ?? 'دار النشر',
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                              const Padding(
                                                padding: EdgeInsets.all(5.0),
                                                child: Icon(
                                                  
                                                  Icons.edit,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: primaryColor,
                                            borderRadius: BorderRadius.circular(30),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.all(5.0),
                                                child: Text(
                                                  book['numberOfPart']
                                                      ?.toString() ??
                                                      '',
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                              const Padding(
                                                padding: EdgeInsets.all(5.0),
                                                child: Icon(
                                                  Icons.book,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
                child: SizedBox(
                  height: screenSize.height * 0.065,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                        
Navigator.push<void>(
    context,
    MaterialPageRoute<void>(
      builder: (BuildContext context) => AddBook(),
    ),
  );
                    },
                    child: const Text('أضف كتاب'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
