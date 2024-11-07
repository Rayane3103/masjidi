import 'package:flutter/material.dart';
import 'package:masjidi/Constants/constants.dart';
import 'package:masjidi/Screens/firsttime/imam_vetor.dart';

class OTPPage extends StatefulWidget {
  final String phoneNumber;
  final Map<String, dynamic>? resultData;

  OTPPage({required this.phoneNumber, required this.resultData});

  @override
  _OTPPageState createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  final List<TextEditingController> _otpControllers = List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  String _obscurePhoneNumber(String phoneNumber) {
    if (phoneNumber.length < 8) return phoneNumber; // In case the number is too short
    return phoneNumber.substring(6, 10) + '****' + phoneNumber.substring(0,2); // Hide middle digits
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String obscuredPhone = _obscurePhoneNumber(widget.phoneNumber);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
         automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
Container(
        
          height: 40,
          width: 40,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(40),color: primaryColor),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white,size: 20,),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
            Text(
              'تاكيد رقم الهاتف',
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            const SizedBox(height: 10),
            RichText(
  textAlign: TextAlign.center,
  text: TextSpan(
    style: const TextStyle(
      fontSize: 16,
      color: Colors.black, // Adjust color as per your theme
    ),
    children: [
      const TextSpan(text: 'تم إرسال كود الي تأكيد رقم هاتفك '),
      TextSpan(
        text: obscuredPhone,  // Display the dynamic phone number
        style: const TextStyle(
          fontWeight: FontWeight.bold, // You can change style as needed
          fontFamily: 'Roboto',  // Optional: Using a different font for English text
        ),
      ),
    ],
  ),
),

            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) => _otpBox(context, index)),
            ),
            const SizedBox(height: 10),
             Text(
              textAlign: TextAlign.center,
              'لم يصل أي رمز ؟ إعادة الإرسال',
              style: TextStyle(
                color: primaryColor,
                decoration: TextDecoration.underline,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                String otp = _otpControllers.map((controller) => controller.text).join();
                print("OTP entered: $otp");
                Navigator.push(context,MaterialPageRoute<void>(
      builder: (BuildContext context) =>   ImamVetor(resultData: widget.resultData,),
    ),); 
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'إرسال',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _otpBox(BuildContext context, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      width: 50,
      height: 60,
      child: TextField(
        controller: _otpControllers[index],
        focusNode: _focusNodes[index],
        maxLength: 1,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          counterText: "",
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.orange, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.orange, width: 2),
          ),
        ),
        onChanged: (value) {
          if (value.isNotEmpty && index < 3) {
            FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
          } else if (value.isEmpty && index > 0) {
            FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
          }
        },
      ),
    );
  }
}