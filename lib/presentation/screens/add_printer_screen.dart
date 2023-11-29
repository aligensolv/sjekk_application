// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:sjekk_application/core/helpers/theme_helper.dart';
// import 'package:blue_thermal_printer/blue_thermal_printer.dart';
// import 'package:sjekk_application/data/models/printer_model.dart';
// import 'package:sjekk_application/presentation/providers/printer_provider.dart';

// class AddPrinterScreen extends StatefulWidget {
//   @override
//   _AddPrinterScreenState createState() => _AddPrinterScreenState();
// }

// class _AddPrinterScreenState extends State<AddPrinterScreen> {
//   List<BluetoothDevice> availableDevices = [];
//   BluetoothDevice? _selectedDevice;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: ThemeHelper.backgroundColor,
//       appBar: AppBar(
//         backgroundColor: ThemeHelper.backgroundColor,
//         title: Text('Add Printer'),
//       ),
//       body: Container(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             _buildHeader(),
//             SizedBox(height: 20),
//             _buildAvailableDevicesList(),
//             SizedBox(height: 30),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 _buildScanButton(),
//                 SizedBox(width: 12.0,),
//                 _buildAddPrinterButton(context),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildHeader() {
//     return Column(
//       children: [
//         Icon(
//           Icons.print,
//           color: ThemeHelper.primaryColor,
//           size: 60,
//         ),
//         SizedBox(height: 10),
//         Text(
//           'Add a New Printer',
//           style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//         ),
//       ],
//     );
//   }


//   Widget _buildScanButton() {
//     return ElevatedButton(
//       onPressed: _startScan,
//       style: ThemeHelper.normalPrimaryButtonStyle(context),
//       child: Text('Scan for Printers', style: ThemeHelper.buttonTextStyle(context)),
//     );
//   }

//   Future<void> _startScan() async {
//     try {
//       // List<BluetoothDevice> devices = await BlueThermalPrinter.instance.getBondedDevices();
//       setState(() {
//         availableDevices = devices;
//       });
//     } catch (e) {
//       print('Error scanning for Bluetooth devices: $e');
//     }
//   }

//   Widget _buildAvailableDevicesList() {
//     return Expanded(
//       child: ListView.builder(
//         itemCount: availableDevices.length,
//         itemBuilder: (context, index) {
//           return ListTile(
//             title: Text(availableDevices[index].name.toString()),
//             subtitle: Text(availableDevices[index].address.toString()),
//             onTap: () async{
//               _selectedDevice = availableDevices[index];
//               // await BlueThermalPrinter.instance.connect(availableDevices[index]);
//             },
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildAddPrinterButton(BuildContext context) {
//     return ElevatedButton(
//       onPressed: () async {
//         if(_selectedDevice != null) {
//           Printer printer = Printer(
//             name: _selectedDevice!.name!,
//             address: _selectedDevice!.address!
//           );
//           await Provider.of<PrinterProvider>(context, listen: false).createPrinter(printer);
//         }
//       },
//       style: ThemeHelper.normalPrimaryButtonStyle(context),
//       child: Text('Add Printer', style: ThemeHelper.buttonTextStyle(context)),
//     );
//   }
// }
