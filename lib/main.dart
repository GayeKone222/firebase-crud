import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crud/firebase_options.dart';
import 'package:firebase_crud/functions.dart';
import 'package:firebase_crud/reference.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // text fields' controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();



  /*
await _products.add({"name": name, "price": price});
await _products.update({"name": name, "price": price});
await _products.doc(productId).delete();
*/

  

  @override
  Widget build(BuildContext context) {
     
    return Scaffold(
      body: StreamBuilder(
        stream: products.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
                itemCount: streamSnapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot =
                      streamSnapshot.data!.docs[index];
                  return Card(
                    margin: const EdgeInsets.all(10),
                    child: ListTile(
                      title: Text(documentSnapshot['name']),
                      subtitle: Text(documentSnapshot['price'].toString()),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          children: [
                            // Press this button to edit a single product
                            IconButton(
                                onPressed: () => Functions().update(context,_nameController, _priceController, documentSnapshot),
                                icon: const Icon(Icons.edit))
                         // This icon button is used to delete a single product
                         , IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => Functions().delete(context, documentSnapshot.id))
                        ],
                        ),
                      ),
                    ),
                  );
                });
          }
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        },
      ),
         floatingActionButton: FloatingActionButton(
        onPressed: () => Functions().create(context,_nameController, _priceController,),
        child: const Icon(Icons.add),

      ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat
    
    );
  }
}
