import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sjekk_application/data/models/rule_model.dart';
import 'package:sjekk_application/presentation/providers/rule_provider.dart';
import 'package:sjekk_application/presentation/providers/violation_details_provider.dart';
import 'package:sjekk_application/presentation/widgets/template/components/template_list_tile.dart';
import 'package:sjekk_application/presentation/widgets/template/components/template_text.dart';

class SelectRuleScreen extends StatefulWidget {
  const SelectRuleScreen({super.key});

  @override
  State<SelectRuleScreen> createState() => _SelectRuleScreenState();
}

class _SelectRuleScreenState extends State<SelectRuleScreen> {
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
              await Provider.of<ViolationDetailsProvider>(context, listen: false).addRule(rule.id);
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