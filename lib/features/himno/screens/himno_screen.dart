import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:novena_lorenzo/common/error.dart';
import 'package:novena_lorenzo/features/himno/bloc/himno_bloc.dart';
import 'package:novena_lorenzo/features/himno/models/himno_model.dart';
import 'package:novena_lorenzo/utils/log_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HimnoScreen extends StatefulWidget {
  const HimnoScreen({super.key});

  @override
  State<HimnoScreen> createState() => _HimnoScreenState();
}

class _HimnoScreenState extends State<HimnoScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  Duration currentDuration = Duration.zero;
  Duration totalDuration = Duration.zero;
  HimnoModel? data;

  @override
  void initState() {
    super.initState();
    context.read<HimnoBloc>().add(HimnoFetched());
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    try {
      await _audioPlayer.setAsset('assets/himno.mp3');

      _audioPlayer.durationStream.listen((duration) {
        setState(() {
          totalDuration = duration ?? Duration.zero;
        });
      });

      _audioPlayer.positionStream.listen((position) {
        setState(() {
          currentDuration = position;
        });
      });
    } catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showError(
          context,
          jsonEncode({
            "title": "Error Occurred",
            "description":
                "There is an error loading the audio. Please try again later."
          }),
        );
      });

      LogService().logError(e.toString());
    }
  }

  void _togglePlayPause() {
    if (_audioPlayer.playing) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.play();
    }
  }

  void _seekTo(double value) {
    _audioPlayer.seek(Duration(seconds: value.toInt()));
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes);
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(slivers: [
        SliverAppBar(
          pinned: true,
          centerTitle: true,
          backgroundColor: Colors.red[400],
          title: Text(
            "Himno",
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          automaticallyImplyLeading: false,
          // leading: GestureDetector(
          //   onTap: () {
          //     Navigator.pushReplacement(
          //       context,
          //       MaterialPageRoute(builder: (context) => MainNavigation()),
          //     );
          //   },
          //   child: Icon(
          //     Icons.arrow_back_ios_new_rounded,
          //     size: 20,
          //     color: Colors.white,
          //   ),
          // ),
        ),
        SliverToBoxAdapter(
          child: Container(
            padding: EdgeInsets.all(15),
            child: SingleChildScrollView(
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 480,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        "./assets/lorenzo4.webp",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    "Himno ki San Lorenzo Ruiz",
                    style: TextStyle(
                        fontFamily: "Inter",
                        fontSize: 18,
                        fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Msgr. Crispin C. Bernarte, Jr.",
                    style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 15,
                        color: Colors.grey[600]),
                  ),
                  SizedBox(height: 15),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(60),
                            color: Colors.red),
                        child: IconButton(
                          color: Colors.white,
                          icon: Icon(
                            _audioPlayer.playing
                                ? Icons.pause
                                : Icons.play_arrow,
                            size: 36,
                            // color: Colors.white,
                          ),
                          onPressed: _togglePlayPause,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 25,
                            ),
                            SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                activeTrackColor:
                                    Colors.red, // Active track color
                                inactiveTrackColor:
                                    Colors.grey, // Inactive track color
                                trackHeight: 5.0, // Track height
                                thumbColor: Colors.red, // Thumb color
                                thumbShape: RoundSliderThumbShape(
                                    enabledThumbRadius: 7),
                                overlayShape: SliderComponentShape.noOverlay,
                                overlayColor:
                                    Colors.red.withOpacity(0.2), // Hover effect
                              ),
                              child: Slider(
                                value: currentDuration.inSeconds.toDouble(),
                                max: totalDuration.inSeconds.toDouble(),
                                onChanged: _seekTo,
                                activeColor: Colors.red,
                              ),
                            ),
                            SizedBox(
                              height: 7,
                            ),
                            Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  _formatDuration(currentDuration),
                                  style: TextStyle(fontSize: 12),
                                ),
                                Spacer(),
                                Text(
                                  _formatDuration(totalDuration),
                                  style: TextStyle(fontSize: 12),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  BlocConsumer<HimnoBloc, HimnoState>(
                    listener: (context, state) {
                      if (state is HimnoFetchedSuccess) {
                        data = state.himnoModel;
                      }
                    },
                    builder: (context, state) {
                      if (data == null) {
                        return Container();
                      }

                      return Center(
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.grey[200],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                "Lyrics",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: 25,
                              ),
                              Text(
                                "Koro: ",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    color: Colors.grey[700]),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              ListView.builder(
                                  itemCount: data!.chorus.length,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, k) {
                                    return Text(
                                      data!.chorus[k],
                                      style: TextStyle(fontSize: 18),
                                      textAlign: TextAlign.center,
                                    );
                                  }),
                              SizedBox(
                                height: 30,
                              ),
                              ListView.builder(
                                  itemCount: data!.verses.length,
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, i) {
                                    return Container(
                                      padding: EdgeInsets.only(bottom: 30),
                                      child: Column(
                                        children: [
                                          Text(
                                            "Verso ${i + 1}:",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: Colors.grey[700]),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          ListView.builder(
                                              itemCount: data!.verses[i].length,
                                              shrinkWrap: true,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              itemBuilder: (context, j) {
                                                return Text(
                                                  data!.verses[i][j],
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                  textAlign: TextAlign.center,
                                                );
                                              }),
                                        ],
                                      ),
                                    );
                                  })
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.all(0),
                  leading: Image.asset(
                    "./assets/bernarte.png",
                    width: 50,
                  ),
                  title: Text(
                    "Rev. Msgr. Crispin C. Bernarte Jr.",
                    style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.w700),
                  ),
                  subtitle: Text(
                    "Author",
                    style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.all(0),
                  leading: Image.asset(
                    "./assets/pavilando.jpg",
                    width: 50,
                  ),
                  title: Text(
                    "Rev. Msgr. Don Vito Pavilando",
                    style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.w700),
                  ),
                  subtitle: Text(
                    "Nihil Obstat",
                    style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.all(0),
                  leading: Image.asset(
                    "./assets/sorra.jpg",
                    width: 50,
                  ),
                  title: Text(
                    "+ Most. Rev. Jose C. Sorra, DD",
                    style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.w700),
                  ),
                  subtitle: Text(
                    "Imprimatur",
                    style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Text(
                  "All Rights Reserved",
                  style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "COPYRIGHT 2004",
                  style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "Commission on Lay Apostolate",
                  style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "Diocese of Legazpi",
                  style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 50)
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
