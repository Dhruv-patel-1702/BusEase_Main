import 'package:bus_ease/providers/user_provider.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:provider/provider.dart';

class Ticket extends StatelessWidget {
  const Ticket({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 15, 20, 5),
                    child: Center(
                      child: Text(
                        '1234-5678-XXXX-XXXX',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: Row(
                      children: [
                        Container(
                          transform: Matrix4.translationValues(-10, 0, 0),
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                            color: const Color(0xff383E48),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        const Expanded(
                          child: DottedLine(
                            direction: Axis.horizontal,
                            lineLength: double.infinity,
                            lineThickness: 3.0,
                            dashLength: 7.0,
                            dashColor: Color(0xff383E48),
                            dashRadius: 0.0,
                            dashGapLength: 5.0,
                            dashGapColor: Colors.transparent,
                            dashGapRadius: 0.0,
                          ),
                        ),
                        Container(
                          transform: Matrix4.translationValues(10, 0, 0),
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                            color: const Color(0xff383E48),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Unjha',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'Kherva',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                            color: const Color(0xffFBC420),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 3,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Color(0xffFBC420),
                                  Color(0xff19C956),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                            color: const Color(0xff19C956),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'ID:',
                                style: TextStyle(
                                  color: Color(0xffA7A7A7),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                Provider.of<UserProvider>(context,
                                        listen: false)
                                    .user!
                                    .id,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'Passenger:',
                                style: TextStyle(
                                  color: Color(0xffA7A7A7),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                '${Provider.of<UserProvider>(context, listen: false).user!.firstName} ${Provider.of<UserProvider>(context, listen: false).user!.middleName.substring(0, 1)}.  ${Provider.of<UserProvider>(context, listen: false).user!.lastName}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'Date:',
                                style: TextStyle(
                                  color: Color(0xffA7A7A7),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const Text(
                                '28 July 2024',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'Depot:',
                                style: TextStyle(
                                  color: Color(0xffA7A7A7),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const Text(
                                'Palanpur',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Column(
                            children: [
                              const SizedBox(height: 30),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(
                                    10), // Adjust the radius as needed
                                child: SizedBox(
                                  height: 160.0,
                                  width: 140.0,
                                  child: Image.asset(
                                    'assets/images/avatar_male.jpg',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const Text(
                                'Total:',
                                style: TextStyle(
                                  color: Color(0xffA7A7A7),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Padding(
                    padding: EdgeInsets.only(
                        top: 4, left: 20, bottom: 10, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Type:',
                              style: TextStyle(
                                color: Color(0xffA7A7A7),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              'Student',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total:',
                              style: TextStyle(
                                color: Color(0xffA7A7A7),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              'Full : 1 x 26.00 = 26.00 INR',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: Row(
                      children: [
                        Container(
                          transform: Matrix4.translationValues(-10, 0, 0),
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                            color: const Color(0xff383E48),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        const Expanded(
                          child: DottedLine(
                            direction: Axis.horizontal,
                            lineLength: double.infinity,
                            lineThickness: 3.0,
                            dashLength: 7.0,
                            dashColor: Color(0xff383E48),
                            dashRadius: 0.0,
                            dashGapLength: 5.0,
                            dashGapColor: Colors.transparent,
                            dashGapRadius: 0.0,
                          ),
                        ),
                        Container(
                          transform: Matrix4.translationValues(10, 0, 0),
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                            color: const Color(0xff383E48),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: SizedBox(
                      height: 150,
                      width: 150,
                      child: PrettyQrView.data(
                        data: "Hello Mahavir patel",
                        decoration: const PrettyQrDecoration(
                          shape: PrettyQrSmoothSymbol(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                // Download above container as a Ticket in pdf format with the help of pdf package
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xffFBC420),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Text(
                    'Download Ticket',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
