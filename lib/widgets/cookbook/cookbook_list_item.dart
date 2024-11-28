import 'package:flutter/material.dart';
import 'package:mon_petit_carnet/models/cookbook.dart';
import 'package:mon_petit_carnet/utils/date_formatter.dart';

class CookbookListItem extends StatelessWidget {
  final Cookbook cookbook;
  final VoidCallback onTap;

  const CookbookListItem({
    super.key,
    required this.cookbook,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      cookbook.name,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  Text(
                    DateFormatter.formatDate(cookbook.createdAt),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'ID: ${cookbook.uniqueIdentifier}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.people_outline, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    '${cookbook.sharedWith.length} participant${cookbook.sharedWith.length > 1 ? 's' : ''}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}