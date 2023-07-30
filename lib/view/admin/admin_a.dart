import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:relax_tik/model/tiket_model.dart';
import 'package:relax_tik/view_model/tiket-controller.dart';

import '../../format/converter.dart';
import '../../model/Pesanan.dart';
import '../../view_model/login_controller.dart';
import '../component/dialog.dart';
import '../login.dart';
import 'detail_pesanan.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

final FirebaseAuth _auth = FirebaseAuth.instance;

final User? user = _auth.currentUser;

class _AdminDashboardState extends State<AdminDashboard> {
  final int _selectedIndex = 0;

  late List<Widget> _pages;
  late int currentIndex;
  int selectedIndex = 0;

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  void updateView(int index) {
    setState(() {
      var con = Provider.of<TiketController>(context, listen: false);
      currentIndex = index;
      _pages = [
        const Home(),
        const Wisata(),
        const Profile(),
      ];
    });
  }

  bool isAdmin = false;
  @override
  void initState() {
    updateView(0);
    super.initState();

    Future.microtask(
      () => Provider.of<TiketController>(context, listen: false).refreshCart(),
    );

    Future.microtask(
      () =>
          Provider.of<TiketController>(context, listen: false).fetchRiwayaAll(),
    );
  }

  // String isAdmin = 'admin@gmail.com';

  @override
  Widget build(BuildContext context) {
    var mediaquery = MediaQuery.of(context).size;
    final ref = Provider.of<TiketController>(context, listen: false);
    List judul = ['Home', 'Data wisata', 'Profil'];
    return Scaffold(
      backgroundColor: const Color.fromRGBO(199, 223, 240, 1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Center(child: Text(judul[currentIndex])),
        actions: [
          InkWell(
            onTap: () async {
              print("logouted");
              Provider.of<LoginController>(context, listen: false).logout();

              await Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const Login()),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Image.asset('assets/images/logo.png'),
            ),
          )
        ],
      ),
      extendBodyBehindAppBar: true,
      body: RefreshIndicator(
        onRefresh: ref.reloadHalaman,
        child: SafeArea(child: _pages[currentIndex]),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              buildNavItem(0, Icons.home, 'Home'),
              buildNavItem(1, Icons.explore_outlined, 'Wisata'),
              buildNavItem(2, Icons.explore_outlined, 'Profil'),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildNavItem(int index, IconData iconData, String text) {
    final isActive = currentIndex == index;
    final color = isActive ? Colors.orange : Colors.grey;
    return InkWell(
      onTap: () {
        updateView(index);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            iconData,
            color: color,
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            text,
          )
        ],
      ),
    );
  }
}

class Wisata extends StatefulWidget {
  const Wisata({super.key});

  @override
  State<Wisata> createState() => _WisataState();
}

class _WisataState extends State<Wisata> {
  @override
  void initState() {
    super.initState();

    Future.microtask(
      () => Provider.of<TiketController>(context, listen: false).refreshCart(),
    );

    Future.microtask(
      () => Provider.of<TiketController>(context, listen: false).fetchTiket(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(199, 223, 240, 1),
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
                      const SizedBox(height: 30),
                      Container(child: Consumer<TiketController>(
                        builder: (context, cont, _) {
                          final i = cont.dataTiketWisata;
                          if (cont.requestState == RequestState.loading) {
                            return const SizedBox(
                                // height: mediaquery.height,
                                child:
                                    Center(child: CircularProgressIndicator()));
                          }

                          if (cont.requestState == RequestState.loaded) {
                            if (i != null) {
                              return ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  shrinkWrap: true,
                                  padding: const EdgeInsets.all(8),
                                  itemCount: cont.dataTiketWisata.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final item = Provider.of<TiketController>(
                                            context,
                                            listen: false)
                                        .dataTiketWisata[index];
                                    return Container(
                                      margin: const EdgeInsets.only(bottom: 20),
                                      padding: const EdgeInsets.all(20.0),
                                      height: 150,
                                      color: const Color.fromRGBO(
                                          84, 87, 84, 0.12),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            height: 50,
                                            // color: Colors.amber,
                                            child: Image.network(
                                              item.gambar,
                                              height: 40,
                                            ),
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item.nama,
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              Text(
                                                  FormatRupiah.format(
                                                      double.parse(item
                                                          .hargaTiket
                                                          .toString())),
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600)),
                                            ],
                                          ),
                                          const SizedBox(
                                            width: 50,
                                          ),
                                          Column(
                                            children: [
                                              Align(
                                                  alignment: Alignment.topRight,
                                                  child: WidgetDialog(
                                                    status: "update",
                                                    wisata: TiketModel(
                                                        docId: item.docId,
                                                        nama: item.nama,
                                                        hargaTiket:
                                                            item.hargaTiket,
                                                        gambar: item.gambar,
                                                        counter: item.counter),
                                                  )),
                                              Align(
                                                  alignment: Alignment.topRight,
                                                  child: WidgetDialogDelete(
                                                    status: "delete",
                                                    wisata: TiketModel(
                                                        docId: item.docId,
                                                        nama: item.nama,
                                                        hargaTiket:
                                                            item.hargaTiket,
                                                        gambar: item.gambar,
                                                        counter: item.counter),
                                                  ))
                                            ],
                                          )
                                        ],
                                      ),
                                    );
                                  });
                            } else if (i == '[]') {
                              return const Center(
                                  child: Text("Belum ada transaksi"));
                            } else {
                              return const CircularProgressIndicator();
                            }
                          } else if (cont.requestState == RequestState.error) {
                            return SizedBox(
                                height: MediaQuery.of(context).size.height,
                                child: const Text("Error cant get Data"));
                          }
                          return const Text("");
                        },
                      ))
                    ]),
              ),
            ),
          ),
        ),
        floatingActionButton: WidgetDialogAdd(
          status: "tambah Data",
        ));
  }
}

class Home extends StatelessWidget {
  const Home({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ref = Provider.of<TiketController>(context, listen: false);

    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    return SingleChildScrollView(
      physics: const ScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  ref.reloadHalaman();
                },
                child: const Text(
                  "Data Pesanan User",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            DataTable(
                columns: const <DataColumn>[
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'No.',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Pemesan',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Status',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Aksi',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                ],
                rows: List<DataRow>.generate(ref.pesanan.length, (index) {
                  // print('jumlah peasanan : ${pesanan.length}');
                  // // print(pesanan[index].id);
                  // print('cek');
                  List<PesananElement> jenisTiket = ref.pesanan[index].pesanan;
                  int jumlahTiket = 0;
                  for (var element in jenisTiket) {
                    jumlahTiket += element.counter;
                  }
                  return DataRow(
                    cells: [
                      DataCell(Text((no++).toString())),
                      DataCell(Text(ref.pesanan[index].pemesan)),
                      DataCell(Text(ref.pesanan[index].status)),
                      DataCell(InkWell(
                          onTap: () {
                            print(ref.pesanan[index].pemesan);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return DetailPesanan(
                                      emailUser: ref.pesanan[index].pemesan);
                                },
                              ),
                            );
                          },
                          child: const Text("Detail"))),
                    ],
                  );
                })),
          ],
        ),
      ),
    );
  }
}

class MyButton extends StatelessWidget {
  const MyButton({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
  });
  final void Function()? onTap;
  final Widget icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(10.0),
            height: 50,
            width: 50,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(50)),
            child: icon,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w500),
        )
      ],
    );
  }
}

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    final ref = Provider.of<LoginController>(context, listen: false);

    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 200,
              width: 200,
              child: Image.asset('assets/icons/icon _profile circle_.png'),
            ),
            const SizedBox(height: 20),
            Text(
              ref.user!.nama.toString(),
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
                  children: [Text('Lokasi'), Icon(Icons.map_outlined)],
                ),
              ),
            ),
            const SizedBox(height: 15),
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
                    Text('Komentar dan Penilaian'),
                    Icon(Icons.thumb_up_alt_outlined)
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
            GestureDetector(
              onTap: () async {
                _showAlertDialog(context);
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
                    Text(
                      'Log out',
                      style: TextStyle(color: Colors.red),
                    ),
                    Icon(
                      Icons.logout_outlined,
                      color: Colors.red,
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
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

                // con.itemCart = [];a
                await Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Login()),
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue, // Button background color
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
