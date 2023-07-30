import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:relax_tik/view/beli_tiket.dart';
import 'package:relax_tik/view/detail_transaksi.dart';

import '../format/converter.dart';
import '../view_model/login_controller.dart';
import '../view_model/tiket-controller.dart';
import 'lainnya.dart';
import 'login.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

final FirebaseAuth _auth = FirebaseAuth.instance;

final User? user = _auth.currentUser;

class _DashboardState extends State<Dashboard> {
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
      () => Provider.of<TiketController>(context, listen: false)
          .fetchRiwayat(user?.email),
    );
  }

  // String isAdmin = 'admin@gmail.com';
  Future<void> checkAdminStatus() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final String? userEmail = user?.email;
    isAdmin = (userEmail ==
        'admin@gmail.com'); // Replace with your actual admin email.

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var mediaquery = MediaQuery.of(context).size;
    final ref = Provider.of<TiketController>(context, listen: false);
    List judul = ['Home', 'Profil'];
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
              buildNavItem(1, Icons.explore_outlined, 'Profil'),
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

class Home extends StatelessWidget {
  const Home({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ref = Provider.of<LoginController>(context, listen: false);

    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(
              height: 50,
              // color: Colors.amber,
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                Image.asset(
                  'assets/icons/iconoir_profile-circle.png',
                  height: 40,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  'Selamat datang, ${ref.user?.nama}',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                )
              ]),
            ),
            const SizedBox(
              height: 20,
            ),
            const SizedBox(
              height: 40,
              // color: Colors.blue,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      'Rp.',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    '200.000',
                    style: TextStyle(
                      fontSize: 35,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              height: 100,
              // color: Colors.cyan,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MyButton(
                    icon: Image.asset('assets/icons/tickets.png'),
                    label: 'Beli Tiket',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return const BeliTiket();
                          },
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 70),
                  MyButton(
                      icon: Image.asset('assets/icons/more.png'),
                      label: 'Lainnya',
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Lainnya()));
                      }),
                ],
              ),
            ),
            const SizedBox(height: 70),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Riwayat Transaksi',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              child: Consumer<TiketController>(
                builder: (context, cont, _) {
                  final i = cont.pesanan;
                  if (cont.requestState == RequestState.loading) {
                    return const SizedBox(
                        // height: mediaquery.height,
                        child: Center(child: CircularProgressIndicator()));
                  }

                  if (cont.requestState == RequestState.loaded) {
                    if (i != null) {
                      return ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          padding: const EdgeInsets.all(8),
                          itemCount: cont.pesanan.length,
                          itemBuilder: (BuildContext context, int index) {
                            final item = Provider.of<TiketController>(context,
                                    listen: false)
                                .pesanan[index];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 20),
                              padding: const EdgeInsets.all(20.0),
                              height: 120,
                              color: const Color.fromRGBO(84, 87, 84, 0.12),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.pemesan,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        DateFormatter
                                            .formatToDDMMYYYYWithMonthName(
                                                item.createdAt),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                          FormatRupiah.format(double.parse(
                                              item.totalAmount.toString())),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600)),
                                      if (item.status != "pending")
                                        Text(
                                          item.status,
                                          style: item.status == 'pending'
                                              ? const TextStyle(
                                                  fontWeight: FontWeight.w300,
                                                  color: Colors.red)
                                              : const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.green),
                                        ),
                                      if (item.status == 'pending')
                                        TextButton(
                                          onPressed: () async {
                                            log('id : ${item.id}');

                                            final con =
                                                Provider.of<TiketController>(
                                                    context,
                                                    listen: false);
                                            cont.getPendingPesanan(id: item.id);
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                              builder: (context) {
                                                return DetailTransaksi(
                                                    statusPage:
                                                        'pending_bayar');
                                              },
                                            ));
                                          },
                                          style: TextButton.styleFrom(
                                            foregroundColor: Colors.white,
                                            backgroundColor: Colors.red,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                          ),
                                          child: Text(item.status),
                                        ),
                                    ],
                                  )
                                ],
                              ),
                            );
                          });
                    } else if (i == '[]') {
                      return const Center(child: Text("Belum ada transaksi"));
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
              ),
            ),
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
                Provider.of<LoginController>(context, listen: false).logout();
                await Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Login()),
                );
                // con.itemCart = [];
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
