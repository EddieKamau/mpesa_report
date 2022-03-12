import 'package:flutter/material.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({ Key? key }) : super(key: key);

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  bool isSearching = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isSearching ? _searchField() : const Text('Sent Transactions'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              onPressed: (){
                setState(() {
                  isSearching = !isSearching;
                });
              }, 
              icon: Icon(isSearching ? Icons.clear_outlined :Icons.search_outlined)
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView.builder(
          itemCount: 27,
          itemBuilder: (_, index){
            return ListTile(
              leading: const Text('TType'),
              title: const Text('To: 254712345678'),
              subtitle: Text(DateTime.now().toString().substring(0, 16)),
              trailing: Text('Ksh. ${index}00', style: TextStyle(color: index.isEven ? Colors.green : Colors.redAccent,)),
              onTap: (){
                showDialog(
                  context: context, 
                  builder: (_)=> const Dialog(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text(
                        'aggsfsts aghshdh asgs asjdhwd ajdxjd ajdjasd akdhsh adkskd',
                        style: TextStyle(fontSize: 16, letterSpacing: 1.15, wordSpacing: 1.2, height: 1.2),
                      ),
                    ),
                  )
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _searchField()=> Container(
    padding: const EdgeInsets.all(10),
    height: 50,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20)
    ),
    child: TextField(
      decoration: const InputDecoration(
        hintText: 'Search'
      ),
      onChanged: (String val){
        if(val.isEmpty){
          setState(() {
            isSearching = false;
          });
        }else{
          // search
        }
      },
    ),
  );
}