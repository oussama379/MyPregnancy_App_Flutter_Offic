import 'package:ma_grossesse/ui/pages/weightMeasurments/weightModel.dart';

class HistoryModel {
  String key;
  WeightModel weightModel;

  HistoryModel(this.key, this.weightModel);

  factory HistoryModel.fromJson(Map<String, dynamic> data) {
    print(data);
    final key = data.keys as String?;
    final weightModel = data.values as WeightModel?;
    return HistoryModel(key!, weightModel!);
  }
}