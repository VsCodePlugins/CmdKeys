
import 'package:flutter/material.dart';
import 'package:fkeys/common/class_functions/grid_controller.dart';
import 'json_widget.dart';

class FooterCommandTable extends StatelessWidget {
  const FooterCommandTable({
    super.key,
    required this.gridController,
  });

  final GridController gridController;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          StreamBuilder<Map<String, dynamic>>(
              stream: gridController.gridStreamState,
              builder: (context, snapshot) {
                return Column(
                  children: [
                    if (snapshot.data?["MapRow"]!= null)
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Current command"),
                      ),
                    JsonWidget(dataMap: snapshot.data?["MapRow"]),
                  ],
                );
              }),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: StreamBuilder<Map<String, dynamic>>(
                stream: gridController.keyboardSettingCtrl
                    .keyboardSettingStreamState,
                builder: (context, snapshot) { return
                  Column(
                          mainAxisAlignment:
                              MainAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text("Last incoming event"),
                            ),
                            SizedBox(
                              // height: MediaQuery.of(context)
                              //         .size
                              //         .height *
                              //     .4,
                              child: JsonWidget(
                                  dataMap: snapshot
                                      .data?["incomingMessage"]),
                            ),
                          ],
                        );
        
                }),
          ),
        ],
      ),
    );
  }
}