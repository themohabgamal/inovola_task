import 'package:flutter/material.dart';

class ConversionInfoSection extends StatelessWidget {
  final TextEditingController amountController;
  final String selectedCurrency;
  final double convertedAmount;

  const ConversionInfoSection({
    super.key,
    required this.amountController,
    required this.selectedCurrency,
    required this.convertedAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Row(
        children: [
          Icon(Icons.currency_exchange, color: Colors.blue[600], size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Converted: ${amountController.text} $selectedCurrency ≈ \$${convertedAmount.toStringAsFixed(2)} USD',
              style: TextStyle(
                color: Colors.blue[700],
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
