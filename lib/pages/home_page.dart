import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tasks/models/task_model.dart';
import 'package:tasks/ui/general/colors.dart';
import 'package:tasks/ui/widgets/button_normal_widget.dart';
import 'package:tasks/ui/widgets/general_widgets.dart';
import 'package:tasks/ui/widgets/item_task_widget.dart';
import 'package:tasks/ui/widgets/textfield_normal_widget.dart';

class HomePage extends StatelessWidget {
  CollectionReference tasksReference =
      FirebaseFirestore.instance.collection('tasks');

  showTaskForm(BuildContext context) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return Container(
            padding: const EdgeInsets.all(14.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(22.0),
                  topRight: Radius.circular(22.0),
                )),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Agregar tarea",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15.0,
                  ),
                ),
                divider6(),
                TextFieldNormalWidget(
                  hintText: "Titulo",
                  icon: Icons.text_fields,
                ),
                divider10(),
                TextFieldNormalWidget(
                  hintText: "Descripción",
                  icon: Icons.description,
                ),
                divider10(),
                Text("Catergoria: "),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.start,
                  runAlignment: WrapAlignment.start,
                  spacing: 10.0,
                  children: [
                    FilterChip(
                      selected: true,
                      backgroundColor: KBrandSecondaryColor,
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      selectedColor: categoryColor["Personal"],
                      checkmarkColor: Colors.white,
                      labelStyle: TextStyle(
                        color: Colors.white,
                      ),
                      label: Text("Personal"),
                      onSelected: (bool value) {},
                    ),
                    FilterChip(
                      selected: true,
                      backgroundColor: KBrandSecondaryColor,
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      selectedColor: categoryColor["Trabajo"],
                      checkmarkColor: Colors.white,
                      labelStyle: TextStyle(
                        color: Colors.white,
                      ),
                      label: Text("Trabajo"),
                      onSelected: (bool value) {},
                    ),
                    FilterChip(
                      selected: true,
                      backgroundColor: KBrandSecondaryColor,
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      selectedColor: categoryColor["Otro"],
                      checkmarkColor: Colors.white,
                      labelStyle: TextStyle(
                        color: Colors.white,
                      ),
                      label: Text("Otro"),
                      onSelected: (bool value) {},
                    ),
                  ],
                ),
                divider10(),
                ButtonNormalWidget(),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KBrandSecondaryColor,
      floatingActionButton: InkWell(
        onTap: () {
          showTaskForm(context);
        },
        borderRadius: BorderRadius.circular(14.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8.0),
          decoration: BoxDecoration(
            color: KBrandPrimaryColor,
            borderRadius: BorderRadius.circular(14.0),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(
                Icons.add,
                color: Colors.white,
              ),
              Text(
                "Nueva tarea",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 22.0),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 12,
                      offset: const Offset(4, 4),
                    ),
                  ]),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Bienvenido, Ethan",
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                        color: KBrandPrimaryColor,
                      ),
                    ),
                    Text(
                      "Mis tareas",
                      style: TextStyle(
                        fontSize: 36.0,
                        fontWeight: FontWeight.w600,
                        color: KBrandPrimaryColor,
                      ),
                    ),
                    divider10(),
                    TextFieldNormalWidget(
                      icon: Icons.search,
                      hintText: "Buscar tarea...",
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    " Todas mis tareas",
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: KBrandPrimaryColor.withOpacity(0.85),
                    ),
                  ),
                  StreamBuilder(
                    stream: tasksReference.snapshots(),
                    builder: (BuildContext context, AsyncSnapshot snap) {
                      if (snap.hasData) {
                        List<TaskModel> tasks = [];
                        QuerySnapshot collection = snap.data;

                        tasks = collection.docs
                            .map((e) => TaskModel.fromJson(
                                e.data() as Map<String, dynamic>))
                            .toList();

                        return ListView.builder(
                            itemCount: tasks.length,
                            shrinkWrap: true,
                            physics: const ScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              return ItemTaskWidget(
                                taskModel: tasks[index],
                              );
                            });
                      }
                      return loadingWidget();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      /*body: StreamBuilder(
        stream: tasksReference.snapshots(),
        builder: (BuildContext context, AsyncSnapshot snap) {
          if (snap.hasData) {
            QuerySnapshot collection = snap.data;
            List<QueryDocumentSnapshot> docs = collection.docs;
            List<Map<String, dynamic>> docsMap =
                docs.map((e) => e.data() as Map<String, dynamic>).toList();
            print(docsMap);
            return ListView.builder(
                itemCount: docsMap.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(docsMap[index]["title"]),
                  );
                }
                );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),*/
    );
  }
}
