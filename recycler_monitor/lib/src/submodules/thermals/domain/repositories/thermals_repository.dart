abstract class IThermalsRepository {
  Future<double> getSiloTemp();
  Future<double> getTubeTemp();
  Future<double> getNozzleTemp();
}