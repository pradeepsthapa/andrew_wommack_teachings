import 'dart:isolate';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get_storage/get_storage.dart' as path;
import 'package:permission_handler/permission_handler.dart';

class AudioDownloader extends ChangeNotifier{


  static const dirPath = 'sdcard/andrew wommack';
  ReceivePort _receivePort = ReceivePort();

  Future<bool> checkRequest()async{
    final PermissionStatus status = await Permission.storage.status;
    if(status==PermissionStatus.granted){
      return true;
    }
    else {
      final result = await Permission.storage.request();
      if(result.isGranted){
        return true;
      }else return false;
    }
  }

  int _progress = 0;
  String _id = '';
  DownloadTaskStatus _downloadTaskStatus = DownloadTaskStatus.undefined;

  int get progress => _progress;
  String get id => _id;
  DownloadTaskStatus get downloadTaskStatus => _downloadTaskStatus;

  bool _initialized = false;
  bool get initialized => _initialized;


  Future<void> initializeIsolate()async{
    _bindBackgroundIsolate();
    FlutterDownloader.registerCallback(downloadCallback);
  }

  void cancelDownload(String id){
    FlutterDownloader.cancel(taskId: id);
  }

  void startDownload(String url, String filename)async{
      // final storageLocation = await path.getExternalStorageDirectories(type: path.StorageDirectory.music);

      if(!initialized){
        await initializeIsolate();
      }
      await FlutterDownloader.enqueue(url: url,
        savedDir: "/sdcard/music/",
        fileName: filename+".mp3",
        showNotification: true,
        openFileFromNotification: true,
      );

  }

  void _bindBackgroundIsolate() {
    bool isSuccess = IsolateNameServer.registerPortWithName(_receivePort.sendPort, 'downloader_send_port');
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    _initialized = true;
    _receivePort.listen((dynamic data) {

      _id = data[0];
      _downloadTaskStatus = data[1];
      _progress = data[2];
      if(downloadTaskStatus==DownloadTaskStatus.complete||downloadTaskStatus==DownloadTaskStatus.canceled){
        Future.delayed(Duration(seconds: 1),(){
          _unbindBackgroundIsolate();
          _downloadTaskStatus=DownloadTaskStatus.undefined;
        });
      }
      notifyListeners();
    });
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    _initialized = false;
    _downloadTaskStatus = DownloadTaskStatus.undefined;
  }

  static void downloadCallback(String id, DownloadTaskStatus status, int progress) {
    final SendPort send = IsolateNameServer.lookupPortByName('downloader_send_port')!;
    send.send([id, status, progress]);
  }

}