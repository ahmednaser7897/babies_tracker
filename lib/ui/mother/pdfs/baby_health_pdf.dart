import 'dart:io';
import 'package:babies_tracker/app/extensions.dart';
import 'package:babies_tracker/model/babies_model.dart';
import 'package:babies_tracker/ui/mother/pdfs/pdf_api.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

import '../../../model/feeding_times_model.dart';
import '../../../model/sleep_details_model.dart';

class BabyHealthPdf {
  static Future<File> generate(BabieModel model) async {
    final pdf = Document();

    pdf.addPage(MultiPage(
      margin: const EdgeInsets.all(10),
      build: (context) => [
        buildHeader(model),
        Divider(),
        SizedBox(height: .5 * PdfPageFormat.cm),
        babySleepTimes(model),
        SizedBox(height: .5 * PdfPageFormat.cm),
        Divider(),
        SizedBox(height: .5 * PdfPageFormat.cm),
        babyFeedingTimes(model),
        SizedBox(height: .5 * PdfPageFormat.cm),
        Divider(),
        SizedBox(height: .5 * PdfPageFormat.cm),
        babyVaccination(model),
        SizedBox(height: .5 * PdfPageFormat.cm),
        Divider(),
        SizedBox(height: .5 * PdfPageFormat.cm),
      ],
    ));

    return PdfApi.saveDocument(name: 'my_invoice.pdf', pdf: pdf);
  }

  static Widget buildHeader(BabieModel model) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          titleText('Genral information'),
          SizedBox(height: 0.5 * PdfPageFormat.cm),
          SizedBox(
            height: 30.h,
            child: GridView(
              childAspectRatio: 50.w / 2.h,
              crossAxisCount: 2,
              crossAxisSpacing: 50.w / 2.h,
              children: <Widget>[
                buildText(
                  title: "Name",
                  value: model.name ?? '',
                ),
                buildText(
                  title: "Height in(cm)",
                  value: model.birthLength ?? '',
                ),
                buildText(
                  title: "Head Circumference in(cm)",
                  value: model.headCircumference ?? '',
                ),
                buildText(
                  title: "Weight in(kg)",
                  value: model.birthWeight ?? '',
                ),
                buildText(
                  title: "Birth Date",
                  value: model.birthDate == null
                      ? ''
                      : model.birthDate!.split('-')[0],
                ),
                buildText(
                  title: "Gestational Age",
                  value: model.gestationalAge != null
                      ? '${model.gestationalAge!} week'
                      : '',
                ),
                buildText(
                  title: "APGAR Score",
                  value:
                      '( ${model.appearance} , ${model.pulse} , ${model.grimace} , ${model.activity} , ${model.respiration} )',
                ),
              ],
            ),
          ),
        ],
      );

  static Widget babyVaccination(BabieModel model) {
    final headers = [
      'Name',
      'Dose',
      'Site',
      'Date',
      'Next Dose Date',
    ];
    final List<List<dynamic>> data = [];
    for (var element in model.vaccinations!) {
      data.add([
        element.vaccineName,
        element.dose,
        element.administrationSite,
        element.vaccinationDate.orEmpty().split('-')[0],
        element.nextDoseDate.orEmpty().split('-')[0],
      ]);
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      titleText('Vaccination information'),
      SizedBox(height: .5 * PdfPageFormat.cm),
      TableHelper.fromTextArray(
        headers: headers,
        data: data,
        border: null,
        headerStyle: TextStyle(fontWeight: FontWeight.bold),
        headerDecoration: const BoxDecoration(color: PdfColors.grey300),
        cellHeight: 20,
        columnWidths: {
          0: const FlexColumnWidth(2),
          1: const FlexColumnWidth(1),
          2: const FlexColumnWidth(1),
          3: const FlexColumnWidth(1),
          4: const FlexColumnWidth(1),
        },
        cellAlignments: {
          0: Alignment.centerLeft,
          1: Alignment.center,
          2: Alignment.center,
          3: Alignment.center,
          4: Alignment.centerRight,
        },
      )
    ]);
  }

  static Widget babySleepTimes(BabieModel model) {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      titleText('Sleep Times information'),
      SizedBox(height: .5 * PdfPageFormat.cm),
      ...List.generate((model.sleepDetailsModel ?? []).length, (index) {
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          subTitelText(
            'Total hours : ${(model.sleepDetailsModel ?? [])[index].totalSleepDuration} - Date : ${(model.sleepDetailsModel ?? [])[index].date.orEmpty().split('-')[0]}',
          ),
          SizedBox(height: 0.5 * PdfPageFormat.cm),
          sleepDetailsTable(
              (model.sleepDetailsModel ?? [])[index].details ?? []),
        ]);
      }),
      SizedBox(height: 0.5 * PdfPageFormat.cm),
    ]);
  }

  static Widget sleepDetailsTable(List<DetailsModel> myList) {
    final headers = [
      'Sleep Quality',
      'From',
      'To',
    ];
    final List<List<dynamic>> data = [];
    for (var element in myList) {
      data.add([
        element.sleepQuality,
        element.startTime,
        element.endTime,
      ]);
    }
    return Column(children: [
      TableHelper.fromTextArray(
        headers: headers,
        data: data,
        border: null,
        cellAlignment: Alignment.center,
        headerStyle: TextStyle(fontWeight: FontWeight.bold),
        headerDecoration: const BoxDecoration(color: PdfColors.grey300),
      ),
      SizedBox(height: 0.5 * PdfPageFormat.cm),
    ]);
  }

  static Widget babyFeedingTimes(BabieModel model) {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      titleText('Feedeing times information'),
      SizedBox(height: .5 * PdfPageFormat.cm),
      ...List.generate((model.feedingTimes ?? []).length, (index) {
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          subTitelText(
              'Date : ${(model.feedingTimes ?? [])[index].date.orEmpty().split('-')[0]}'),
          SizedBox(height: 0.5 * PdfPageFormat.cm),
          feedingDetailsTable((model.feedingTimes ?? [])[index].details ?? []),
        ]);
      }),
      SizedBox(height: 0.5 * PdfPageFormat.cm),
      SizedBox(height: 0.5 * PdfPageFormat.cm),
    ]);
  }

  static Widget feedingDetailsTable(List<Feedingdetails> myList) {
    final headers = [
      'Feeding Details',
      'Feeding Time',
      'Feeding Amount in(ml)',
      'Feeding Duration in(m)',
    ];
    final List<List<dynamic>> data = [];
    for (var element in myList) {
      data.add([
        element.feedingDetails,
        element.feedingTime,
        element.feedingAmount,
        element.feedingDuration,
      ]);
    }
    return Column(children: [
      TableHelper.fromTextArray(
        headers: headers,
        data: data,
        border: null,
        cellAlignment: Alignment.center,
        headerStyle: TextStyle(fontWeight: FontWeight.bold),
        headerDecoration: const BoxDecoration(color: PdfColors.grey300),
      ),
      SizedBox(height: 0.5 * PdfPageFormat.cm),
    ]);
  }

  static Text titleText(String text) {
    return Text(text,
        style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: const PdfColor.fromInt(0xFFe0185e)),
        textAlign: TextAlign.center);
  }

  static Text subTitelText(String tetx) {
    return Text(
      tetx,
      style: TextStyle(
          fontSize: 18, fontWeight: FontWeight.bold, color: PdfColors.blueGrey),
    );
  }

  static buildText({
    required String title,
    required String value,
    TextStyle? titleStyle,
  }) {
    final style = titleStyle ??
        TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: PdfColors.blueGrey,
        );

    return Text('$title : $value', style: style);
  }
}
