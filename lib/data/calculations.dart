import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:random_color/random_color.dart';
import 'package:scidart/numdart.dart';
import 'package:squash/Solo/solo_defs.dart';
import 'package:squash/extra/hive_classes.dart';
import 'package:statistical_dart/statistical_dart.dart';

class DataMethods {


  List<double> solo_pie_chart2(Box<Solo_stroage> solo_storage_box) {








    List<double> solo_type_pie_chart_data = [];

    for (int i = 0; i < SoloDefs().get().length; i++) {
      solo_type_pie_chart_data.add(0);
    }

    for (int i = 0; i < solo_storage_box.length; i++) {
      for (int x = 0; x < solo_storage_box.getAt(i).bounces.length; x++) {
        solo_type_pie_chart_data[solo_storage_box.getAt(i).bounces[x].type.id]++;

      }
    }

    return solo_type_pie_chart_data;
  }
  List<String> solo_pie_chart_names2(Box<Solo_stroage> solo_storage_box) {
    List<String> solo_names = [];

    for (int i = 0; i < solo_storage_box.length; i++) {
      for (int x = 0; x < solo_storage_box.getAt(i).bounces.length; x++) {
        if(!solo_names.contains(solo_storage_box.getAt(i).bounces[x].type.name)){

          solo_names.add(solo_storage_box.getAt(i).bounces[x].type.name);

        }
      }
    }

    print(solo_names);
    return solo_names;
  }

  Map<String,int> solo_pie_chart(Box<Solo_stroage> solo_storage_box) {
    Map<String,int> identifier = new Map();


    for (int i = 0; i < solo_storage_box.length; i++) {
      for (int x = 0; x < solo_storage_box.getAt(i).bounces.length; x++) {

        if(identifier.containsKey(solo_storage_box.getAt(i).bounces[x].type.name)){
          identifier[solo_storage_box.getAt(i).bounces[x].type.name]=identifier[solo_storage_box.getAt(i).bounces[x].type.name]+1;
        }else{

          identifier[solo_storage_box.getAt(i).bounces[x].type.name]=0;

        }


      }
    }
    print(identifier);

    return identifier;
  }


  List<PieChartSectionData> solo_type_slice_data(Map<String,int>slice_data, colors, index, text_color) {



    List<PieChartSectionData> data = [];

    double sum = 0.0;
    // looping over data array
    slice_data.forEach((item,a){
      sum =sum+ a;
    });


    for (int i = 0; i < slice_data.length; i++) {
      data.add(
        PieChartSectionData(
          color: colors,
          value: slice_data.values.toList()[i].toDouble(),
          title: ((slice_data.values.toList()[i].toDouble() / sum) * 100).toInt().toString() + '%',
          radius: index == i ? 70 : 60,
          titleStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: ((slice_data.values.toList()[i].toDouble() / sum) * 100).toInt() < 7 ? Colors.transparent : text_color),
          titlePositionPercentageOffset: 0.55,
        ),
      );
    }

    return data;
  }

  log_precision(solo) async {
    var box = await Hive.openBox('badges');

    if (box.get("solo_p", defaultValue: 0) < solo) {
      box.put("solo_p", solo);
    }
  }

  double percision2(Box<Solo_stroage> solo_storage_box) {
    List<double> acc = [];
    for (int i = 0; i < solo_storage_box.length; i++) {
      var n = Array([]);

      for (int x = 0; x < solo_storage_box.getAt(i).bounces.length; x++) {
        n.add(hypotenuse(solo_storage_box.getAt(i).bounces[x].y_pos, solo_storage_box.getAt(i).bounces[x].x_pos));
      }

      if (n.length != 0) {
        acc.add(100 - (standardDeviation(n) * 100 / mean(n)));
      }
    }

    if (acc.length == 0) {
      log_precision(0);
      return 0;
    } else {
      double p = acc.reduce((a, b) => a + b) / acc.length;
      log_precision(p);
      return p;
    }
  }

  double percision(Box<Solo_stroage> solo_storage_box) {
    Statistical statistical = Statistical();

    List<num> acc = [];

    for (int i = 0; i < solo_storage_box.length; i++) {

      List<num> n = [];
      List<num> x_vals = [];
      List<num> y_vals = [];

      for (int x = 0; x < solo_storage_box.getAt(i).bounces.length; x++) {



        x_vals.add(solo_storage_box.getAt(i).bounces[x].x_pos);
        y_vals.add(solo_storage_box.getAt(i).bounces[x].y_pos);
      }

      double x_center = statistical.arrMean(x_vals);
      double y_center = statistical.arrMean(y_vals);

      for (int x = 0; x < solo_storage_box.getAt(i).bounces.length; x++) {
        double dx = (solo_storage_box.getAt(i).bounces[x].x_pos - x_center).abs();
        double dy = (solo_storage_box.getAt(i).bounces[x].y_pos - y_center).abs();

        n.add(hypotenuse(dx, dy));

      }





      acc.add(statistical.arrStdDeviation(n)/statistical.arrMean(n)*100);
    }

    log_precision(statistical.arrMean(acc));
    return statistical.arrMean(acc);
  }

  List<FlSpot> normal_d(Box<Solo_stroage> solo_storage_box) {

    Statistical statistical = Statistical();


    List<FlSpot> spot=[];

    for (int i = 0; i < solo_storage_box.length; i++) {

      List<num> nom = [];
      List<num> n = [];

      List<num> x_vals = [];
      List<num> y_vals = [];

      for (int x = 0; x < solo_storage_box.getAt(i).bounces.length; x++) {



        x_vals.add(solo_storage_box.getAt(i).bounces[x].x_pos);
        y_vals.add(solo_storage_box.getAt(i).bounces[x].y_pos);
      }

      double x_center = statistical.arrMean(x_vals);
      double y_center = statistical.arrMean(y_vals);

      for (int x = 0; x < solo_storage_box.getAt(i).bounces.length; x++) {
        double dx = (solo_storage_box.getAt(i).bounces[x].x_pos - x_center).abs();
        double dy = (solo_storage_box.getAt(i).bounces[x].y_pos - y_center).abs();

        n.add(hypotenuse(dx, dy));

      }




      spot.add(FlSpot(i.toDouble(), statistical.arrStdDeviation(n)/statistical.arrMean(n)*100));

      //print(statistical.arrStdDeviation(n)/statistical.arrMean(n)*100);

    }

    return spot;
  }

  int ave_solo_dur(Box<Solo_stroage> solo_storage_box) {
    print("her");

    int ave_solo_dur;
    for (int i = 0; i < solo_storage_box.length; i++) {
      if (ave_solo_dur == null) {
        ave_solo_dur = solo_storage_box.getAt(i).end.difference(solo_storage_box.getAt(i).start).inSeconds;
      } else {
        ave_solo_dur = (solo_storage_box.getAt(i).end.difference(solo_storage_box.getAt(i).start).inSeconds + ave_solo_dur) ~/ 2;
      }
    }

    return ave_solo_dur;
  }

  int ave_shot_num(Box<Solo_stroage> solo_storage_box) {
    int ave_shot_num;

    for (int i = 0; i < solo_storage_box.length; i++) {
      if (ave_shot_num == null) {
        ave_shot_num = solo_storage_box.getAt(i).bounces.length;
      } else {
        ave_shot_num = (solo_storage_box.getAt(i).bounces.length + ave_shot_num) ~/ 2;
      }
    }

    return ave_shot_num;
  }

  List<double> WorkRestPie(Box<Ghosting> ghosting_box) {
    double rest = 0;
    double work = 0;

    for (int i = 0; i < ghosting_box.length; i++) {
      if (ghosting_box.getAt(i).rest_time != null && ghosting_box.getAt(i).rounds != null) {
        if (rest == 0 && work == 0) {
          rest = (ghosting_box.getAt(i).rest_time * (ghosting_box.getAt(i).rounds + 1)).toDouble();
          work = ghosting_box.getAt(i).end.difference(ghosting_box.getAt(i).start).inSeconds - rest;
        } else {
          //print(ghosting_box.getAt(i).rounds);
          rest = (rest + (ghosting_box.getAt(i).rest_time * (ghosting_box.getAt(i).rounds + 1)).toDouble()) / 2;
          work = (work + ghosting_box.getAt(i).end.difference(ghosting_box.getAt(i).start).inSeconds - rest) / 2;
        }
      }
    }

    return [work, rest];
  }

  List<FlSpot> speed(Box<Ghosting> ghosting_box) {
    List<FlSpot> speed = [];

    for (int i = 0; i < ghosting_box.length; i++) {
      if (ghosting_box.getAt(i).time_array.length > 0) {
        double result;

        for (int x = 0; x < ghosting_box.getAt(i).corner_array.length; x++) {
          double fixedSpeed = ghosting_box.getAt(i).time_array[x];

          if (fixedSpeed > ghosting_box.getAt(i).rest_time) {
            fixedSpeed = fixedSpeed - ghosting_box.getAt(i).rest_time;
          }

          if (result == null) {
            result = fixedSpeed;
          } else {
            result = (result + fixedSpeed);
          }
        }

        result = result / ghosting_box.getAt(i).time_array.length;

        speed.add(FlSpot(i.toDouble(), result));
        //print(result);
      }

      //print(speed);
    }

    return speed;
  }

  int ave_ghost_dur(Box<Ghosting> ghosting_box) {
    int ave_ghost_dur;
    for (int i = 0; i < ghosting_box.length; i++) {
      if (ave_ghost_dur == null) {
        ave_ghost_dur = ghosting_box.getAt(i).end.difference(ghosting_box.getAt(i).start).inSeconds;
      } else {
        ave_ghost_dur = (ghosting_box.getAt(i).end.difference(ghosting_box.getAt(i).start).inSeconds + ave_ghost_dur) ~/ 2;
      }
    }

    return ave_ghost_dur;
  }

  int ave_ghost_num(Box<Ghosting> ghosting_box) {
    int ave_ghost_num;

    for (int i = 0; i < ghosting_box.length; i++) {
      if (ave_ghost_num == null) {
        ave_ghost_num = ghosting_box.getAt(i).corner_array.length;
      } else {
        ave_ghost_num = (ghosting_box.getAt(i).corner_array.length + ave_ghost_num) ~/ 2;
      }
    }

    return ave_ghost_num;
  }

  List<double> SingleCornerSpeed(Box<Ghosting> ghosting_box) {
    List<double> single_corner_speed = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

    for (int i = 0; i < ghosting_box.length; i++) {
      for (int x = 0; x < ghosting_box.getAt(i).corner_array.length; x++) {
        int con_index = ghosting_box.getAt(i).corner_array[x].toInt();

        double fixedSpeed = ghosting_box.getAt(i).time_array[x];

        if (fixedSpeed > ghosting_box.getAt(i).rest_time) {
          fixedSpeed = fixedSpeed - ghosting_box.getAt(i).rest_time;
        }

        if (single_corner_speed[con_index] == 0) {
          single_corner_speed[con_index] = fixedSpeed;
        } else {
          single_corner_speed[con_index] = (single_corner_speed[con_index] + fixedSpeed) / 2;
        }
      }
    }

    return single_corner_speed;
  }

  List<double> GhostPieChart(Box<Ghosting> ghosting_box) {
    List<double> ghost_type_pie_chart_data = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

    for (int i = 0; i < ghosting_box.length; i++) {
      for (int x = 0; x < ghosting_box.getAt(i).corner_array.length; x++) {
        ghost_type_pie_chart_data[ghosting_box.getAt(i).corner_array[x].toInt()]++;
      }
    }

    return ghost_type_pie_chart_data;
  }

  List<BarChartGroupData> BarChartSpeed(Box<Ghosting> ghosting_box, List<double> single_corner_speed, Color primeColor) {
    List<BarChartGroupData> barchrt = [];

    for (int i = 0; i < single_corner_speed.length; i++) {
      barchrt.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              y: single_corner_speed[i],
              colors: [primeColor],
              width: 20,
              backDrawRodData: BackgroundBarChartRodData(
                show: true,
                y: 10,
                colors: [Colors.grey.withOpacity(0.2)],
              ),
            ),
          ],
        ),
      );
    }
    return barchrt;
  }

  List<FlSpot> SingleSpeed(Ghosting ghosting_box) {
    List<FlSpot> speed = [];

    if (ghosting_box.time_array.length > 0) {
      double result;

      for (int x = 0; x < ghosting_box.corner_array.length; x++) {
        double fixedSpeed = ghosting_box.time_array[x];

        if (fixedSpeed > ghosting_box.rest_time) {
          fixedSpeed = fixedSpeed - ghosting_box.rest_time;
        }

        speed.add(FlSpot(x.toDouble(), fixedSpeed));
      }

      //print(result);

      //print(speed);
    }

    return speed;
  }
}
