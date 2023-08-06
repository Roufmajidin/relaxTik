import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:relax_tik/view/beli_tiket.dart';
import 'package:relax_tik/view/detail_transaksi.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../format/converter.dart';
import '../view_model/login_controller.dart';
import '../view_model/tiket-controller.dart';
import 'lainnya.dart';
import 'login.dart';

class Dashboard extends StatefulWidget {
  Dashboard({
    super.key,
  });

  @override
  State<Dashboard> createState() => _DashboardState();
}

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
      final prov = Provider.of<LoginController>(context, listen: false);

      currentIndex = index;
      _pages = [
        Home(email: prov.user?.email),
        Profile(email: prov.user?.email),
      ];
    });
  }

  bool isAdmin = false;
  @override
  void initState() {
    super.initState();

    updateView(0);
    refresh();
    print('init');
  }

  Future<void> refresh() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var emaila = prefs.getString('email');
    print('emaila : $emaila');
    Provider.of<TiketController>(context, listen: false)
        .reloadHalamanUser(emaila);
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
        onRefresh: refresh,
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
  var email;

  Home({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    final ref = Provider.of<LoginController>(context, listen: false);
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    print('user ${user?.email}');
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Consumer<LoginController>(
              builder: (context, con, child) => SizedBox(
                height: 50,
                // color: Colors.amber,
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/icons/iconoir_profile-circle.png',
                        height: 40,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Selamat datang, ${con.user?.nama}',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      )
                    ]),
              ),
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
                      'Relaxtik',
                      style:
                          TextStyle(fontSize: 34, fontWeight: FontWeight.w700),
                    ),
                  ),
                  SizedBox(
                    width: 10,
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
                            return BeliTiket(
                              userEmail: email,
                            );
                          },
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 70),
                  MyButton(
                      icon: Image.asset('assets/icons/more.png'),
                      label: 'Lainnya',
                      onTap: () async {
                        // print(email);

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Lainnya(
                                      userEmail: email,
                                    )));
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
                  final i = cont.pesananUserById;
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
                          itemCount: cont.pesananUserById.length,
                          itemBuilder: (BuildContext context, int index) {
                            final item = Provider.of<TiketController>(context,
                                    listen: false)
                                .pesananUserById[index];
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
                                                  statusPage: 'pending_bayar',
                                                  userEmail: email,
                                                );
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
  var email;

  Profile({super.key, required this.email});

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
              ref.user?.email == null ? email : ref.user?.email,
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
        return Consumer<LoginController>(
          builder: (context, value, child) => AlertDialog(
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
                  await value.logout();
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
                child: value.loginState == RequestStateLogin.loading
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ))
                    : Text('Ya'),
              ),
            ],
          ),
        );
      },
    );
  }
}
