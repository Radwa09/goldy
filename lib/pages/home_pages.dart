import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

// Custom Button Widget
class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.color,
  });

  final String text;
  final void Function()? onPressed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 2,
        child: TextButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(color),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
          onPressed: onPressed,
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

// Colors
class AppColors {
  static const Color goldColor = Color(0xFFFFD700);
  static const Color silverColor = Color(0xFFC0C0C0);
  static const Color backgroundColor = Colors.black;
}

// Home Screen
class HomePages extends StatefulWidget {
  const HomePages({super.key});

  @override
  State<HomePages> createState() => _HomePagesState();
}

class _HomePagesState extends State<HomePages> {
  bool showPrice = false;
  String selectedMetal = '';
  double? price;
  bool isLoading = false;

  final Dio dio = Dio();

  // API CALL
  Future<void> fetchPrice(String symbol) async {
    setState(() {
      isLoading = true;
    });

    try {
      final response =
      await dio.get('https://api.gold-api.com/price/$symbol');

      setState(() {
        price = (response.data['price'] as num).toDouble();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        price = null;
      });
    }
  }

  void selectGold() {
    setState(() {
      showPrice = true;
      selectedMetal = 'Gold';
    });
    fetchPrice('XAU');
  }

  void selectSilver() {
    setState(() {
      showPrice = true;
      selectedMetal = 'Silver';
    });
    fetchPrice('XAG');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: const Text(
          'Gold Tracker',
          style: TextStyle(
            color: AppColors.goldColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: showPrice
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              selectedMetal == 'Gold' ? '🏆' : '🥈',
              style: const TextStyle(fontSize: 100),
            ),
            const SizedBox(height: 30),

            // السعر من API
            Text(
              isLoading
                  ? 'Loading...'
                  : price != null
                  ? '${price!.toStringAsFixed(2)} USD'
                  : 'Error',
              style: TextStyle(
                color: selectedMetal == 'Gold'
                    ? AppColors.goldColor
                    : AppColors.silverColor,
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 50),

            ElevatedButton(
              onPressed: () {
                setState(() {
                  showPrice = false;
                  price = null;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedMetal == 'Gold'
                    ? AppColors.goldColor
                    : AppColors.silverColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 50,
                  vertical: 15,
                ),
              ),
              child: const Text(
                'Back',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      )
          : Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomButton(
            text: 'Gold',
            onPressed: selectGold,
            color: AppColors.goldColor,
          ),
          const SizedBox(height: 15),
          CustomButton(
            text: 'Silver',
            onPressed: selectSilver,
            color: AppColors.silverColor,
          ),
        ],
      ),
    );
  }
}
