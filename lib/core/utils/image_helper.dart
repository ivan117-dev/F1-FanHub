class ImageHelper {
  // Obtener foto de Piloto
  static String getDriverImage(String driverId) {
    // Retorna: assets/drivers/max_verstappen.png
    return 'assets/drivers/$driverId.png';
  }

  // Obtener logo de Constructor
  static String getConstructorLogo(String constructorId) {
    // Retorna: assets/constructors/red_bull.png
    return 'assets/constructors/$constructorId.png';
  }
}
