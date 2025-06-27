import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nilesoft_erp/layers/presentation/components/invoice_info.dart';
import 'package:nilesoft_erp/layers/presentation/pages/Cashin/bloc/cashin_bloc.dart';
import 'package:nilesoft_erp/layers/presentation/pages/Cashin/bloc/cashin_event.dart';
import 'package:nilesoft_erp/layers/presentation/pages/Cashin/cashin_page.dart';
import 'package:nilesoft_erp/layers/presentation/pages/preview_docs/bloc/cashin/cashin_prev_bloc.dart';
import 'package:nilesoft_erp/layers/presentation/pages/preview_docs/bloc/cashin/cashin_prev_event.dart';
import 'package:nilesoft_erp/layers/presentation/pages/preview_docs/bloc/cashin/cashin_prev_state.dart';

class CashinPreviewPage extends StatefulWidget {
  const CashinPreviewPage({super.key});

  @override
  State<CashinPreviewPage> createState() => _CashinPreviewPageState();
}

class _CashinPreviewPageState extends State<CashinPreviewPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_onTabChanged);
    context.read<CashinPrevBloc>().add(OnCashinPreviewSent());
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
        context.read<CashinPrevBloc>().add(OnCashinPreviewSent());
        break;
      case 1:
        context.read<CashinPrevBloc>().add(OnCashinPreviewUnsent());
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
                "استعراض سندات القبض",
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
          _buildCashinPreviewContent(isSentTab: true),
          _buildCashinPreviewContent(isSentTab: false),
        ],
      ),
    );
  }

  Widget _buildCashinPreviewContent({required bool isSentTab}) {
    return BlocConsumer<CashinPrevBloc, CashinPrevState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is CashInDeleted) {
          context.read<CashinPrevBloc>().add(OnCashInPreview());
        }
        if (state is CashinPrevInit) {
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

        if (state is CashInPrevLoaded) {
          return ListView.builder(
            itemCount: state.cashinModel.length,
            itemBuilder: (context, index) {
              final item = state.cashinModel[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: DocInfoCard(
                  customerName: item.clint.toString(),
                  dateValue: item.docDate.toString(),
                  netValue: item.total ?? 0,
                  docNumber: item.docNo.toString(),
                  onViewPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider(
                          create: (context) => CashinBloc()
                            ..add(OnCashinToEdit(
                                cashinModel: item, id: item.id!)),
                          child: const CashinPage(),
                        ),
                      ),
                    );
                  },
                  sent: item.sent ?? 0,
                  onDelete: () {
                    if (!isSentTab) {
                      context
                          .read<CashinPrevBloc>()
                          .add(OnCashinDelete(id: item.id!));
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
