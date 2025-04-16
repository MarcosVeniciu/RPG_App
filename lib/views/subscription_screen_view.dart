import 'package:flutter/material.dart';

import '../models/subscription_models.dart'; // Import models

// TODO: Import controller/provider

class SubscriptionScreenView extends StatelessWidget {
  const SubscriptionScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Connect to Controller/Provider
    // final controller = context.watch<SubscriptionScreenController>();

    // Placeholder data
    final SubscriptionStatus status = SubscriptionStatus(
      currentPlan: SubscriptionPlan(id: 'basic_monthly_20', name: 'Basic', adventureLimit: 20, price: 'R\$ 9,99/mês', details: ''),
      remainingAdventures: 15,
    );
    final List<SubscriptionPlan> plans = [
      SubscriptionPlan(id: 'basic_monthly_20', name: 'Basic', adventureLimit: 20, price: 'R\$ 9,99/mês', details: 'Acesso a 20 aventuras por mês.'),
      SubscriptionPlan(id: 'premium_monthly_50', name: 'Premium', adventureLimit: 50, price: 'R\$ 19,99/mês', details: 'Acesso a 50 aventuras por mês e conteúdo exclusivo.'),
    ];
    final IndividualPurchase individualOption = IndividualPurchase(id: 'extra_adventure_1', adventuresCount: 1, price: 'R\$ 1,99');
    bool isLoading = false; // Placeholder

    return Scaffold(
      appBar: AppBar(
        title: const Text('Subscription & Purchases'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Current Status Section ---
                  _buildStatusSection(context, status),
                  const SizedBox(height: 32),

                  // --- Subscription Tiers Section ---
                  Text(
                    'Subscription Plans',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.blue.shade300),
                  ),
                  const SizedBox(height: 16),
                  ListView.builder(
                    shrinkWrap: true, // Important inside SingleChildScrollView
                    physics: const NeverScrollableScrollPhysics(), // Disable ListView's own scrolling
                    itemCount: plans.length,
                    itemBuilder: (context, index) {
                      final plan = plans[index];
                      final isCurrentPlan = status.currentPlan?.id == plan.id;
                      return _buildTierCard(
                        context,
                        plan: plan,
                        isCurrent: isCurrentPlan,
                        onSubscribe: () {
                          // TODO: Call controller.handleSubscribe(plan.id)
                          print("Subscribe tapped for ${plan.name}");
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 32),

                  // --- Individual Purchase Section ---
                   Text(
                    'Buy Extra Adventures',
                     style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.blue.shade300),
                  ),
                  const SizedBox(height: 16),
                  _buildIndividualPurchaseCard(
                    context,
                    option: individualOption,
                    onBuyNow: () {
                       // TODO: Call controller.handleBuyNow()
                       print("Buy Now tapped for extra adventure");
                    }
                  ),
                ],
              ),
            ),
    );
  }

  // Helper Widget for Status Section
  Widget _buildStatusSection(BuildContext context, SubscriptionStatus status) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Status',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Divider(height: 20, thickness: 1),
            Text(
              'Current Plan: ${status.currentPlan?.name ?? 'None'}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
             Text(
              'Remaining Adventures: ${status.remainingAdventures}',
               style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }

  // Helper Widget for Subscription Tier Card
  Widget _buildTierCard(BuildContext context, {required SubscriptionPlan plan, required bool isCurrent, required VoidCallback onSubscribe}) {
    return Card(
       margin: const EdgeInsets.symmetric(vertical: 8.0),
       child: Padding(
         padding: const EdgeInsets.all(16.0),
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Text(plan.name, style: Theme.of(context).textTheme.titleLarge),
             const SizedBox(height: 4),
             Text(plan.price, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.blue.shade200)),
             const SizedBox(height: 8),
             Text('${plan.adventureLimit} adventures per month', style: Theme.of(context).textTheme.bodyMedium),
             Text(plan.details, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey.shade400)),
             const SizedBox(height: 16),
             Align(
               alignment: Alignment.centerRight,
               child: ElevatedButton(
                 onPressed: isCurrent ? null : onSubscribe, // Disable if already subscribed
                 style: ElevatedButton.styleFrom(
                   backgroundColor: isCurrent ? Colors.grey.shade700 : null, // Grey out if current
                 ),
                 child: Text(isCurrent ? 'Current Plan' : 'Subscribe'),
               ),
             ),
           ],
         ),
       ),
    );
  }

   // Helper Widget for Individual Purchase Card
  Widget _buildIndividualPurchaseCard(BuildContext context, {required IndividualPurchase option, required VoidCallback onBuyNow}) {
     return Card(
       margin: const EdgeInsets.symmetric(vertical: 8.0),
       child: Padding(
         padding: const EdgeInsets.all(16.0),
         child: Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
             Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Text(
                   '${option.adventuresCount} Extra Adventure${option.adventuresCount > 1 ? 's' : ''}',
                    style: Theme.of(context).textTheme.titleMedium
                  ),
                 const SizedBox(height: 4),
                 Text(option.price, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.blue.shade200)),
               ],
             ),
             ElevatedButton(
               onPressed: onBuyNow,
               child: const Text('Buy Now'),
             ),
           ],
         ),
       ),
    );
  }
}