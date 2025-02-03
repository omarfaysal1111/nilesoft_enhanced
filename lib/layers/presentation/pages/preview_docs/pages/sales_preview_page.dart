import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nilesoft_erp/layers/presentation/components/invoice_info.dart';
import 'package:nilesoft_erp/layers/presentation/pages/invoice/bloc/invoice_bloc.dart';
import 'package:nilesoft_erp/layers/presentation/pages/invoice/bloc/invoice_event.dart';
import 'package:nilesoft_erp/layers/presentation/pages/invoice/invoice_page.dart';
import 'package:nilesoft_erp/layers/presentation/pages/preview_docs/bloc/invoice/preview_bloc.dart';
import 'package:nilesoft_erp/layers/presentation/pages/preview_docs/bloc/invoice/preview_event.dart';
import 'package:nilesoft_erp/layers/presentation/pages/preview_docs/bloc/invoice/preview_state.dart';

class SalesPreviewPage extends StatefulWidget {
  const SalesPreviewPage({super.key});

  @override
  State<SalesPreviewPage> createState() => _SalesPreviewPageState();
}

class _SalesPreviewPageState extends State<SalesPreviewPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_onTabChanged); // Listen for tab changes
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged); // Remove listener
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging)
      return; // Ignore if the index is still changing

    // Dispatch events based on the selected tab
    switch (_tabController.index) {
      case 0:
        context.read<PreviewBloc>().add(OnPreviewInitial());
        break;
      case 1:
        context.read<PreviewBloc>().add(OnPreviewSent());
        break;
      case 2:
        context.read<PreviewBloc>().add(OnPreviewUnsent());
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Directionality(
              textDirection: TextDirection.rtl,
              child: Text(
                "استعراض فواتير المبيعات",
                style: TextStyle(
                  fontFamily: 'Almarai',
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'الجميع'),
            Tab(text: 'المرسلة'),
            Tab(text: 'الغير مرسلة'),
          ],
          labelStyle: const TextStyle(
            fontFamily: 'Almarai',
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: const TextStyle(fontFamily: 'Almarai'),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // First tab: الجميع
          BlocConsumer<PreviewBloc, PreviewState>(
            listener: (BuildContext context, PreviewState state) {},
            builder: (BuildContext context, PreviewState state) {
              if (state is DocPreviewInitial) {
                context.read<PreviewBloc>().add(OnPreviewInitial());
                return const Center(
                  child: Text(
                    "جاري التحميل",
                    style: TextStyle(
                      fontFamily: 'Almarai',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                );
              }
              if (state is DocPreviewLoaded) {
                return ListView.builder(
                  itemCount: state.salesModel.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DocInfoCard(
                        customerName:
                            state.salesModel[index].clientName.toString(),
                        dateValue: state.salesModel[index].docDate.toString(),
                        netValue: state.salesModel[index].net ?? 0,
                        docNumber: state.salesModel[index].invoiceno.toString(),
                        onViewPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BlocProvider(
                                create: (context) => InvoiceBloc()
                                  ..add(OnInvoiceToEdit(
                                      state.salesModel[index].id!)),
                                child: const InvoicePageContent(
                                  extraTitle: "المبيعات",
                                  invoiceType: 0,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              }
              return const Center(
                child: Text(
                  "لا توجد بيانات",
                  style: TextStyle(fontFamily: 'Almarai'),
                ),
              );
            },
          ),
          // Second tab: المرسلة
          BlocConsumer<PreviewBloc, PreviewState>(
            listener: (BuildContext context, PreviewState state) {},
            builder: (BuildContext context, PreviewState state) {
              if (state is DocPreviewInitial) {
                context.read<PreviewBloc>().add(OnPreviewSent());
                return const Center(
                  child: Text(
                    "جاري التحميل",
                    style: TextStyle(
                      fontFamily: 'Almarai',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                );
              }
              if (state is DocPreviewLoaded) {
                return ListView.builder(
                  itemCount: state.salesModel.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DocInfoCard(
                        customerName:
                            state.salesModel[index].clientName.toString(),
                        dateValue: state.salesModel[index].docDate.toString(),
                        netValue: state.salesModel[index].net ?? 0,
                        docNumber: state.salesModel[index].invoiceno.toString(),
                        onViewPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BlocProvider(
                                create: (context) => InvoiceBloc()
                                  ..add(OnInvoiceToEdit(
                                      state.salesModel[index].id!)),
                                child: const InvoicePageContent(
                                  extraTitle: "المبيعات",
                                  invoiceType: 0,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              }
              return const Center(
                child: Text(
                  "لا توجد بيانات",
                  style: TextStyle(fontFamily: 'Almarai'),
                ),
              );
            },
          ),
          // Third tab: الغير مرسلة
          BlocConsumer<PreviewBloc, PreviewState>(
            listener: (BuildContext context, PreviewState state) {},
            builder: (BuildContext context, PreviewState state) {
              if (state is DocPreviewInitial) {
                context.read<PreviewBloc>().add(OnPreviewUnsent());
                return const Center(
                  child: Text(
                    "جاري التحميل",
                    style: TextStyle(
                      fontFamily: 'Almarai',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                );
              }
              if (state is DocPreviewLoaded) {
                return ListView.builder(
                  itemCount: state.salesModel.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DocInfoCard(
                        customerName:
                            state.salesModel[index].clientName.toString(),
                        dateValue: state.salesModel[index].docDate.toString(),
                        netValue: state.salesModel[index].net ?? 0,
                        docNumber: state.salesModel[index].invoiceno.toString(),
                        onViewPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BlocProvider(
                                create: (context) => InvoiceBloc()
                                  ..add(OnInvoiceToEdit(
                                      state.salesModel[index].id!)),
                                child: const InvoicePageContent(
                                  extraTitle: "المبيعات",
                                  invoiceType: 0,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              }
              return const Center(
                child: Text(
                  "لا توجد بيانات",
                  style: TextStyle(fontFamily: 'Almarai'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
