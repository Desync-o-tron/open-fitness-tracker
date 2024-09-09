import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_fitness_tracker/DOM/history_importing.dart';
import 'package:open_fitness_tracker/DOM/training_metadata.dart';

class ExternalAppTrainingImportDialog extends StatelessWidget {
  const ExternalAppTrainingImportDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Choose Import Source'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: const Text('Strong App'),
            onTap: () {
              Navigator.of(context).pop();
              _importTrainingData('strong', context);
            },
          ),
          ListTile(
            title: const Text('Whatever-Example'),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  void _importTrainingData(String source, BuildContext context) async {
    var trainingHistoryCubit = context.read<TrainingHistoryCubit>();
    var scaffoldMessenger = ScaffoldMessenger.of(context);

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv', 'txt', 'json'],
    );

    if (result == null) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('No file selected')),
      );
      return;
    }
    String? filePath = result.files.single.path;
    if (filePath == null) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('No file selected. Is the path unaccessable?')),
      );
      return;
    }

    // scaffoldMessenger.showSnackBar(
    //   SnackBar(content: Text('Selected file.')),
    // );

    List<TrainingSession> sessions = [];
    if (source == 'strong') {
      sessions = importStrongCsv(filePath);
    }

    //todo for web
    // https://github.com/miguelpruivo/flutter_file_picker/wiki/FAQ
    trainingHistoryCubit.addSessions(sessions);
    // for (var session in sessions) {
    //   trainingHistoryCubit.addSession(session);
    // }
    scaffoldMessenger.showSnackBar(
      SnackBar(content: Text("imported ${sessions.length} sessions.")),
    );
  }
}
