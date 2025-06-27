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
  int currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_onTabChanged);
    context.read<PreviewBloc>().add(OnPreviewSent());
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) return;

    setState(() {
      currentTabIndex = _tabController.index;
    });

    switch (_tabController.index) {
      case 0:
        context.read<PreviewBloc>().add(OnPreviewSent());
        break;
      case 1:
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
          _buildSalesPreviewContent(isSentTab: true),
          _buildSalesPreviewContent(isSentTab: false),
        ],
      ),
    );
  }

  Widget _buildSalesPreviewContent({required bool isSentTab}) {
    return BlocConsumer<PreviewBloc, PreviewState>(
      listener: (BuildContext context, PreviewState state) {
        if (state is OnInvoiceDeleted) {
          context.read<PreviewBloc>().add(OnPreviewInitial());
        }
      },
      builder: (BuildContext context, PreviewState state) {
        if (state is DocPreviewInitial) {
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
              final item = state.salesModel[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  children: [
                    DocInfoCard(
                      customerName: item.clientName.toString(),
                      dateValue: item.docDate.toString(),
                      netValue: item.net ?? 0,
                      docNumber: item.invoiceno.toString(),
                      onViewPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider(
                              create: (context) =>
                                  InvoiceBloc()..add(OnInvoiceToEdit(item.id!)),
                              child: InvoiceEditingContent(
                                extraTitle: "المبيعات",
                                sent: isSentTab ? 1 : 0,
                                invoiceType: 0,
                                editid: item.id,
                              ),
                            ),
                          ),
                        );
                      },
                      sent: isSentTab ? 1 : 0,
                      onDelete: () {
                        if (!isSentTab) {
                          context
                              .read<PreviewBloc>()
                              .add(OnInvoiceDelete(id: item.id!));
                        }
                      },
                    ),
                  ],
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
    );
  }
}
