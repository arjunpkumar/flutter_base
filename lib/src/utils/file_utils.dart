import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as p;

Future<File> moveFile(File sourceFile, String newPath) async {
  final newDirectoryPath = p.dirname(newPath);
  final newDirectory = Directory(newDirectoryPath);
  final isDirExists = await newDirectory.exists();
  if (!isDirExists) {
    await newDirectory.create(recursive: true);
  }

  try {
    // prefer using rename as it is probably faster
    return await sourceFile.rename(newPath);
  } on FileSystemException catch (_) {
    // if rename fails, copy the source file and then delete it
    final newFile = await sourceFile.copy(newPath);
    await sourceFile.delete();
    return newFile;
  }
}

enum DocumentSource { image, document, audio }

Future<File?> openDocumentPicker(
  BuildContext context, {
  bool isImageOnly = false,
  bool isAudioOnly = false,
  bool isPdfOnly = false,
}) async {
/*  if (Platform.isAndroid) {
    return _documentPicker(
      isImageOnly: isImageOnly,
      isAudioOnly: isAudioOnly,
      isPdfOnly: isPdfOnly,
    );
  }

  return _documentPickerWithModeSelector(
    isImageOnly,
    isAudioOnly,
    context,
    isPdfOnly,
  );*/
  return null;
}
/*

Future<File> _documentPickerWithModeSelector(
  bool isImageOnly,
  bool isAudioOnly,
  BuildContext context,
  bool isPdfOnly,
) async {
  final source = isImageOnly
      ? DocumentSource.image
      : isAudioOnly
          ? DocumentSource.audio
          : await showModalBottomSheet<DocumentSource>(
              context: context,
              builder: (context) => SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        'labelImage'.tr(),
                        style: TextStyles.buttonSemibold(context),
                      ),
                      onTap: () {
                        Navigator.pop(context, DocumentSource.image);
                      },
                    ),
                    const SizedBox(
                      height: Units.kSPadding,
                    ),
                    ListTile(
                      title: Text(
                        'labelDocument'.tr(),
                        style: TextStyles.buttonSemibold(context),
                      ),
                      onTap: () {
                        Navigator.pop(context, DocumentSource.document);
                      },
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).padding.bottom,
                    ),
                  ],
                ),
              ),
            );

  if (source == DocumentSource.image) {
    final xFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    return File(xFile.path);
  } else if (source == DocumentSource.document) {
    return _documentPicker(
      isPdfOnly: isPdfOnly,
    );
  } else if (source == DocumentSource.audio) {
    return _documentPicker(isAudioOnly: true);
  }

  return null;
}

Future<File> _documentPicker({
  bool isImageOnly = false,
  bool isAudioOnly = false,
  bool isPdfOnly = false,
}) async {
  final path = await FlutterDocumentPicker.openDocument(
    params: FlutterDocumentPickerParams(
      allowedMimeTypes: isImageOnly
          ? whiteListImageMimeTypes
          : isAudioOnly
              ? whiteListedAudioMimeTypes
              : isPdfOnly
                  ? whiteListPdfMimeType
                  : whiteListDocumentMimeTypes,
      allowedUtiTypes: isImageOnly
          ? whiteListImageUtiTypes
          : isAudioOnly
              ? whiteListedAudioUtiTypes
              : isPdfOnly
                  ? whiteListPdfUtiType
                  : whiteListDocumentUtiTypes,
    ),
  );
  File file;
  if (path != null) {
    file = File(path);
  }
  return file;
}
*/

String getContentType(File file) {
  return lookupMimeType(file.path) ?? "text/plain";
}

class FileHelper {
  Future<String> getFileSize(String path) async {
    final file = File(path);
    return file.length().toString();
  }
}
