import 'package:flutter/material.dart';

class LikortPayCash extends StatefulWidget {
  const LikortPayCash({super.key});

  @override
  State<LikortPayCash> createState() => _LikortPayCashState();
}

class _LikortPayCashState extends State<LikortPayCash> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pay Cash'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 300,
                child: ListView.builder(
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text('Item ${index + 1}'),
                    );
                  },
                ),
              ),
            ),
            ElevatedButton(onPressed: (){
              Navigator.of(context).pushNamed('/likortcompletedorder');
            }, child: const Text('paid'),),
          ],
        ),
      ),
    );
  }
}
