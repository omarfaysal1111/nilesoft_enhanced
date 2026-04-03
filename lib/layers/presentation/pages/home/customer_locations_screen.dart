import 'package:flutter/material.dart';
import 'package:nilesoft_erp/layers/data/local/database_constants.dart';
import 'package:nilesoft_erp/layers/data/repositories/local_repositories/customers_repo_impl.dart';
import 'package:nilesoft_erp/layers/data/repositories/remote_repositories/customer_location_repo_impl.dart';
import 'package:nilesoft_erp/layers/domain/models/customers_model.dart';
import 'package:nilesoft_erp/layers/presentation/components/dropdown/customers_dropdown.dart';
import 'package:nilesoft_erp/layers/presentation/components/rect_button.dart';
import 'package:nilesoft_erp/services/location_service.dart';

class CustomerLocationsScreen extends StatefulWidget {
  const CustomerLocationsScreen({super.key});

  @override
  State<CustomerLocationsScreen> createState() => _CustomerLocationsScreenState();
}

class _CustomerLocationsScreenState extends State<CustomerLocationsScreen> {
  final TextEditingController _latController = TextEditingController();
  final TextEditingController _lngController = TextEditingController();
  final CustomersRepoImpl _customersRepo = CustomersRepoImpl();
  final CustomerLocationRepoImpl _locationRepo = CustomerLocationRepoImpl();

  List<CustomersModel> _customers = [];
  CustomersModel? _selectedCustomer;
  bool _isLoadingCustomers = true;
  bool _isGettingCurrentLocation = false;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _loadCustomers();
  }

  @override
  void dispose() {
    _latController.dispose();
    _lngController.dispose();
    super.dispose();
  }

  Future<void> _loadCustomers() async {
    try {
      final customers = await _customersRepo.getCustomers(
        tableName: DatabaseConstants.customersTable,
      );
      customers.sort((a, b) => (a.name ?? "").compareTo(b.name ?? ""));
      if (!mounted) return;
      setState(() {
        _customers = customers;
        _isLoadingCustomers = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoadingCustomers = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("فشل تحميل العملاء، اضغط تحديث من الصفحة الرئيسية أولاً"),
        ),
      );
    }
  }

  Future<void> _pickCurrentLocation() async {
    setState(() {
      _isGettingCurrentLocation = true;
    });

    var position = await LocationService.getCurrentLocation();
    if (position == null && mounted) {
      final granted = await LocationService.showLocationPermissionDialog(context);
      if (granted) {
        position = await LocationService.getCurrentLocation();
      }
    }

    if (!mounted) return;
    setState(() {
      _isGettingCurrentLocation = false;
    });

    if (position == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("تعذر الحصول على الموقع الحالي")),
      );
      return;
    }

    _latController.text = position.latitude.toStringAsFixed(7);
    _lngController.text = position.longitude.toStringAsFixed(7);
  }

  Future<void> _submit() async {
    if (_selectedCustomer == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("من فضلك اختر العميل")),
      );
      return;
    }

    final lat = double.tryParse(_latController.text.trim());
    final lng = double.tryParse(_lngController.text.trim());
    if (lat == null || lng == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("من فضلك أدخل إحداثيات صحيحة")),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      await _locationRepo.updateCustomerLocation(
        customerId: _selectedCustomer!.id ?? "",
        latitude: lat,
        longitude: lng,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("تم حفظ موقع العميل بنجاح")),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("فشل إرسال الموقع إلى الخادم")),
      );
    } finally {
      if (!mounted) return;
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Directionality(
          textDirection: TextDirection.rtl,
          child: Text(
            "مواقع العملاء",
            style: TextStyle(
              fontFamily: 'Almarai',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: _isLoadingCustomers
          ? const Center(child: CircularProgressIndicator())
          : Directionality(
              textDirection: TextDirection.rtl,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SearchableDropdown(
                      customers: _customers,
                      selectedCustomer: _selectedCustomer,
                      onCustomerSelected: (value) {
                        setState(() {
                          _selectedCustomer = value;
                        });
                      },
                      width: MediaQuery.of(context).size.width,
                      onSearch: (_) {},
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _latController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                        signed: true,
                      ),
                      textAlign: TextAlign.right,
                      decoration: const InputDecoration(
                        labelText: "خط العرض (Latitude)",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _lngController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                        signed: true,
                      ),
                      textAlign: TextAlign.right,
                      decoration: const InputDecoration(
                        labelText: "خط الطول (Longitude)",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed:
                            _isGettingCurrentLocation ? null : _pickCurrentLocation,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffF3F3F3),
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: _isGettingCurrentLocation
                            ? const SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text(
                                "تحديد موقعي الحالي",
                                style: TextStyle(
                                  fontFamily: 'Almarai',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (_isSubmitting)
                      const Center(child: CircularProgressIndicator())
                    else
                      CustomButton(
                        text: "حفظ موقع العميل",
                        onPressed: _submit,
                      ),
                  ],
                ),
              ),
            ),
    );
  }
}
