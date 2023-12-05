import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sjekk_application/data/models/rule_model.dart';
import 'package:sjekk_application/presentation/providers/rule_provider.dart';
import 'package:sjekk_application/presentation/providers/violation_details_provider.dart';
import 'package:sjekk_application/presentation/widgets/template/components/template_list_tile.dart';
import 'package:sjekk_application/presentation/widgets/template/components/template_text.dart';

import '../providers/local_violation_details_provider.dart';

class LocalSelectRuleScreen extends StatefulWidget {
  const LocalSelectRuleScreen({super.key});

  @override
  State<LocalSelectRuleScreen> createState() => _LocalSelectRuleScreenState();
}

class _LocalSelectRuleScreenState extends State<LocalSelectRuleScreen> {
  @override
  void initState() {
    super.initState();
    initializeRules();
  }

  void initializeRules() async{
    await Provider.of<RuleProvider>(context, listen: false).fetchRules();
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<RuleProvider>(
      builder: (BuildContext context, RuleProvider ruleProvider, Widget? child) { 
        if(ruleProvider.rules.isEmpty){
          return Center(
            child: TemplateHeadlineText('No rules available'),
          );
        }
        return Padding(
      padding: EdgeInsets.all(12.0),
      child: ListView.separated(
        separatorBuilder: (context,index){
          return SizedBox(height: 12,);
        },
        itemBuilder: (context, index) {
          Rule rule = ruleProvider.rules[index];
          return TemplateListTile(
            title: rule.name,
            
            subtitle: rule.charge.toString(),
            onTap: () async{
              await Provider.of<LocalViolationDetailsProvider>(context, listen: false).pushRule(rule);
              Navigator.pop(context);
            },
          );
        },
        itemCount: ruleProvider.rules.length,  
      ),
    );
      },
    );
  }
}