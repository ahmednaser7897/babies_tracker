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
        SizedBox(height: .5 * PdfPageFormat.cm),
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

  static Widget buildHeader(BabieModel model) => Row(children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Genral information :-',
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
            ),
            buildText(
              title: "Name",
              value: model.name ?? '',
            ),
            SizedBox(height: 0.2 * PdfPageFormat.cm),
            buildText(
              title: "Height in(cm)",
              value: model.birthLength ?? '',
            ),
            SizedBox(height: 0.2 * PdfPageFormat.cm),
            buildText(
              title: "Weight in(kg)",
              value: model.birthWeight ?? '',
            ),
            SizedBox(height: 0.2 * PdfPageFormat.cm),
            buildText(
              title: "Head Circumference in(kg)",
              value: model.headCircumference ?? '',
            ),
            SizedBox(height: 0.2 * PdfPageFormat.cm),
            buildText(
              title: "Birth Date",
              value: model.birthDate ?? '',
            ),
            SizedBox(height: 0.2 * PdfPageFormat.cm),
            buildText(
              title: "Gestational Age",
              value: model.gestationalAge != null
                  ? '${model.gestationalAge!} month'
                  : '',
            ),
            SizedBox(height: 0.2 * PdfPageFormat.cm),
            buildText(
              title: "Appearance",
              value: model.appearance.toString(),
            ),
            SizedBox(height: 0.2 * PdfPageFormat.cm),
            buildText(
              title: "Grimace",
              value: model.grimace.toString(),
            ),
            SizedBox(height: 0.2 * PdfPageFormat.cm),
            buildText(
              title: "Pulse",
              value: model.pulse.toString(),
            ),
            SizedBox(height: 0.2 * PdfPageFormat.cm),
            buildText(
              title: "Respiration",
              value: model.respiration.toString(),
            ),
            SizedBox(height: 0.2 * PdfPageFormat.cm),
            buildText(
              title: "Doctor Notes",
              value: model.doctorNotes.toString(),
            ),
            SizedBox(height: 0.2 * PdfPageFormat.cm),
          ],
        )
      ]);

  static Widget babyVaccination(BabieModel model) {
    final headers = [
      'Name',
      'Dose',
      'Site',
      'Date',
      'Next Dose Date',
    ];
    final List<List<dynamic>> data = [];
    model.vaccinations!.forEach((element) {
      data.add([
        element.vaccineName,
        element.dose,
        element.administrationSite,
        element.vaccinationDate.orEmpty().split('-')[0],
        element.nextDoseDate.orEmpty().split('-')[0],
      ]);
    });
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        'Health information :-',
        style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 0.5 * PdfPageFormat.cm),
      Text(
        'Vaccination information :-',
        style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
      ),
      SizedBox(height: .3 * PdfPageFormat.cm),
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
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        'Sleep Times information :-',
        style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
      ),
      SizedBox(height: .3 * PdfPageFormat.cm),
      showSleepTimesList(
        model.sleepDetailsModel ?? [],
      ),
      SizedBox(height: 0.5 * PdfPageFormat.cm),
    ]);
  }

  static Widget showSleepTimesList(List<SleepDetailsModel> myList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(myList.length, (index) {
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            myList[index].date.orEmpty().split('-')[0],
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: PdfColors.black),
          ),
          SizedBox(height: 0.3 * PdfPageFormat.cm),
          Text(
            'Total hours : ${myList[index].totalSleepDuration} ',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.normal,
                color: PdfColors.black),
          ),
          SizedBox(height: 0.3 * PdfPageFormat.cm),
          ...List.generate(myList[index].details!.length, (index2) {
            return Text(
              '${index2 + 1} - ${myList[index].details![index2].sleepQuality} - from : ${myList[index].details![index2].startTime} - to: ${myList[index].details![index2].endTime}',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  height: 1.5,
                  color: PdfColors.black),
            );
          }),
          SizedBox(height: 0.4 * PdfPageFormat.cm),
        ]);
      }),
    );
  }

  static Widget babyFeedingTimes(BabieModel model) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        'Feedeing times information :-',
        style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
      ),
      SizedBox(height: .3 * PdfPageFormat.cm),
      showFeedingTimesList(
        model.feedingTimes ?? [],
      ),
      SizedBox(height: 0.5 * PdfPageFormat.cm),
    ]);
  }

  static Widget showFeedingTimesList(List<FeedingTimesModel> myList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(myList.length, (index) {
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            myList[index].date.orEmpty().split('-')[0],
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: PdfColors.black),
          ),
          SizedBox(height: 0.3 * PdfPageFormat.cm),
          ...List.generate(myList[index].details!.length, (index2) {
            return Text(
              '${index2 + 1} - ${myList[index].details![index2].feedingDetails} on ${myList[index].details![index2].feedingTime} - amount ${myList[index].details![index2].feedingAmount} (in ml) -  duration ${myList[index].details![index2].feedingDuration} (in m)',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  height: 1.5,
                  color: PdfColors.black),
            );
          }),
          SizedBox(height: 0.4 * PdfPageFormat.cm),
        ]);
      }),
    );
  }

  static buildSimpleText({
    required String title,
    required String value,
  }) {
    final style = TextStyle(fontWeight: FontWeight.bold);

    return Row(
      children: [
        Text(title, style: style),
        SizedBox(width: 2 * PdfPageFormat.mm),
        Text(value),
      ],
    );
  }

  static buildText({
    required String title,
    required String value,
    double width = double.infinity,
    TextStyle? titleStyle,
    bool unite = false,
  }) {
    final style =
        titleStyle ?? TextStyle(fontWeight: FontWeight.normal, fontSize: 20);

    return Container(
      width: width,
      child: Row(
        children: [
          Text('$title : ', style: style),
          Text(value, style: style),
        ],
      ),
    );
  }
}
