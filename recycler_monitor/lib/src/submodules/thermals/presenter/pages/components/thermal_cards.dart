import 'package:flutter/material.dart';
import 'package:recycler_monitor/src/presenter/styles.dart';

class ThermalCards extends StatelessWidget {
  final String part;
  final double temperature;

  const ThermalCards(this.part, this.temperature, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // Largura adaptável ao pai (Smartphone)
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Card(
        elevation: 4,
        color: cardBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Se a tela estiver deitada (muito larga), usamos Row, senão Column
              bool isWide = constraints.maxWidth > 400;

              return isWide 
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: _buildContent(isWide),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _buildContent(isWide),
                  );
            },
          ),
        ),
      ),
    );
  }

  List<Widget> _buildContent(bool isWide) {
    return [
      Text(
        "$part: ",
        style: TextStyle(
          fontSize: isWide ? titleFontSize : titleFontSize * 0.8,
          fontWeight: FontWeight.bold,
        ),
      ),
      Text(
        "${temperature.toStringAsFixed(1)}ºC",
        style: TextStyle(
          fontSize: isWide ? temperatureFontSize : temperatureFontSize * 0.9,
          color: temperature > 180 ? Colors.redAccent : Colors.blueAccent,
        ),
      ),
    ];
  }
}