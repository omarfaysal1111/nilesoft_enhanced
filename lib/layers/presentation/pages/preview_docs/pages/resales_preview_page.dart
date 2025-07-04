import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nilesoft_erp/layers/presentation/components/invoice_info.dart';
import 'package:nilesoft_erp/layers/presentation/pages/Resales/bloc/resales_bloc.dart';
import 'package:nilesoft_erp/layers/presentation/pages/Resales/bloc/resales_event.dart';
import 'package:nilesoft_erp/layers/presentation/pages/Resales/resales_page.dart';
import 'package:nilesoft_erp/layers/presentation/pages/preview_docs/bloc/resales/resales_prev_bloc.dart';
import 'package:nilesoft_erp/layers/presentation/pages/preview_docs/bloc/resales/resales_prev_event.dart';
import 'package:nilesoft_erp/layers/presentation/pages/preview_docs/bloc/resales/resales_prev_state.dart';

class ReSalesPreviewPage extends StatefulWidget {
  const ReSalesPreviewPage({super.key});

  @override
  State<ReSalesPreviewPage> createState() => _ReSalesPreviewPageState();
}

class _ReSalesPreviewPageState extends State<ReSalesPreviewPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int sent = 1;

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
    if (_tabController.indexIsChanging) {
      return; // Ignore if the index is still changing
    }

    // Dispatch events based on the selected tab
    switch (_tabController.index) {
      case 0:
        context.read<RePreviewBloc>().add(ReOnPreviewInitial());
        break;
      case 1:
        context.read<RePreviewBloc>().add(ReOnPreviewSent());
        break;
      case 2:
        context.read<RePreviewBloc>().add(ReOnPreviewUnsent());
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
                "استعراض مردودات المبيعات",
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
          _buildReSalesPreviewContent(),
          // Second tab: المرسلة
          _buildReSalesPreviewContent(),
          // Third tab: الغير مرسلة
          _buildReSalesPreviewContent(),
        ],
      ),
    );
  }

  Widget _buildReSalesPreviewContent() {
    return BlocConsumer<RePreviewBloc, RePreviewState>(
      listener: (BuildContext context, RePreviewState state) {},
      builder: (BuildContext context, RePreviewState state) {
        if (state is ReDocPreviewInitial) {
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
        if (state is ReDocPreviewLoaded) {
          if (state.salesModel.isNotEmpty) {
            if (state.salesModel[0].sent != 1) {
              sent = 0;
            }
            if (state is OnReInvoiceDeleted) {
              context.read<RePreviewBloc>().add(ReOnPreviewInitial());
            }
          }
          return ListView.builder(
            itemCount: state.salesModel.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: DocInfoCard(
                  customerName: state.salesModel[index].clientName.toString(),
                  dateValue: state.salesModel[index].docDate.toString(),
                  netValue: state.salesModel[index].net ?? 0,
                  docNumber: state.salesModel[index].invoiceno.toString(),
                  onViewPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider(
                          create: (context) => ResalesBloc()
                            ..add(OnResaleToEdit(state.salesModel[index].id!)),
                          child: ResalesPageContent(
                              sent: sent, editid: state.salesModel[index].id!),
                        ),
                      ),
                    );
                  },
                  sent: sent,
                  onDelete: () {
                    if (sent == 0) {
                      context.read<RePreviewBloc>().add(
                          OnReInvoiceDelete(id: state.salesModel[index].id!));
                    }
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
    );
  }
}
