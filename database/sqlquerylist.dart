String createCreditReportLine =
    '''CREATE TABLE creditReportLines ("route" TEXT, "district" TEXT, "agent" TEXT, "docNum" INTEGER, 
    "deliveriDate" TEXT, "paymentType" TEXT, "client" TEXT, "cardCode" TEXT, "clientBalance" REAL, 
    "ostalos" REAL, "expired" INTEGER, "creditSum" REAL, "consignmentTotal" REAL, 
    "sumOplaty" REAL, "sumVozvrat" REAL, "orderSum" REAL , "balance" REAL, "credit7" REAL, 
    "credit14" REAL, "credit30" REAL, "transfer" REAL, "transId" INTEGER, "u_Faktura_Group" TEXT, 
    "docEntryInv" INTEGER, "docNumInv" INTEGER, "docEntryRin" INTEGER, "docNumRin" INTEGER);''';


String createTerminal =
    '''CREATE TABLE terminals ("itemCode" TEXT, "itemName" TEXT, 
    "assetSerNo" TEXT, "assetGroup" TEXT, "account" TEXT);''';