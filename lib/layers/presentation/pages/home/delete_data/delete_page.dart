import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nilesoft_erp/layers/presentation/components/custom_textfield.dart';
import 'package:nilesoft_erp/layers/presentation/components/rect_button.dart';
import 'package:nilesoft_erp/layers/presentation/pages/home/delete_data/bloc/delete_bloc.dart';
import 'package:nilesoft_erp/layers/presentation/pages/home/delete_data/bloc/delete_event.dart';
import 'package:nilesoft_erp/layers/presentation/pages/home/delete_data/bloc/delete_state.dart';

final pass1 = TextEditingController();

class DeletePage extends StatelessWidget {
  const DeletePage({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<DeleteBloc>();

    return PopScope(
      // ignore: deprecated_member_use
      onPopInvoked: (didPop) {
        pass1.text = "";
      },
      child: Scaffold(
          body: BlocConsumer<DeleteBloc, DeleteState>(
        listener: (BuildContext context, DeleteState state) {
          if (state is DeleteFailed) {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.txt),
                  duration: const Duration(seconds: 2),
                ),
              );
            });
          } else if (state is DeleteSucc) {
            Navigator.pop(context);
            SchedulerBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("تم حذف البيانات بنجاح"),
                  duration: Duration(seconds: 2),
                ),
              );
            });
          }
        },
        builder: (BuildContext context, DeleteState state) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomTextField(
                  hintText: "كلمة السر",
                  onChanged: (value) {},
                  controller: pass1,
                ),
                CustomButton(
                    text: "مسح البيانات",
                    onPressed: () {
                      bloc.add(OnDelete(pass: pass1.text));
                    })
              ],
            ),
          );
        },
      )),
    );
  }
}
