import 'package:flutter/material.dart';

class BeliTiket extends StatefulWidget {
  const BeliTiket({super.key});

  @override
  State<BeliTiket> createState() => _BeliTiketState();
}

class _BeliTiketState extends State<BeliTiket> {
  @override
  Widget build(BuildContext context) {
    List<String> tiketImages = [
      "assets/images/Tiket masuk.png",
      "assets/images/kolam dewasa.png",
      "assets/images/kolam anak-anak.png"
    ];
    List<ListItem> items = [
      ListItem(name: "Tiket masuk", harga: 15000),
      ListItem(name: "Tiket kolam dewasa", harga: 10000),
      ListItem(name: "Tiket kolam anak-anak", harga: 15000),
    ];

    return Scaffold(
      backgroundColor: const Color.fromRGBO(199, 223, 240, 1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Center(child: Text('Beli Tiket')),
        actions: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Image.asset('assets/images/logo.png'),
          )
        ],
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: SafeArea(
            child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(bottom: 50),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 50,
                  // color: Colors.amber,
                  child: Image.asset(
                    'assets/icons/iconoir_profile-circle.png',
                    height: 40,
                  ),
                ),
                const SizedBox(height: 30),
                ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 3,
                    itemBuilder: (BuildContext context, int index) {
                      ListItem item = items[index];
                      return ItemWidget(item: item, image: tiketImages[index]);
                    })
              ],
            ),
          ),
        )),
      ),
      floatingActionButton: FloatingActionButton.extended(
          backgroundColor: const Color.fromRGBO(114, 136, 214, 1),
          onPressed: () {
            debugPrint(items[0].counter.toString());
            debugPrint(items[1].counter.toString());
            debugPrint(items[2].counter.toString());
          },
          label: const Text(
            "Lanjut Bayar",
            style: TextStyle(color: Colors.white),
          )),
    );
  }
}

class ListItem {
  String name;
  int harga;
  int counter;

  ListItem({required this.name, required this.harga, this.counter = 0});
}

class ItemWidget extends StatefulWidget {
  final ListItem item;
  final String image;

  ItemWidget({required this.item, required this.image});

  @override
  _ItemWidgetState createState() => _ItemWidgetState();
}

class _ItemWidgetState extends State<ItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      height: 200,
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(widget.image),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(children: [
                Expanded(
                    child: Container(
                        // color: Colors.blueGrey,
                        )),
                Container(
                  padding: const EdgeInsets.all(12),
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(widget.item.name),
                      Text(widget.item.harga.toString()),
                    ],
                  ),
                )
              ]),
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 50,
            // color: Colors.deepPurple,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                    onPressed: () {
                      setState(() {
                        widget.item.counter += 1;
                      });
                    },
                    icon: Icon(Icons.add_circle_outline)),
                Text(widget.item.counter.toString()),
                IconButton(
                    onPressed: () {
                      setState(() {
                        if (widget.item.counter > 0) {
                          widget.item.counter -= 1;
                        }
                      });
                    },
                    icon: Icon(Icons.remove_circle_outline)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
