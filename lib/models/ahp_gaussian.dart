class AhpGaussian {
  final List<Map<String, dynamic>> options;
  final Map<String, double> criteriaWeights;

  AhpGaussian(this.options, this.criteriaWeights);

  Map<String, dynamic> calculateBestOption() {
    List<Map<String, dynamic>> scoredOptions = options.map((option) {
      double score = 0.0;
      criteriaWeights.forEach((criterion, weight) {
        score += (option[criterion] ?? 0) * weight;
      });
      return {
        "name": option["name"],
        "score": score,
      };
    }).toList();

    scoredOptions.sort((a, b) => b["score"].compareTo(a["score"]));
    return scoredOptions.first;
  }
}
