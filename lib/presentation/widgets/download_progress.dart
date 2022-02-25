// import 'package:andrew_wommack/logic/providers.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_downloader/flutter_downloader.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// class DownloadProgressWidget extends ConsumerWidget {
//   const DownloadProgressWidget({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final downloadState = ref.watch(audioDownloaderProvider);
//     if(downloadState.downloadTaskStatus== DownloadTaskStatus.running) {
//       return Row(
//       children: [
//         Expanded(
//           child: Column(crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 7),
//                 child: Text("Downloading...${downloadState.progress}""%",style: const TextStyle(fontSize: 12),maxLines: 1,overflow: TextOverflow.ellipsis,),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(7.0),
//                 child: SliderTheme(
//                   data: SliderThemeData(
//                     activeTrackColor: Colors.green,
//                     inactiveTrackColor: Colors.greenAccent.withOpacity(0.5),
//                     trackHeight: 3,
//                     thumbColor: Colors.greenAccent,
//                     thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 1.0),
//                     overlayColor: Colors.transparent,
//                     overlayShape: const RoundSliderOverlayShape(overlayRadius: 2),),
//                   child: Slider(
//                     min: 0.0,
//                     max: 100.0,
//                     value: downloadState.progress.toDouble(),
//                     onChanged: (newPosition) {
//                     },),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         IconButton(onPressed: ()=>ref.read(audioDownloaderProvider).cancelDownload(downloadState.id), icon: const Icon(Icons.close,size: 18,color: Colors.red,)),
//       ],
//     );
//     }
//     if(downloadState.downloadTaskStatus==DownloadTaskStatus.complete){
//       Future.delayed((const Duration(milliseconds: 500)),(){
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Download Completed."),));
//       });
//     }
//     if(downloadState.downloadTaskStatus==DownloadTaskStatus.canceled){
//       Future.delayed((const Duration(milliseconds: 500)),(){
//         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Download cancelled!"),));
//       });
//     }
//     return const SizedBox();
//   }
// }
