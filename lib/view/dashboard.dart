import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:relax_tik/view/beli_tiket.dart';

import '../format/converter.dart';
import '../view_model/login_controller.dart';
import '../view_model/tiket-controller.dart';
import 'login.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;
  static const List<Map> _widgetOptions = <Map>[
    {'widget': Beranda(), 'judul': 'Beranda'},
    {'widget': Center(child: Text('QR Code')), 'judul': 'QR Code'},
    {'widget': Center(child: Text('Pengaturan')), 'judul': 'Pengaturan'},
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();

    Future.microtask(
      () => Provider.of<TiketController>(context, listen: false).fetchRiwayat(),
    );
  }

  @override
  Widget build(BuildContext context) {
    var mediaquery = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color.fromRGBO(199, 223, 240, 1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Center(
            child: Text(_widgetOptions.elementAt(_selectedIndex)['judul'])),
        actions: [
          InkWell(
            onTap: () async {
              print("logouted");
              await Provider.of<LoginController>(context, listen: false)
                  .logout();

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Login()),
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
      body: _widgetOptions.elementAt(_selectedIndex)['widget'],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code),
            label: 'QR Code',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: 'Pengaturan',
          ),
        ],
        currentIndex: _selectedIndex,
        // selectedItemColor: Colors.amber[800],
        fixedColor: Colors.amber,
        onTap: _onItemTapped,
      ),
    );
  }
}

class Beranda extends StatelessWidget {
  const Beranda({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var mediaquery = MediaQuery.of(context).size;
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(
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
                      const Text(
                        'Selamat datang, ......',
                        style: TextStyle(fontWeight: FontWeight.w700),
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
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700),
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
                              return BeliTiket();
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
                              builder: (context) {
                                return BeliTiket();
                              },
                            ),
                          );
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
                      return SizedBox(
                          // height: mediaquery.height,
                          child: Center(child: CircularProgressIndicator()));
                    }
                    if (cont.requestState == RequestState.loaded) {
                      if (i != null) {
                        return ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            padding: const EdgeInsets.all(8),
                            itemCount: cont.pesanan.length,
                            itemBuilder: (BuildContext context, int index) {
                              final item = Provider.of<TiketController>(context,
                                      listen: false)
                                  .pesanan[index];
                              return Container(
                                margin: const EdgeInsets.only(bottom: 20),
                                padding: EdgeInsets.all(20.0),
                                height: 100,
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
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                            FormatRupiah.format(double.parse(
                                                item.totalAmount.toString())),
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600)),
                                        Text(item.status,
                                            style: item.status == 'pending'
                                                ? TextStyle(
                                                    fontWeight: FontWeight.w300,
                                                    color: Colors.red)
                                                : TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.green)),
                                      ],
                                    )
                                  ],
                                ),
                              );
                            });
                      } else {
                        return const CircularProgressIndicator();
                      }
                    } else if (cont.requestState == RequestState.error) {
                      return SizedBox(
                          height: mediaquery.height,
                          child: Text("Error cant get Data"));
                    }
                    return Text("");
                  },
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}

class MyButton extends StatelessWidget {
  MyButton({
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
        SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.w500),
        )
      ],
    );
  }
}
