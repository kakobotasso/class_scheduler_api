import 'dart:async';
import 'package:aqueduct/aqueduct.dart';   

class Migration5 extends Migration { 
  @override
  Future upgrade() async {
   		database.addColumn("_Klass", SchemaColumn.relationship("teacher", ManagedPropertyType.bigInteger, relatedTableName: "_User", relatedColumnName: "id", rule: DeleteRule.nullify, isNullable: true, isUnique: false));
		database.addColumn("_Klass", SchemaColumn.relationship("type", ManagedPropertyType.bigInteger, relatedTableName: "_KlassType", relatedColumnName: "id", rule: DeleteRule.nullify, isNullable: true, isUnique: false));
		database.deleteColumn("_Klass", "teacherName");
  }
  
  @override
  Future downgrade() async {}
  
  @override
  Future seed() async {}
}
    