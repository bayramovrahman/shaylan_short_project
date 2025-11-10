import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:shaylan_agent/app/app_fonts.dart';
import 'package:shaylan_agent/functions/permission.dart';
import 'package:shaylan_agent/methods/functions.dart';
import 'package:shaylan_agent/l10n/app_localizations.dart';
import 'package:shaylan_agent/methods/gridview.dart';
import 'package:shaylan_agent/methods/pages/credit_reports.dart';
import 'package:shaylan_agent/models/customer_by_card_code.dart';
import 'package:shaylan_agent/utilities/alert_utils.dart';
import 'package:shaylan_agent/pages/customers/parts/customer_current_location.dart';

class KollektorCustomerDetailPage extends StatefulWidget {
  final CustomerByCardCode kollektorCustomer;
  final String visitType;

  const KollektorCustomerDetailPage({
    super.key,
    required this.kollektorCustomer,
    required this.visitType,
  });

  @override
  State<KollektorCustomerDetailPage> createState() => _KollektorCustomerDetailPageState();
}

class _KollektorCustomerDetailPageState extends State<KollektorCustomerDetailPage> {
  // Just empty column

  late String _latitude;
  late String _longitude;

  @override
  void initState() {
    super.initState();
    _latitude = widget.kollektorCustomer.uLat ?? "";
    _longitude = widget.kollektorCustomer.uLng ?? "";
  }

  @override
  Widget build(BuildContext context) {
    var lang = AppLocalizations.of(context)!;
    final customer = widget.kollektorCustomer;
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildCard(
              title: lang.personalInformation,
              icon: Icons.info_outline,
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // _buildInfoRow(Icons.perm_identity, customer.customerId?.toString()),
                  _buildInfoRow(Icons.credit_card, customer.cardCode),
                  _buildInfoRow(IconlyBold.profile, customer.cardName),
                  _buildInfoRow(Icons.phone, customer.phone1),
                  _buildInfoRow(Icons.phone_android, customer.phone2),
                  _buildInfoRow(Icons.email, customer.eMail),
                  _buildInfoRow(Icons.numbers, customer.uRouteId),
                  _buildInfoRow(
                      Icons.location_city_rounded, customer.uDistrict),
                  // _buildInfoRow(Icons.category, customer.category),
                  _buildInfoRow(Icons.store_outlined, customer.segment),
                  _buildInfoRow(Icons.location_pin, customer.location),
                  _buildInfoRow(Icons.shopping_cart, customer.purchaseMethod),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            if (customer.addresses != null && customer.addresses!.isNotEmpty)
              _buildCard(
                title: lang.addressInformation,
                icon: Icons.location_on,
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: customer.addresses!
                      .map(
                        (address) => Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildAddressRow(
                                icon: Icons.location_pin,
                                label: '',
                                value: address.address,
                              ),
                              _buildAddressRow(
                                icon: CupertinoIcons.location_fill,
                                label: "${lang.enterStreetName}: ",
                                value: address.street,
                              ),
                              _buildAddressRow(
                                icon: Icons.directions,
                                label: "${lang.passage}: ",
                                value: address.directions,
                              ),
                              _buildAddressRow(
                                icon: Icons.location_city_rounded,
                                label: '',
                                value: address.houseNumber != null
                                    ? parseHouseNumber(
                                        address.houseNumber!,
                                        langApartment: lang.houseNumber,
                                        langFlat: lang.apartmentNumber,
                                      )
                                    : null,
                              ),
                              _buildAddressRow(
                                icon: Icons.block_flipped,
                                label: "${lang.houseBlock}: ",
                                value: address.streetNumber,
                              ),
                              _buildAddressRow(
                                icon: Icons.store_mall_directory_outlined,
                                label: "${lang.storeName}: ",
                                value: address.address3 != null
                                    ? cleanStoreName(address.address3!)
                                    : null,
                              ),
                              _buildAddressRow(
                                icon: Icons.add_location_alt,
                                label: '',
                                value: address.address2,
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            const SizedBox(height: 16.0),
            if (customer.contacts != null && customer.contacts!.isNotEmpty)
              _buildCard(
                title: lang.contactInformation,
                icon: Icons.contacts,
                content: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: customer.contacts!.length,
                  itemBuilder: (context, index) {
                    final contact = customer.contacts![index];
                    if (contact.firstName!.isNotEmpty &&
                        contact.lastName!.isNotEmpty) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(context).primaryColor,
                          child: Text(
                            "${(contact.firstName![0])}${(contact.lastName![0])}"
                                .toUpperCase(),
                            style: const TextStyle(
                              fontFamily: AppFonts.secondaryFont,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                        title: Text(
                          "${contact.firstName} ${contact.lastName}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: AppFonts.secondaryFont,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          "${contact.position} | ${contact.tel1}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12.0,
                            fontFamily: AppFonts.secondaryFont,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                          ),
                        ),
                      );
                    } else {
                      return SizedBox.shrink();
                    }
                  },
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          if (_latitude.isNotEmpty && _longitude.isNotEmpty) {
            navigatorPushMethod(
              context,
              CustomerCurrentLocation(
                  latitude: _latitude, longitude: _longitude),
              false,
            );
          } else {
            AlertUtils.showWarningAlert(
                context: context, message: lang.notFoundLocation, lang: lang);
          }
        },
        child: Icon(
          Icons.public,
          size: 42.0,
          color: Colors.white,
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: ElevatedButton(
          onPressed: () async {
            bool hasPermission = await hasLocationPermission();
            if (context.mounted) {
              showStartVisitDialog(context, hasPermission, customer.cardCode!, visitType: widget.visitType);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            minimumSize: const Size(double.infinity, 50.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: Text(
            lang.startVisit,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: AppFonts.monserratBold,
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard(
      {required String title,
      required IconData icon,
      required Widget content}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                /* Icon(
                  icon,
                  color: Theme.of(context).primaryColor,
                  size: 28.0,
                ),
                const SizedBox(width: 8.0), */
                Center(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontFamily: AppFonts.monserratBold,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            content,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String? value) {
    if (value == null || value.trim().isEmpty) {
      return const SizedBox.shrink();
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          children: [
            Icon(
              icon,
              size: 24.0,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 14.0,
                  fontFamily: AppFonts.secondaryFont,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildAddressRow({
    required IconData icon,
    required String label,
    String? value,
    bool showIfEmpty = false,
  }) {
    if ((value == null || value.trim().isEmpty) && !showIfEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 24.0,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Text(
              "$label$value",
              style: const TextStyle(
                fontFamily: AppFonts.secondaryFont,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String parseHouseNumber(String houseNumber,
      {required String langApartment, required String langFlat}) {
    if (houseNumber.contains('|')) {
      final parts = houseNumber.split('|');
      final apartment = parts[0].trim();
      final flat = parts[1].trim();
      return "$langApartment: $apartment, $langFlat: $flat";
    }
    return houseNumber;
  }

  // Just empty column
}
