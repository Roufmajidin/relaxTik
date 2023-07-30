import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:relax_tik/view/staging.dart';

import '../view_model/login_controller.dart';

class Lainnya extends StatelessWidget {
  const Lainnya({super.key});

  @override
  Widget build(BuildContext context) {
    final ref = Provider.of<LoginController>(context, listen: false);

    return Scaffold(
        backgroundColor: const Color.fromRGBO(199, 223, 240, 1),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Center(child: Text('Detail Lokasi')),
          actions: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Image.asset('assets/images/logo.png'),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 200,
                  width: 200,
                  child: Image.asset('assets/ikon/logo_semen.png'),
                ),
                const SizedBox(height: 20),
                Text(
                  "Relaxtik",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 50),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: 75,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)),
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Alamat',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Palimanan Barat, Kecamatan Gempol, Cirebon',
                              style: TextStyle(),
                            ),
                          ],
                        ),
                        Icon(Icons.map_outlined)
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                GestureDetector(
                  onTap: () {
                    print("buka Maps");
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return const WebViewExample(
                            title: "Lokasi Wisata",
                            url:
                                'https://www.google.com/maps/place/PT+Indocement+TP+Palimanan/@-6.7018752,108.3688419,14z/data=!4m10!1m2!2m1!1sindocement+palimanan!3m6!1s0x2e6edfc8114a110b:0x636c898eeb87aadf!8m2!3d-6.7018752!4d108.4048908!15sChRpbmRvY2VtZW50IHBhbGltYW5hbiIDiAEBkgETY2VtZW50X21hbnVmYWN0dXJlcuABAA!16s%2Fg%2F11bwylj7fs?entry=ttu');
                      },
                    ));
                  },
                  child: Container(
                    height: 75,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)),
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Maps',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Tap untuk membuka Maps',
                              style: TextStyle(),
                            ),
                          ],
                        ),
                        Icon(Icons.map_outlined)
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
        ));
  }

  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pemberitahuan'),
          content: const Text('Apakah yakin anda akan keluar aplikasi ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                print("logouted");
                await Provider.of<LoginController>(context, listen: false)
                    .logout();

                // con.itemCart = [];
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.blue, // Button background color
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(10.0), // Button border radius
                ),
              ),
              child: const Text('Ya'),
            ),
          ],
        );
      },
    );
  }
}
