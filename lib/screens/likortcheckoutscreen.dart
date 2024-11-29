import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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

  @override
  void initState() {
    super.initState();
    _getCurrentAddress();
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
          borderRadius: BorderRadius.circular(8),boxShadow: [
          if (isSelected)
            BoxShadow(
              color: Colors.blue.withOpacity(0.3),
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pushReplacementNamed('/likortcart');
          },
          child: const Icon(Icons.arrow_circle_left_outlined),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Center(
              child: Text('checkout'),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .01,
            ),
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
                  icon: Icon(Icons.delivery_dining),),
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
              padding: const EdgeInsets.only(left: 16.0,right: 16.0,top: 12.0,),
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
            Padding(
              padding: const EdgeInsets.only(left: 16.0,right: 16.0,top: 12.0),
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
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 12.0),
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Delivery instructions',suffixIcon: Icon(Icons.create_rounded),
                ),
                child: InkWell(
                  onTap: () async {
                    final result = await showDialog<String>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Delivery Instructions'),
                        content: const TextField(
                          maxLines: null, // Allow multiple lines
                          decoration: InputDecoration(
                            hintText: 'Enter delivery instructions (e.g., Leave at the door)',
                          ),
                          autofocus: true, // Focus on the TextField when the dialog opens
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, _deliveryInstructionsController.text),
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
                      color: _deliveryInstructions == null ? Colors.grey : Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height*.01),
            const Center(child: Text('order summary'),),
            ListTile(
              title: const Text('item.name'),
              trailing: Text('\$${100.toStringAsFixed(2)}'),
            ),
            const SizedBox(height: 16),
          



            const Text(
              'Payment Method',
              style: TextStyle(fontSize:16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.only(left: 16.0,right: 16.0,),
              child: Card(
                child: ExpansionTile(
                  title: Text(_selectedPaymentMethod != null
                      ? (_selectedPaymentMethod == 'cash'
                      ? 'Cash on Delivery'
                      : 'Card Payment')
                      : 'Select Payment Method'),
                  children: [
                    ListTile(
                      leading: const Icon(Icons.money),
                      title: const Text('Cash on Delivery'),
                      onTap: () {
                        setState(() {
                          _selectedPaymentMethod = 'cash';
                        });
                        Navigator.pop(context); // Close the ExpansionTile
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.credit_card),
                      title: const Text('Card Payment'),
                      onTap: () {
                        setState(() {
                          _selectedPaymentMethod = 'card';
                        });
                        Navigator.pop(context); // Close the ExpansionTile
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
                   Navigator.of(context).pushReplacementNamed('/likortpaymentsuccess');
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

