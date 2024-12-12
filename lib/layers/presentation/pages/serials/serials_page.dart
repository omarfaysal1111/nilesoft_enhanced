import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nilesoft_erp/layers/domain/models/serials_model.dart';
import 'package:nilesoft_erp/layers/presentation/components/custom_textfield.dart';
import 'package:nilesoft_erp/layers/presentation/components/rect_button.dart';
import 'package:nilesoft_erp/layers/presentation/pages/serials/bloc/serial_event.dart';
import 'package:nilesoft_erp/layers/presentation/pages/serials/bloc/serials_bloc.dart';
import 'package:nilesoft_erp/layers/presentation/pages/serials/bloc/serials_state.dart';

final serialController = TextEditingController();

class SerialsPage extends StatelessWidget {
  const SerialsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<SerialsBloc>();
    return Scaffold(
        appBar: AppBar(),
        body: BlocConsumer<SerialsBloc, SerialsState>(
          listener: (context, state) {
            if (state is SerialSubmitted) {
              serialController.clear();
            }
          },
          builder: (context, state) {
            if (state is SerialLoaded) {
              return Center(
                child: Column(
                  children: [
                    CustomTextField(
                      hintText: "ادخل الرقم المسلسل",
                      onChanged: (val) {},
                      controller: serialController,
                    ),
                    CustomButton(
                        text: "ادخال",
                        onPressed: () {
                          SerialsModel serial = SerialsModel(
                              invId: state.invId,
                              serialNumber: serialController.text);
                          bloc.add(OnSerialSubmitted(
                              serial: serial, len: state.len));
                        })
                  ],
                ),
              );
            }
            return const CircularProgressIndicator();
          },
        ));
  }
}
