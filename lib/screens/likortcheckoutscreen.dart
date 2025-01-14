import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../models/likortcartitem.dart';
import '../models/likortusers.dart';

class LikortCheckoutScreen extends StatefulWidget {
  const LikortCheckoutScreen({super.key});

  @override
  State<LikortCheckoutScreen> createState() => _LikortCheckoutScreenState();
}

class _LikortCheckoutScreenState extends State<LikortCheckoutScreen> {
  GoogleMapController? _controller;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  final _deliveryInstructionsController = TextEditingController();
  String? _deliveryInstructions;
  String? _currentAddress;
  String? _selectedPaymentMethod;
  String _selectedOption = 'Delivery';
  bool _isDateSelected = true;
  bool _isCurrentAddress = true;
  bool _isDeliveryInstruction = true;

  @override
  void initState() {
    super.initState();
    _getCurrentAddress();
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });

      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (pickedTime != null && pickedTime != _selectedTime) {
        setState(() {
          _selectedTime = pickedTime;
        });
      }
    }
  }

  Future<void> _getCurrentAddress() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    // final position = await Geolocator.getCurrentPosition();
    // List<Placemark> placemarks = await placemarkFromCoordinates(
    //     position.latitude, position.longitude);
    // Placemark place = placemarks[0];
    // setState(() {
    //   _currentAddress ='${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    // });
  }

  Widget _buildPaymentOption({
    required IconData icon,
    required String label,
    required String value,
  }) {
    final isSelected = _selectedPaymentMethod == value;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue[100] : Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: Colors.blue.withValues(alpha: 0.3),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 32, color: isSelected ? Colors.blue : Colors.grey),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Future<void> fetchAccessToken(BuildContext context) async {
    const String consumerKey = 'L5dKdxWq9SemWTAkaiXm1V06GlOSnpbQytwiqjsrMO5gxT8q'; // Replace with your consumer key
    const String consumerSecret = 'PvoM5NeFGbQTrQvTevun19AVAC3LGFxCD05m1jhnMWBVkFBeTWpB5pr9A2NCHPdn'; // Replace with your consumer secret

    final String auth = 'Basic ${base64Encode(utf8.encode('$consumerKey:$consumerSecret'))}';

    final headers = {
      'Authorization': auth,
    };

    final url = Uri.parse('https://sandbox.safaricom.co.ke/oauth/v1/generate?grant_type=client_credentials');

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        final accessToken = responseBody['access_token'];

        // Store the access token in a suitable place, for example in a state variable
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Access Token: $accessToken')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch data. Status code: ${response.statusCode}')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }
  }

  Future<void> initiateMpesaPayment(String number,String totalAmount) async {
    const consumerKey = 'L5dKdxWq9SemWTAkaiXm1V06GlOSnpbQytwiqjsrMO5gxT8q';
    const consumerSecret = 'PvoM5NeFGbQTrQvTevun19AVAC3LGFxCD05m1jhnMWBVkFBeTWpB5pr9A2NCHPdn';

    final basicAuth = 'Basic ${base64Encode(utf8.encode('$consumerKey:$consumerSecret'))}';

    final headers = {
      'Authorization': basicAuth,
    };

    final http.Response response = await http.get(
      Uri.parse(
          'https://sandbox.safaricom.co.ke/oauth/v1/generate?grant_type=client_credentials'), // Replace with actual Visa API endpoint
      headers: headers,
    );

    print(response.body);
    final Map<String, dynamic> responseData = jsonDecode(response.body);


    // print(response.body);
    // final Map<String, dynamic> responseData = jsonDecode(response.body);
    print(responseData['access_token']);
    final http.Response payresponse = await http.post(
        Uri.parse(
            'https://sandbox.safaricom.co.ke/mpesa/stkpush/v1/processrequest'), // Replace with actual Visa API endpoint
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${responseData['access_token']}"
        },
        body: jsonEncode({
          "BusinessShortCode": "174379",
          "Password":
          "MTc0Mzc5YmZiMjc5ZjlhYTliZGJjZjE1OGU5N2RkNzFhNDY3Y2QyZTBjODkzMDU5YjEwZjc4ZTZiNzJhZGExZWQyYzkxOTIwMTYwMjE2MTY1NjI3",
          "Timestamp": "20160216165627",
          "TransactionType": "CustomerPayBillOnline",
          "Amount": totalAmount,
          "PartyA": "254${number.substring(1)}",
          "PartyB": "174379",
          "PhoneNumber": "254${number.substring(1)}",
          "CallBackURL": "https://mydomain.com/pat",
          "AccountReference": "Test",
          "TransactionDesc": "Test"
        }));
    print(payresponse.body);
  }

  void _makePayment() async{
    var cartitems = Provider.of<CartItem>(context,listen:false);
    var user = Provider.of<User>(context,listen:false);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString('id');
    var currentUser = user.users.firstWhere((item)=>item.id == userId);
    print(_selectedPaymentMethod);
    if (_currentAddress == null &&
        (_selectedDate == null && _selectedTime == null) &&
        _deliveryInstructionsController.text.isEmpty) {
      setState(() {
        _isDateSelected = false;
        _isCurrentAddress = false;
        _isDeliveryInstruction = false;
      });
    } else {
      if(_selectedPaymentMethod == 'Mpesa'){
          initiateMpesaPayment(currentUser.phone, cartitems.allCartItemsPrice().toString());
      }else if(_selectedPaymentMethod == 'cash'){
        Navigator.of(context).pushReplacementNamed('/likorttrackorder');
      }
      Navigator.of(context).pushReplacementNamed('/likortpaymentsuccess');
    }
  
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('checkout'),
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pushReplacementNamed('/likortcart');
          },
          child: const Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: GoogleMap(
                    initialCameraPosition: const CameraPosition(
                      target: LatLng(37.427961, -122.085034),
                      zoom: 11.0,
                    ),
                    onMapCreated: (GoogleMapController controller) {
                      _controller = controller;
                    },
                  ),
                ),
              ),
            ),
            SegmentedButton<String>(
              segments: const <ButtonSegment<String>>[
                ButtonSegment<String>(
                  value: 'Delivery',
                  label: Text('Delivery'),
                  icon: Icon(Icons.delivery_dining),
                ),
                ButtonSegment<String>(
                  value: 'Pickup',
                  label: Text('Pickup'),
                  icon: Icon(Icons.storefront),
                ),
              ],
              selected: <String>{_selectedOption},
              onSelectionChanged: (Set<String> newSelection) {
                setState(() {
                  _selectedOption = newSelection.first;
                });
              },
              style: ButtonStyle(
                textStyle: WidgetStateTextStyle.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    );
                  }
                  return const TextStyle(fontSize: 16);
                }),
                iconColor: WidgetStateColor.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return Theme.of(context).colorScheme.primary;
                  }
                  return const Color(0x0000005a);
                }),
                backgroundColor: WidgetStateColor.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return Theme.of(context).colorScheme.primaryContainer;
                  }
                  return const Color(0x0000005a);
                }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                top: 12.0,
              ),
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Current Address',
                  suffixIcon: Icon(Icons.location_on),
                ),
                child: Text(
                  _currentAddress ?? 'Fetching address...',
                  style: TextStyle(
                    color: _currentAddress == null ? Colors.grey : Colors.black,
                  ),
                ),
              ),
            ),
            _isCurrentAddress == false
                ? const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                      'please pick delivery address',
                      style: TextStyle(color: Colors.red),
                    ),
                )
                : const SizedBox(),
            Padding(
              padding:
                  const EdgeInsets.only(left: 16.0, right: 16.0, top: 12.0),
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Delivery Date & Time',
                  prefixIcon: Icon(Icons.calendar_today),
                  suffixIcon: Icon(Icons.access_time),
                ),
                child: InkWell(
                  onTap: () => _selectDateTime(context),
                  child: Text(
                    _selectedDate != null && _selectedTime != null
                        ? '${'${_selectedDate?.toLocal()}'.split(' ')[0]} at ${_selectedTime?.format(context)}'
                        : 'Select Date & Time',
                  ),
                ),
              ),
            ),
            _isDateSelected == false
                ? const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                      'please pick delivery date and time',
                      style: TextStyle(color: Colors.red),
                    ),
                )
                : const SizedBox(),
            Padding(
              padding:
                  const EdgeInsets.only(left: 16.0, right: 16.0, top: 12.0),
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Delivery instructions',
                  suffixIcon: Icon(Icons.create_rounded),
                ),
                child: InkWell(
                  onTap: () async {
                    final result = await showDialog<String>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Delivery Instructions'),
                        content: TextField(
                          controller: _deliveryInstructionsController,
                          maxLines: null, // Allow multiple lines
                          decoration: const InputDecoration(
                            hintText:
                                'Enter delivery instructions (e.g., Leave at the door)',
                          ),
                          autofocus:
                              true, // Focus on the TextField when the dialog opens
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(
                                context, _deliveryInstructionsController.text),
                            child: const Text('Save'),
                          ),
                        ],
                      ),
                    );

                    if (result != null) {
                      setState(() {
                        _deliveryInstructions = result;
                      });
                    }
                  },
                  child: Text(
                    _deliveryInstructions ?? 'Add delivery instructions',
                    style: TextStyle(
                      color: _deliveryInstructions == null
                          ? Colors.grey
                          :Theme.of(context).brightness == Brightness.light? Colors.black:Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            _isDeliveryInstruction == false
                ? const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                      'please include delivery instructions',
                      style: TextStyle(color: Colors.red),
                    ),
                )
                : const SizedBox(),
            SizedBox(height: MediaQuery.of(context).size.height * .01),
            const Center(
              child: Text('order summary'),
            ),
            ListView.builder(
                shrinkWrap: true, // Add this line
                physics: const NeverScrollableScrollPhysics(), // Add this line
                itemCount: Provider.of<CartItem>(context, listen: false)
                    .cartItems
                    .length,
                itemBuilder: (context, index) {
                  var cartitems = Provider.of<CartItem>(context).cartItems;
                  return ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: Image.network(
                        cartitems[index].product.imageUrls[0],
                        width: MediaQuery.of(context).size.width * 0.1,
                        height: MediaQuery.of(context).size.height * 0.1,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(cartitems[index].product.name),
                    trailing: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('${cartitems[index].quantity}x'),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.1,
                        ),
                        Text(
                            '\$${cartitems[index].product.price.toStringAsFixed(2)}'),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.15,
                        ),
                        Text(
                            '\$${cartitems[index].getTotalPrice().toStringAsFixed(2)}'),
                      ],
                    ),
                  );
                }),
            const SizedBox(height: 16),
            const Text(
              'Payment Method',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
                right: 16.0,
              ),
              child: Card(
                child: ExpansionTile(
                  title: Text(_selectedPaymentMethod != null
                      ? (_selectedPaymentMethod == 'cash'
                          ? 'Cash on Delivery'
                          : 'Mpesa')
                      : 'Select Payment Method'),
                  children: [
                    ListTile(
                      leading: const Icon(Icons.money),
                      title: const Text('Cash on Delivery'),
                      onTap: () {
                        setState(() {
                          _selectedPaymentMethod = 'cash';
                        });
                        // Navigator.pop(context); // Close the ExpansionTile
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.credit_card),
                      title: const Text('Mpesa'),
                      onTap: () {
                        setState(() {
                          _selectedPaymentMethod = 'Mpesa';
                        });
                        // Navigator.pop(context); // Close the ExpansionTile
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              // onPressed: _selectedPaymentMethod != null?
              onPressed: () {
                // Start payment process
                // ...
                _makePayment();
                // fetchAccessToken(context);

                //      Navigator.of(context).pushReplacementNamed('/likortpaymentfailure');
              },
              // : null, // Disable button if payment method is not selected
              child: const Text('Proceed to Payment'),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
