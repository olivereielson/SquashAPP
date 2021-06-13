import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:scidart/numdart.dart';
import 'package:squash/extra/hive_classes.dart';

class DataMethods {
  List<double> solo_pie_chart(Box<Solo_stroage> solo_storage_box) {
    List<double> solo_type_pie_chart_data = [0, 0, 0, 0];

    for (int i = 0; i < solo_storage_box.length; i++) {
      for (int x = 0; x < solo_storage_box.getAt(i).bounces.length; x++) {
        solo_type_pie_chart_data[solo_storage_box.getAt(i).bounces[x].type.toInt()]++;
      }
    }

    return solo_type_pie_chart_data;
  }

  double percision(Box<Solo_stroage> solo_storage_box) {
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


    if(acc.length==0){
      return 0;

    }else{

      return acc.reduce((a, b) => a + b) / acc.length;


    }
  }

  int ave_solo_dur(Box<Solo_stroage> solo_storage_box) {
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

          double fixedSpeed=ghosting_box.getAt(i).time_array[x];

          if(fixedSpeed>ghosting_box.getAt(i).rest_time){

            fixedSpeed=fixedSpeed-ghosting_box.getAt(i).rest_time;
          }

          if(result==null){

            result=fixedSpeed;
          }else{
            result=(result+fixedSpeed);

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

        double fixedSpeed=ghosting_box.getAt(i).time_array[x];

        if(fixedSpeed>ghosting_box.getAt(i).rest_time){

          fixedSpeed=fixedSpeed-ghosting_box.getAt(i).rest_time;
        }


        if (single_corner_speed[con_index] == 0) {
          single_corner_speed[con_index] =fixedSpeed;
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

  List<BarChartGroupData> BarChartSpeed(Box<Ghosting> ghosting_box,List<double> single_corner_speed,Color primeColor){

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

          double fixedSpeed=ghosting_box.time_array[x];

          if(fixedSpeed>ghosting_box.rest_time){

            fixedSpeed=fixedSpeed-ghosting_box.rest_time;
          }



          speed.add(FlSpot(x.toDouble(), fixedSpeed));

        }


        //print(result);



      //print(speed);
    }

    return speed;
  }



}
